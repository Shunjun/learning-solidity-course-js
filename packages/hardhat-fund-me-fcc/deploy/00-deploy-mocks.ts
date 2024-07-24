import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import { network } from "hardhat"
import { networkConfig, developmentChains } from "../helper-hardhat-config"

const INITIAL_PRICE = 200000000000
const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
    const { getNamedAccounts, deployments } = hre
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId || 0

    console.log(chainId)

    if (developmentChains.includes(network.name)) {
        log("deploying mocks on development network")
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [INITIAL_PRICE],
        })
        log("deployed Mocks")
        log("--------------------------------------")
        log(
            "You are deploying to a local network, you'll need a local network running to interact",
        )
        log(
            "Please run `npx hardhat console` to interact with the deployed smart contracts!",
        )
        log("------------------------------------------------")
    }
}

export const tags = ["mocks", "all"]

export default func
