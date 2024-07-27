import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import { network } from "hardhat"
import { networkConfig, developmentChains } from "../helper-hardhat-config"
import verify from "../utils/verify"

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { getNamedAccounts, deployments } = hre
  const { deploy, log, get } = deployments
  const { deployer } = await getNamedAccounts()
  const networkName = network.name || "localhost"

  let ethUsdPriceFeedAddress: string
  if (developmentChains.includes(network.name)) {
    const ethUsdPriceFeed = await deployments.get("MockV3Aggregator")
    ethUsdPriceFeedAddress = ethUsdPriceFeed.address
  } else {
    ethUsdPriceFeedAddress = networkConfig[networkName].ethUsdPriceFeed || ""
  }

  const args = [ethUsdPriceFeedAddress]
  const fundMe = await deploy("FundMe", {
    from: deployer,
    args, // put the price feed address here
    log: true,
    waitConfirmations: networkConfig[networkName].blockConfirmations || 1,
  })
  log(`Contract deployed to ${fundMe.address}`)

  if (
    !developmentChains.includes(networkName) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    verify(fundMe.address, args)
  }
  log("--------------------------------------")
}

func.tags = ["all"]

export default func
