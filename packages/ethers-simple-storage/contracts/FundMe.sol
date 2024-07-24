// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant minimumUsd = 10 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address onwer;

    constructor() {
        onwer = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "Didn't send enough!"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withDraw() public onlyOnwer {
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOnwer() {
        require(msg.sender == onwer, "only onwer can call this function");
        _;
    }
}
