// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ILendingPool.sol";

// TODO - Any treasury activity - owned by multisig
// Aave deposit and withdraw (DAI)
// Swap DAI -> wFIL / LINK
// Pay Filecoin via bridge
// Send LINK to NFT Minter

contract FerryTreasury is Ownable {
    ILendingPool aaveLendingPool;
    IERC20 dai;
    address daiAddress;

    uint256 public annualFee; // annual pro fee
    uint256 public constant YEAR = 365 days;
    uint256 public nftThresholdPayment;

    // address => membership expiry timestamp
    mapping(address => uint256) private memberships;
    // For membership NFTs -> 1 per account
    mapping(address => bool) private hasNFT;

    constructor(
        uint256 _annualFee,
        uint256 _nftThreshold,
        address _dai,
        address _lendingPool,
        address _nftMinter
    ) {
        annualFee = _annualFee;
        nftThresholdPayment = _nftThreshold;

        dai = IERC20(_dai);
        daiAddress = _dai;
        aaveLendingPool = ILendingPool(_lendingPool);

        // Infinite approve Aave for DAI deposits
        dai.approve(_lendingPool, type(uint256).max);
    }

    // ==================== //
    //         AAVE         //
    // ==================== //

    // Deposits DAI into Aave to earn interest
    function depositInAave(uint256 _amount) public onlyOwner {
        require(_amount > 0, "FERRY: DEPOSIT MORE THAN ZERO");
        aaveLendingPool.deposit(daiAddress, _amount, address(this), 0);
    }

    // Withdraws DAI from Aave
    function withdrawFromAave(uint256 _amount) public onlyOwner {
        require(_amount > 0, "FERRY: WITHDRAW MORE THAN ZERO");
        aaveLendingPool.withdraw(daiAddress, _amount, address(this));
    }

    function setLendingPool(address _lendingPool) public onlyOwner {
        require(_lendingPool != address(0), "FERRY: CAN'T USE ZERO ADDRESS");
        aaveLendingPool = ILendingPool(_lendingPool);
        // Infinite approve Aave for DAI deposits
        dai.approve(_lendingPool, type(uint256).max);
    }

    // ==================== //
    //      SUSHISWAP       //
    // ==================== //

    // TODO SushiSwap code here

    //------------------------------//
    //      VIEW FUNCTIONS          //
    //------------------------------//

    // Returns the UNIX time that membership for user will expire
    function getMembershipExpiryTime(address _account)
        public
        view
        returns (uint256)
    {
        return memberships[_account];
    }
}
