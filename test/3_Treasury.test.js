// -------------------------
// Treasury tests
// -------------------------

const { BigNumber } = require("@ethersproject/bignumber");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const { constants } = require("./TestConstants")
// const {  } = require("./TestUtils")

let owner, ownerAddress;
let alice, aliceAddress;

let ShipContract, ShipInstance;
let xShipContract, xShipInstance;
let FerryContract, FerryInstance;
let FerryMinterContract, FerryMinterInstance;

let SuperShipInstance;

const SuperTokenFactory_ABI = require("../artifacts/contracts/interfaces/ISuperTokenFactory.sol/ISuperTokenFactory.json")
let SuperTokenFactory = new ethers.Contract(
    constants.POLYGON.SuperTokenFactory,
    SuperTokenFactory_ABI.abi,
    ethers.provider
)

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
            constants.POLYGON.DAI,
            constants.POLYGON.AaveLendingPool,
            ethers.constants.AddressZero  // setting NFT minter later
        )

        FerryMinterContract = await ethers.getContractFactory("FerryNFTMinter")
        FerryMinterInstance = await FerryMinterContract.connect(owner).deploy(
            FerryInstance.address,
            constants.POLYGON.ZoraMedia,
            constants.POLYGON.ChainlinkVRFCoordinator,
            constants.POLYGON.LINK,
            constants.POLYGON.ChainlinkKeyHash
        )

        ShipContract = await ethers.getContractFactory("ShipToken")
        ShipInstance = await ShipContract.connect(owner).deploy(
            constants.DEPLOY.SHIP.name,
            constants.DEPLOY.SHIP.symbol,
            constants.DEPLOY.SHIP.totalSupply
        )

        xShipContract = await ethers.getContractFactory("ShipHarbor")
        xShipInstance = await xShipContract.connect(owner).deploy(
            ShipInstance.address,
            ethers.constants.AddressZero // set the SuperToken stream address later
        )
    })
    it("Creating Super Token", async () => {
        // Wrap SHIP token with SuperTokenFactory to create a SHIPx SuperToken

        SuperShipInstance = await SuperTokenFactory.connect(owner).createERC20Wrapper(
            ShipInstance.address, // has decimals in token contract, so don't need to specify here
            constants.DEPLOY.SuperSHIP.upgradability, // NON_UPGRADABLE in the Upgradability enum
            constants.DEPLOY.SuperSHIP.name,
            constants.DEPLOY.SuperSHIP.symbol
        )

        console.log(SuperShipInstance);
    });
});
