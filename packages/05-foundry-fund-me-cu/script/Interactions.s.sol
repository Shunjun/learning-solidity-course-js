// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

// 1.Fund
contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address recentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(recentlyDeployedAddress)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe contract with %d", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );

        fundFundMe(mostRecentlyDeployed);
    }
}

// 2.withdraw

contract WithdrawFundMe is Script {
    function withdrawFundMe(address recentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(recentlyDeployedAddress)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrow FundMe contract");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(mostRecentlyDeployed);
    }
}
