const hre = require("hardhat");

const { constants } = require("../test/TestConstants")

async function main() {


  console.log("DONE");

}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
