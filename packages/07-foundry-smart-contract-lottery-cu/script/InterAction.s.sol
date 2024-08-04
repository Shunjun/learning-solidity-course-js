// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() internal returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinatorV2_5 = helperConfig.getConfigByChainId(block.chainid).vrfCoordinatorV2_5;
        return createSubscription(vrfCoordinatorV2_5);
    }

    function createSubscription(address vrfCoordinatorV2_5) public returns (uint256, address) {
        console.log(vrfCoordinatorV2_5);

        VRFCoordinatorV2_5Mock vrfCoordinator = VRFCoordinatorV2_5Mock(vrfCoordinatorV2_5);
        vm.startBroadcast();
        uint256 subId = vrfCoordinator.createSubscription();
        vm.stopBroadcast();
        return (subId, vrfCoordinatorV2_5);
    }

    function run() external returns (uint256, address) {
        return createSubscriptionUsingConfig();
    }
}

// contract FounSubscriptions is Script {
//     function fundSubscriptionUsingConfig() {}

//     function fundSubscription() {}

//     function run() {}
// }
