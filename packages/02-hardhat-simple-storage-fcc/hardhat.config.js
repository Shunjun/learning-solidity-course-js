require("@nomicfoundation/hardhat-toolbox")
require("dotenv").config()
require("@nomicfoundation/hardhat-verify")
require("./tasks/block-number")
require("hardhat-gas-reporter")

const ganacheUrl = process.env.GANACHE_URL
const ganachePriviteKey = process.env.GANACHE_PRIVATE_KEY
const ehterscanApiKey = process.env.EHTERSCAN_API_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.8",

  defaultNetwork: "ganache",
  networks: {
    ganache: {
      url: ganacheUrl,
      accounts: [ganachePriviteKey],
    },
  },
  etherscan: {
    apiKey: ehterscanApiKey,
  },
  gasReporter: {
    enabled: true,
  },
}
