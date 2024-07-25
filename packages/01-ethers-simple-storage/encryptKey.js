require("dotenv").config()
const ethers = require("ethers")
const fs = require("fs-extra")

async function main() {
  const private_key = process.env.PRIVATE_KEY
  const password = process.env.PASSWORD

  const wallet = new ethers.Wallet(private_key)

  const encryptJsonKey = await wallet.encrypt(password)

  fs.writeFileSync("./encryptJsonKey.json", encryptJsonKey)
}

main()
