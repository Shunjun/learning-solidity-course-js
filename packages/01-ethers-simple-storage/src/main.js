const ethers = require("ethers");
const fs = require("fs-extra");
const path = require("path");
const { password: inquirerPassword } = require("@inquirer/prompts");

async function main() {
  const provider = new ethers.providers.JsonRpcProvider(
    "HTTP://127.0.0.1:7545"
  );
  const encryptJson = fs.readFileSync(
    path.resolve(__dirname, "../encryptJsonKey.json")
  );

  const password = await inquirerPassword({ message: "Enter your password:" });

  const wallet = ethers.Wallet.fromEncryptedJsonSync(
    encryptJson,
    password
  ).connect(provider);

  const abi = fs.readFileSync(
    path.resolve(
      __dirname,
      "../build/contracts_SimpleStorage_sol_SimpleStorage.abi"
    ),
    "utf-8"
  );
  const bytecode = fs.readFileSync(
    path.resolve(
      __dirname,
      "../build/contracts_SimpleStorage_sol_SimpleStorage.bin"
    ),
    "utf-8"
  );

  const contractFactory = new ethers.ContractFactory(abi, bytecode, wallet);
  const contract = await contractFactory.deploy();
  const transactonReceipt = await contract.deployTransaction.wait(1);

  console.log(transactonReceipt);

  await contract.store(100).then((transactionResponse) => {
    return transactionResponse.wait(1);
  });
  const favoriteNumber = await contract.retrieve();

  console.log(favoriteNumber.toString());
}

main();
