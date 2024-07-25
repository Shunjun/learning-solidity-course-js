import type { HardhatUserConfig } from "hardhat/config"
import "@nomicfoundation/hardhat-ethers"
import "hardhat-deploy"
import "hardhat-deploy-ethers"
import "hardhat-gas-reporter"
import "@nomicfoundation/hardhat-verify"

import { config as dotConfig } from "dotenv"

dotConfig()
const ehterscanApiKey = process.env.EHTERSCAN_API_KEY
const SOPOLIA_RPC_URL = process.env.SOPOLIA_RPC_URL
const PRIVATE_KEY = process.env.PRIVATE_KEY || ""

const config: HardhatUserConfig = {
  solidity: "0.8.8",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      // gasPrice: 130000000000,
    },
    sepolia: {
      url: SOPOLIA_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 11155111,
    },
  },
  gasReporter: {
    enabled: !!process.env.REPORT_GAS,
    currency: "USD",
  },
  etherscan: {
    apiKey: ehterscanApiKey,
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
}

export default config
