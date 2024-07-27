// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    constructor() {}

    function run() public returns (SimpleStorage) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // vm.rpcUrl(rpcUrl);
        vm.startBroadcast(deployerPrivateKey);
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();

        return simpleStorage;
    }
}
