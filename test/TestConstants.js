const { BigNumber } = require("@ethersproject/bignumber");
const { ethers } = require("hardhat");

const CONSTANTS = {
    SHIP: {
        decimals: 18,
        total: 100000000,               //  100 million
        hackathonAirdrop: 5000000,      //  5 million
        mainnetAirdrop: 5000000,        //  5 million
        strategicPartners: 16000000,    //  16 million
        stakingRewards: 20000000,       //  20 million
        teamVesting: 24000000,          //  24 million
        daoTreasury: 30000000           //  30 million
    },
    TEST_PARAMS:{
        
    },
    PROTOCOL_PARAMS: {
       
    },
    PROTOCOL_REVERTS: {
        OWNABLE:{
            notOwner: "Ownable: caller is not the owner"
        },
        ERC20:{
            transferTooMuch: "ERC20: transfer amount exceeds balance",
            notEnoughApproved: "ERC20: transfer amount exceeds allowance",
        }
    },
    CONTRACTS: {
        SUSHI: {
            // https://etherscan.io/address/0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F#code
            ROUTER: "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F", //on mainnet
            // https://etherscan.io/address/0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac#code
            FACTORY: "0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac", //on mainnet
            // https://etherscan.io/address/0x397FF1542f962076d0BFE58eA045FfA2d347ACa0
            USDC_WETH_POOL: "0x397FF1542f962076d0BFE58eA045FfA2d347ACa0", //on mainnet
            // https://analytics-polygon.sushi.com/pairs/0x21ef14b5580a852477ef31e7ea9373485bf50377
            WETH_WFIL_POOL: "0x21ef14b5580a852477ef31e7ea9373485bf50377"
        },
        TOKENS: {
            USDC: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", //on mainnet
            DAI: "",
            WMATIC: "",
            WETH: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2" //on mainnet
        }
    },
    WALLETS: {
        FIL_WHALE: "",
    }
}


module.exports = {
    constants: CONSTANTS
}