// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ILendingPool.sol";

// CORE:
// Owned by a Gnosis Safe wallet
// Receives payments for pro tier (in DAI) ✅
// Function to deposit DAI in Aave
// Function to withdraw DAI from Aave
// Function to pay Filecoin for storage via Polygon bridge (DAI->wFIL needed?)
// View functions for user's subscription details

// LATER:
// Payments in DAI/USDC/MATIC with SushiSwap convert to DAI

contract Ferry is Ownable {
    ILendingPool aaveLendingPool;
    IERC20 dai;

    uint256 public annualFee; // annual pro fee
    uint256 public constant YEAR = 365 days;

    // address => membership expiry timestamp
    mapping(address => uint256) private memberships;

    constructor(uint256 _annualFee, address _dai, address _lendingPool) {
        annualFee = _annualFee;

        dai = IERC20(_dai);
        aaveLendingPool = ILendingPool(_lendingPool);
        
        // Infinite approve Aave for DAI deposits
        dai.approve(_lendingPool, type(uint256).max);
    }

    // _account --> user receiving subscription
    // _amount  --> amount of DAI paid
    function paySubscription(address _account, uint256 _amount) public {
        // TODO NFT minting
        require(_account != address(0), "FERRY: ZERO ADDRESS CAN'T SUBSCRIBE");
        require(_amount > 0, "FERRY: PAY SOME DAI TO SUBSCRIBE");

        uint256 proTimeAdded = (YEAR * _amount) / annualFee;

        memberships[_account] += proTimeAdded;
    }

    //------------------------------//
    //      OWNER FUNCTIONS         //
    //------------------------------//

    // Deposits DAI into Aave to earn interest
    function depositInAave(uint256 _amount) public onlyOwner {
        // TODO

    }

    // Withdraws DAI from Aave
    function withdrawFromAave(uint256 _amount) public onlyOwner {
        // TODO
    }

    // Set annual fee to [_fee] DAI
    function setAnnualFee(uint256 _annualFee) public onlyOwner {
        annualFee = _annualFee;
    }

    function setLendingPool(address _lendingPool) public onlyOwner {
        aaveLendingPool = ILendingPool(_lendingPool);
        // Infinite approve Aave for DAI deposits
        dai.approve(_lendingPool, type(uint256).max);
    }

    //------------------------------//
    //      VIEW FUNCTIONS          //
    //------------------------------//

    // Returns seconds of membership left for account
    function getMembershipTimeLeft(address _account)
        public
        view
        returns (uint256)
    {
        if (memberships[_account] > block.timestamp) {
            return memberships[_account] - block.timestamp;
        } else {
            return 0;
        }
    }
}
