import hre, { ethers } from "hardhat";
import "@nomiclabs/hardhat-etherscan";
import chalk from "chalk";
import fs from "fs";
import { Contract } from "ethers";
import ProgressBar from "progress";

const { constants } = require("../test/TestConstants")

// For waiting to not spam public RPCs on deploy
const pause = (time) => new Promise(resolve => setTimeout(resolve, time));
// If deploy network is here, will attempt to verify on Etherscan
const verifiableNetwork = ["mainnet", "ropsten", "rinkeby", "goerli", "kovan", "polygon", "mumbai"];

const deploy = async (contractName, _args = [], overrides = {}, libraries = {}) => {
  console.log(`👀 Deploying: ${contractName}`);

  const contractArgs = _args || [];
  const stringifiedArgs = JSON.stringify(contractArgs);
  const contractArtifacts = await ethers.getContractFactory(contractName, { libraries: libraries });
  const contract = await contractArtifacts.deploy(...contractArgs, overrides);
  const contractAddress = contract.address;
  fs.writeFileSync(`artifacts/${contractName}.address`, contractAddress);
  fs.writeFileSync(`artifacts/${contractName}.args`, stringifiedArgs);

  // tslint:disable-next-line: no-console
  console.log("Deploying", chalk.cyan(contractName), "contract to", chalk.magenta(contractAddress));

  await contract.deployed();

  const deployed = { name: contractName, address: contractAddress, args: contractArgs, contract };

  return deployed
}


async function main() {
  const network = process.env.HARDHAT_NETWORK === undefined ? "localhost" : process.env.HARDHAT_NETWORK;

  console.log("🚀 Deploying to", chalk.magenta(network), "!");
  if (
    network === "localhost" ||
    network === "hardhat"
  ) {
    const [deployer] = await ethers.getSigners();

    console.log(
      chalk.cyan("deploying contracts with the account:"),
      chalk.green(deployer.address)
    );

    console.log("Account balance:", (await deployer.getBalance()).toString());
  }

  // this array stores the data for contract verification
  let contracts = [];

  // some notes on the deploy function: 
  //    - arguments should be passed in an array after the contract name
  //      args need to be formatted properly for verification to pass
  //      see: https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#complex-arguments
  //      example: await deploy("Token", ["Test", "TST"]);
  //    - custom ethers parameters like gasLimit go in an object after that
  //      EVEN IF THERE ARE NO ARGS (put an empty array for the args)
  //      example: await deploy("Token", [], { gasLimit: 300000 });
  //    - libraries can be added by address after that
  //      example: await deploy("Token", [], {}, { "SafeMath": "0x..."});
  //    - function calls: use this format: `token.contact.mint()`
  const token = await deploy("Token");

  

  // make sure to push contract details - it's needed for verification
  contracts.push(token);

  // verification
  if (verifiableNetwork.includes(network)) {
    let counter = 0;

    // tslint:disable-next-line: no-console
    console.log("Beginning Etherscan verification process...\n",
      chalk.yellow(`WARNING: The process will wait two minutes for Etherscan \nto update their backend before commencing, please wait \nand do not stop the terminal process...`)
    );

    const bar = new ProgressBar('Etherscan update: [:bar] :percent :etas', {
      total: 50,
      complete: '\u2588',
      incomplete: '\u2591',
    });
    // two minute timeout to let Etherscan update
    const timer = setInterval(() => {
      bar.tick();
      if (bar.complete) {
        clearInterval(timer);
      }
    }, 2300);

    await pause(120000);

    // there may be some issues with contracts using libraries 
    // if you experience problems, refer to https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#providing-libraries-from-a-script-or-task
    console.log(chalk.cyan("\n🔍 Running Etherscan verification..."));

    await Promise.all(contracts.map(async contract => {
      // tslint:disable-next-line: no-console
      console.log(`Verifying ${contract.name}...`);
      try {
        await hre.run("verify:verify", {
          address: contract.address,
          constructorArguments: contract.args
        });
        // tslint:disable-next-line: no-console
        console.log(chalk.cyan(`✅ ${contract.name} verified!`));
      } catch (error) {
        // tslint:disable-next-line: no-console
        console.log(error);
      }
    }));
  }

  // todos: add table
  // todo: don't forget to clean up when ready
}



main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });



