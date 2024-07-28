// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {ConfigHelper} from "../../script/ConfigHelper.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract IntegrationsTest is Test, ZkSyncChainChecker {
    FundMe public fundMe;
    ConfigHelper configHelper;

    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint256 public constant GAS_PRICE = 1;
    address public constant USER = address(1);

    function setUp() external {
        // fundMe = new FundMe();
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.deployFundMe();
        configHelper = new ConfigHelper();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrowFundMe = new WithdrawFundMe();
        withdrowFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }
}
