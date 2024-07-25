const { ethers } = require("hardhat")
const { assert } = require("chai")

describe("Simple Storage", () => {
  let simpleFactory, simpleContract

  beforeEach(async () => {
    simpleFactory = await ethers.getContractFactory("SimpleStorage")
    simpleContract = await simpleFactory.deploy()
  })

  it("should start with favorite numbe for 0", async () => {
    const currentValue = await simpleContract.retrieve()
    const expectedValue = 0

    assert.equal(currentValue.toString(), expectedValue.toString())
  })

  it("should update when we call store", async () => {})
})
