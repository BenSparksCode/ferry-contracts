const { BigNumber } = require("@ethersproject/bignumber");
const { ethers } = require("hardhat");

// EVERYTHING FOR MUMBAI TESTNET

const CONSTANTS = {
    SHIP: {
        decimals: 18,
        total: 100000000,               //  100 million
        hackathonAirdrop: 2000000,      //  2 million
        mainnetAirdrop: 8000000,        //  8 million
        strategicPartners: 16000000,    //  16 million
        stakingRewards: 20000000,       //  20 million
        teamVesting: 24000000,          //  24 million
        daoTreasury: 30000000           //  30 million
    },
    PROTOCOL_PARAMS: {
       
    },
    CONTRACTS: {
        AAVE:{
            LENDING_POOL: "0x9198F13B08E299d85E096929fA9781A1E3d5d827",     // Lending Pool on Matic
            aDAI: "0x639cB7b21ee2161DF9c882483C9D55c90c20Ca3e",             // aDAI on Matic
            DAI: "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F",              // DAI - mintable on Mumbai
        }
    }
}


module.exports = {
    constants: CONSTANTS
}