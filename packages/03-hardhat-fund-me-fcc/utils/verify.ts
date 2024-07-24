import { run } from "hardhat"

const verify = async (contractAddress: string, args: any) => {
    console.log("Verifying contract on etherscan")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        })
    } catch (err: any) {
        if (err.message.toLowerCase().includes("already verified")) {
            console.log("Contract already verified")
        } else {
            console.log(err)
        }
    }
}

export default verify
