// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// CORE:
// Owned by a multi-sig wallet
// Receives payments for pro tier (in DAI)
// Function to deposit DAI in Aave
// Function to withdraw DAI from Aave
// Function to pay Filecoin for storage via Polygon bridge (DAI->wFIL needed?)
// View functions for user's subscription details

// LATER:
// Payments in DAI/USDC/MATIC with SushiSwap convert to DAI

contract Ferry is Ownable {

    uint256 public monthlyFee; // monthly pro fee

    // address => membership expiry timestamp
    mapping(address => uint256) public memberships;

    constructor(uint256 _monthlyFee) {
        monthlyFee = _monthlyFee;
    }


    function paySubscription(address _account, uint256 _amount) public {

    }


    // Deposits DAI into Aave to earn interest
    function depositInAave(uint256 _amount) public onlyOwner {
        
    }

    // Withdraws DAI from Aave
    function withdrawFromAave(uint256 _amount) public onlyOwner {
        
    }

}
