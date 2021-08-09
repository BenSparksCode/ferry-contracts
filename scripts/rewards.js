const hre = require("hardhat");
const { ethers } = require("hardhat");
require("@nomiclabs/hardhat-etherscan");
const SuperfluidSDK = require("@superfluid-finance/js-sdk");
const chalk = require("chalk");
const fs = require("fs");
const ProgressBar = require("progress");

const { constants } = require("../test/TestConstants")

// UPDATE THESE VARS BEFORE RUNNING
// -------------------------------
const ShipTokenAddress = "0x"
const SuperSHIPAddress = "0x"
// -------------------------------

const gasLimit = 5000000      // 5 million
const gasPrice = 5000000000   // 5 gwei

const sfSDK = new SuperfluidSDK.Framework({
    ethers: ethers.provider
})


// For waiting to not spam public RPCs on deploy
const pause = (time) => new Promise(resolve => setTimeout(resolve, time));
// If deploy network is here, will attempt to verify on Etherscan
const verifiableNetwork = ["mainnet", "ropsten", "rinkeby", "goerli", "kovan", "polygon", "mumbai"];



async function main() {
    const network = process.env.HARDHAT_NETWORK === undefined ? "localhost" : process.env.HARDHAT_NETWORK;

    console.log("🚀 Setting staking rewards on", chalk.magenta(network), "!");

    const [deployer] = await ethers.getSigners();

    console.log(
        chalk.cyan("Setting up staking rewards with the account:"),
        chalk.green(deployer.address)
    );

    console.log("Account balance:", (await deployer.getBalance()).toString());

    console.log("Initializing Superfluid SDK...");
    await sfSDK.initialize()
    console.log("✨ Superfluid SDK initialized");

    await pause(2000)

    const SuperSHIPObject = {
        name: constants.DEPLOY.SuperSHIP.name,
        address: SuperSHIPAddress,
        args: {} //TODO get the constructor args for contract
    }

    let contracts = []
    contracts.push(SuperSHIPObject)

    // === VERIFICATION ===
    if (verifiableNetwork.includes(network)) {
        console.log("Beginning Etherscan verification process...\n",
            chalk.yellow(`WARNING: The process will wait two minutes for Etherscan \nto update their backend before commencing, please wait \nand do not stop the terminal process...`)
        );

        const bar = new ProgressBar('Etherscan update: [:bar] :percent :etas', {
            total: 50,
            complete: '\u2588',
            incomplete: '\u2591',
        });
        // 1 minute timeout to let Etherscan update
        const timer = setInterval(() => {
            bar.tick();
            if (bar.complete) {
                clearInterval(timer);
            }
        }, 2300);

        await pause(60000);

        // there may be some issues with contracts using libraries 
        // if you experience problems, refer to https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html#providing-libraries-from-a-script-or-task
        console.log(chalk.cyan("\n🔍 Running Etherscan verification..."));

        await Promise.all(contracts.map(async contract => {
            console.log(`Verifying ${contract.name}...`);
            try {
                await hre.run("verify:verify", {
                    address: contract.address,
                    constructorArguments: contract.args
                });
                console.log(chalk.cyan(`✅ ${contract.name} verified!`));
            } catch (error) {
                console.log(error);
            }
        }));
    }

    console.log("✅✅ Deployment script completed! ✅✅");

    tableContracts = contracts.map(c => ({
        name: c.name,
        address: c.address
    }))

    console.table(tableContracts);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });