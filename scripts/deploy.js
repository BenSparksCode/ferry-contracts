import hre, { ethers } from "hardhat";
import "@nomiclabs/hardhat-etherscan";
import chalk from "chalk";
import fs from "fs";
import { Contract } from "ethers";
import ProgressBar from "progress";

const { constants } = require("../test/TestConstants")
const verifiableNetwork = ["mainnet", "ropsten", "rinkeby", "goerli", "kovan", "polygon", "mumbai"];

const deploy = async (contractName, _args = [], overrides = {}, libraries = {}) => {
  console.log(` 👀  Deploying: ${contractName}`);

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


  console.log("DONE");

}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });


// For waiting to not spam public RPCs on deploy
const pause = (time) => new Promise(resolve => setTimeout(resolve, time));
