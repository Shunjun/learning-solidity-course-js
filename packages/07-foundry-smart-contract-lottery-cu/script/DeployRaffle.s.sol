// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription} from "./InterAction.s.sol";

contract DeployRaffle is Script {
    function run() external {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetWorkConfig memory config = helperConfig.getConfig();

        if (config.subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription();

            (config.subscriptionId, config.vrfCoordinatorV2_5) = createSubscription.createSubscription(
                config.vrfCoordinatorV2_5
            );
        }

        vm.startBroadcast();
        new Raffle(
            config.gasLane,
            config.automationUpdateInterval,
            config.raffleEntranceFee,
            config.subscriptionId,
            config.callbackGasLimit,
            config.vrfCoordinatorV2_5
        );
        vm.stopBroadcast();
    }
}
