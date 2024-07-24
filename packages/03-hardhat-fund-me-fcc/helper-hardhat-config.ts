interface NetworkConfig {
    name: string
    ethUsdPriceFeed?: string
}

export const networkConfig: Record<number, NetworkConfig> = {
    31337: {
        name: "localhost",
    },
    11155111: {
        name: "sepolia",
        ethUsdPriceFeed: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
    },
}

export const developmentChains: (string | number)[] = ["hardhat", "localhost"]
