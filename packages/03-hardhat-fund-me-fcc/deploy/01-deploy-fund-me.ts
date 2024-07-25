import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import { network } from "hardhat"
import { networkConfig, developmentChains } from "../helper-hardhat-config"
import verify from "../utils/verify"

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { getNamedAccounts, deployments } = hre
  const { deploy, log, get } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId || 0

  let ethUsdPriceFeedAddress: string
  if (developmentChains.includes(network.name)) {
    const ethUsdPriceFeed = await deployments.get("MockV3Aggregator")
    ethUsdPriceFeedAddress = ethUsdPriceFeed.address
  } else {
    ethUsdPriceFeedAddress = networkConfig[chainId].ethUsdPriceFeed || ""
  }

  const args = [ethUsdPriceFeedAddress]
  const fundMe = await deploy("FundMe", {
    from: deployer,
    args, // put the price feed address here
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  })
  log(`Contract deployed to ${fundMe.address}`)

  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    verify(fundMe.address, args)
  }
  log("--------------------------------------")
}

export const tags = ["all"]

export default func
