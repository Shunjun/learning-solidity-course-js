const { ethers, run, network } = require("hardhat")

async function main() {
  const simpleContractFactory = await ethers.getContractFactory("SimpleStorage")
  const simpleContract = await simpleContractFactory.deploy()

  await simpleContract.waitForDeployment()

  console.log(network.config)

  if (network.config.chainId === 31337 && process.env.ETHERSCAN_API_KEY) {
    await simpleContract.deploymentTransaction().wait(6)
    const address = await simpleContract.getAddress()
    await verify(address, [])
  }

  const currentValue = await simpleContract.retrieve()
  console.log("Current value of the contract is: ", currentValue.toString())

  const transactionResponse = await simpleContract.store(42)
  await transactionResponse.wait(1)
  const updatedValue = await simpleContract.retrieve()
  console.log(`updated value is ${updatedValue}`)
}

async function verify(contractAddress, args) {
  console.log("Verifying contract on etherscan")

  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    })
  } catch (err) {
    if (err.message.toLowerCase().includes("already verified")) {
      console.log("Contract already verified")
    } else {
      console.log(e)
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
