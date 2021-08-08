import hre, { ethers } from "hardhat";
import "@nomiclabs/hardhat-etherscan";
import chalk from "chalk";
import { Contract } from "ethers";
import ProgressBar from "progress";

const { constants } = require("../test/TestConstants")

const verifiableNetwork = ["mainnet", "ropsten", "rinkeby", "goerli", "kovan", "polygon", "mumbai"];

async function main() {


  console.log("DONE");

}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
