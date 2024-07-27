interface NetworkConfig {
  name: string
  ethUsdPriceFeed?: string
  blockConfirmations?: number
}

export const networkConfig: Record<string, NetworkConfig> = {
  localhost: {
    name: "localhost",
  },
  hardhat: {
    name: "hardhat",
  },
  sepolia: {
    name: "sepolia",
    ethUsdPriceFeed: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
    blockConfirmations: 6,
  },
}

export const developmentChains: (string | number)[] = ["hardhat", "localhost"]
