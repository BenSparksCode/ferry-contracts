// -------------------------
// Treasury tests
// -------------------------

const { BigNumber } = require("@ethersproject/bignumber");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const { constants } = require("./TestConstants")
// const {  } = require("./TestUtils")

let owner, ownerAddress
let alice, aliceAddress

let ShipContract, ShipInstance
let xShipContract, xShipInstance
let FerryContract, FerryInstance
let FerryMinterContract, FerryMinterInstance


describe.only("Treasury tests", function () {
    beforeEach(async () => {

        [owner, alice] = await ethers.getSigners();
        ownerAddress = await owner.getAddress()
        aliceAddress = await alice.getAddress()


        FerryContract = await ethers.getContractFactory("Ferry")
        FerryInstance = await FerryContract.connect(owner).deploy(
            constants.DEPLOY.FERRY.annualFee,
            constants.DEPLOY.FERRY.maxMintedNFTs,
            constants.DEPLOY.FERRY.nftThreshold,
            constants.DEPLOY.FERRY.maxMembershipPeriod,
            constants.MUMBAI.DAI,
            constants.MUMBAI.AaveLendingPool,
            ethers.constants.AddressZero  // setting NFT minter later
        )

        FerryMinterContract = await ethers.getContractFactory("FerryNFTMinter")
        FerryMinterInstance = await FerryMinterContract.connect(owner).deploy(
            FerryInstance.address,
            constants.MUMBAI.ZoraMedia,
            constants.MUMBAI.ChainlinkVRFCoordinator,
            constants.MUMBAI.LINK,
            constants.MUMBAI.ChainlinkKeyHash
        )



    })
    it("First test", async () => {});
});
