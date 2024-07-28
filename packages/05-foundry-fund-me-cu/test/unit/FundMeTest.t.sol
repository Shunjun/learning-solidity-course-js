// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {ConfigHelper} from "../../script/ConfigHelper.s.sol";

contract FundMeTest is Test, ZkSyncChainChecker {
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

    function testOwnerIsMesageSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    // function testPriceFeedSetCorrectly() public skipZkSync {
    //     address retreivedPriceFeed = fundMe.getPriceFeed();
    //     address expectedPriceFeed = configHelper.activeNetworkConfig();
    //     assertEq(retreivedPriceFeed, expectedPriceFeed);
    // }

    function testFundFailsWithoutEnoughETH() public skipZkSync {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public skipZkSync {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFundede = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFundede, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        assert(address(fundMe).balance > 0);
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(address(3));
        fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() public funded {
        uint256 startFundeMeBalance = address(fundMe).balance;
        uint256 startOwnerBalance = fundMe.getOwner().balance;

        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        uint256 endFundeMeBalance = address(fundMe).balance;
        uint256 endOwnerBalance = fundMe.getOwner().balance;

        assertEq(endFundeMeBalance, 0);
        assertEq(startOwnerBalance + startFundeMeBalance, endOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (
            uint160 i = startingFunderIndex;
            i < numberOfFunders + startingFunderIndex;
            i++
        ) {
            hoax(address(i), STARTING_USER_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startFundeMeBalance = address(fundMe).balance;
        uint256 startOwnerBalance = fundMe.getOwner().balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        assert(address(fundMe).balance == 0);
        assert(
            startFundeMeBalance + startOwnerBalance == fundMe.getOwner().balance
        );
        assert(
            (numberOfFunders) * SEND_VALUE ==
                address(fundMe.getOwner()).balance - startOwnerBalance
        );
    }
}
