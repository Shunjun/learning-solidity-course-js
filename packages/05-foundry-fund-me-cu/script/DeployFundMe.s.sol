// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {ConfigHelper} from "./ConfigHelper.s.sol";

contract DeployFundMe is Script {
    function deployFundMe() public returns (FundMe) {
        ConfigHelper configHelper = new ConfigHelper();
        // address priceFeed = configHelper
        //     .getConfigByChainId(block.chainid)
        //     .priceFeed;

        address priceFeed = configHelper.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return (fundMe);
    }

    function run() external returns (FundMe) {
        return deployFundMe();
    }
}
