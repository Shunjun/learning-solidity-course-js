import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers"
import { FundMe, MockV3Aggregator } from "../../typechain-types"
import { ethers, network } from "hardhat"
import { developmentChains } from "../../helper-hardhat-config"
import { expect } from "chai"

describe("FundMe", () => {
  let fundMe: FundMe
  let MockV3Aggregator: MockV3Aggregator
  let deployer: SignerWithAddress

  beforeEach(async () => {
    if (!developmentChains.includes(network.name)) {
      throw new Error("Please use a forked network")
    }
    const accounts = await ethers.getSigners()
    deployer = accounts[0]

    const mockV3AggregatorFactory =
      await ethers.getContractFactory("MockV3Aggregator")
    MockV3Aggregator = await mockV3AggregatorFactory.deploy(
      ethers.parseUnits("200", 8),
    )
    await MockV3Aggregator.waitForDeployment()

    const fundMeFactory = await ethers.getContractFactory("FundMe")
    fundMe = await fundMeFactory.deploy(MockV3Aggregator)
  })

  describe("constructor", () => {
    it("", async () => {
      const priceFeed = await fundMe.getPriceFeed()
      const expectedPriceFeedAddress = await MockV3Aggregator.getAddress()
      expect(priceFeed).equal(expectedPriceFeedAddress)
    })
  })

  describe("fund", () => {
    it("Fails if you don't send enough ETH", async () => {
      expect(fundMe.fund()).to.be.revertedWith("You need to spend more ETH!")
    })

    // we could be even more precise here by making sure exactly $50 works
    // but this is good enough for now
    it("Updates the amount funded data structure", async () => {
      await fundMe.fund({ value: ethers.parseEther("1") })
      const response = await fundMe.getAddressToAmountFunded(deployer.address)
      expect(response.toString()).to.be.equal(ethers.parseEther("1").toString())
    })

    it("Adds funder to array of funders", async () => {
      await fundMe.fund({ value: ethers.parseEther("1") })
      const response = await fundMe.s_funders(0)
      expect(response).to.be.equal(deployer.address)
    })
  })
})
