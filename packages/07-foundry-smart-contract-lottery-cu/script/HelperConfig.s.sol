// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

abstract contract CodeConstants {
    uint96 public MOCK_BASE_FEE = 0.25 ether;
    uint96 public MOCK_GAS_PRICE_LINK = 1e9;
    // LINK / ETH price
    int256 public MOCK_WEI_PER_UINT_LINK = 4e15;

    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ETH_MAINNET_CHAIN_ID = 1;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is CodeConstants, Script {
    error HelperConfig__InvalidChainId();

    struct NetWorkConfig {
        bytes32 gasLane;
        uint256 automationUpdateInterval;
        uint256 raffleEntranceFee;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
        address vrfCoordinatorV2_5;
        address account;
    }

    mapping(uint256 chainId => NetWorkConfig) public netWorkConfigs;

    constructor() {
        netWorkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
        netWorkConfigs[ETH_MAINNET_CHAIN_ID] = getMainnetEthConfig();
    }

    function getConfig() public returns (NetWorkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getConfigByChainId(uint256 chainId) public returns (NetWorkConfig memory) {
        if (netWorkConfigs[chainId].gasLane != 0) {
            return netWorkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getSepoliaEthConfig() internal pure returns (NetWorkConfig memory) {
        return
            NetWorkConfig({
                gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
                automationUpdateInterval: 30,
                raffleEntranceFee: 0.01 ether,
                subscriptionId: 0, // If left as 0, our scripts will create one!
                callbackGasLimit: 500000, // 500,000 gas
                vrfCoordinatorV2_5: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
                account: 0x3005E0B8e66e26Ef363C9f5FE3C35071D6fA8709
            });
    }

    function getMainnetEthConfig() internal pure returns (NetWorkConfig memory) {
        return
            NetWorkConfig({
                gasLane: 0x8077df514608a09f83e4e8d300645594e5d7234665448ba83f51a50f842bd3d9,
                automationUpdateInterval: 30,
                raffleEntranceFee: 0.01 ether,
                subscriptionId: 0, // If left as 0, our scripts will create one!
                callbackGasLimit: 500000, // 500,000 gas
                vrfCoordinatorV2_5: 0xD7f86b4b8Cae7D942340FF628F82735b7a20893a,
                account: 0x3005E0B8e66e26Ef363C9f5FE3C35071D6fA8709
            });
    }

    function getOrCreateAnvilEthConfig() internal returns (NetWorkConfig memory) {
        NetWorkConfig memory localNetWorkConfig = netWorkConfigs[LOCAL_CHAIN_ID];
        if (localNetWorkConfig.vrfCoordinatorV2_5 != address(0)) {
            return localNetWorkConfig;
        }

        console2.log(unicode"⚠️ You have deployed a mock conract!");
        console2.log("Make sure this was intentional");
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinatorV2_5 = new VRFCoordinatorV2_5Mock(
            MOCK_BASE_FEE,
            MOCK_GAS_PRICE_LINK,
            MOCK_WEI_PER_UINT_LINK
        );
        uint256 subscriptionId = vrfCoordinatorV2_5.createSubscription();
        vm.stopBroadcast();
        return
            NetWorkConfig({
                gasLane: 0x8077df514608a09f83e4e8d300645594e5d7234665448ba83f51a50f842bd3d9,
                automationUpdateInterval: 30,
                raffleEntranceFee: 0.01 ether,
                subscriptionId: subscriptionId,
                callbackGasLimit: 500000, // 500,000 gas
                vrfCoordinatorV2_5: address(vrfCoordinatorV2_5),
                account: 0x3005E0B8e66e26Ef363C9f5FE3C35071D6fA8709
            });
    }
}
