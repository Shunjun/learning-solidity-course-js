import { ethers, network } from "hardhat"
import { developmentChains } from "../../helper-hardhat-config"

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules"

const INITIAL_PRICE = ethers.formatUnits("200", "gwei")
const MocksModule = buildModule("MocksModule", (m) => {
  // if (developmentChains.includes(network.name)) {
  const initialPrice = m.getParameter("initialPrice", INITIAL_PRICE)
  const mockV3Aggregator = m.contract("MockV3Aggregator", [initialPrice])

  console.log("deployed Mocks")
  console.log("--------------------------------------")
  console.log(
    "You are deploying to a local network, you'll need a local network running to interact",
  )
  console.log(
    "Please run `npx hardhat console` to interact with the deployed smart contracts!",
  )
  console.log("------------------------------------------------")
  return { mockV3Aggregator }
  // }
})
