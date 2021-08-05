// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ILendingPool.sol";
import "./interfaces/IFerryNFTMinter.sol";

// CORE:
// Owned by a Gnosis Safe wallet
// Function to pay Filecoin for storage via Polygon bridge (DAI->wFIL needed?)
// Add limited unique NFT minting on paying fee
// Receives payments for pro tier (in DAI) ✅
// Function to deposit DAI in Aave ✅
// Function to withdraw DAI from Aave ✅
// View functions for user's subscription details ✅

// LATER:
// Payments in DAI/USDC/MATIC with SushiSwap convert to DAI

contract Ferry is Ownable {
    IFerryNFTMinter NFTMinter;
    ILendingPool aaveLendingPool;
    IERC20 dai;
    address daiAddress;

    uint256 public annualFee; // annual pro fee
    uint256 public constant YEAR = 365 days;

    // address => membership expiry timestamp
    mapping(address => uint256) private memberships;

    constructor(
        uint256 _annualFee,
        address _dai,
        address _lendingPool
    ) {
        annualFee = _annualFee;

        dai = IERC20(_dai);
        daiAddress = _dai;
        aaveLendingPool = ILendingPool(_lendingPool);

        // Infinite approve Aave for DAI deposits
        dai.approve(_lendingPool, type(uint256).max);
    }

    // _account = user receiving subscription
    // _amount  = amount of DAI paid
    function paySubscription(address _account, uint256 _amount) public {
        // TODO NFT minting
        // TODO limit to how much membership time they can pre-buy?
        require(_account != address(0), "FERRY: ZERO ADDRESS CAN'T SUBSCRIBE");
        require(_amount > 0, "FERRY: PAY SOME DAI TO SUBSCRIBE");

        uint256 proTimeAdded = (YEAR * _amount) / annualFee;

        if (memberships[_account] < block.timestamp) {
            // Membership expired - start new one from now
            memberships[_account] = block.timestamp + proTimeAdded;
        } else {
            // Membership only expires in the future
            memberships[_account] += proTimeAdded;
        }
    }

    //------------------------------//
    //      OWNER FUNCTIONS         //
    //------------------------------//

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

    // Set annual fee to [_fee] DAI
    function setAnnualFee(uint256 _annualFee) public onlyOwner {
        annualFee = _annualFee;
    }

    function setLendingPool(address _lendingPool) public onlyOwner {
        require(_lendingPool != address(0), "FERRY: CAN'T USE ZERO ADDRESS");
        aaveLendingPool = ILendingPool(_lendingPool);
        // Infinite approve Aave for DAI deposits
        dai.approve(_lendingPool, type(uint256).max);
    }

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
