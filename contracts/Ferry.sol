// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// CORE:
// Owned by a multi-sig wallet
// Receives payments for pro tier (in DAI)
// Function to deposit DAI in Aave
// Function to withdraw DAI from Aave
// Function to pay Filecoin for storage via Polygon bridge (DAI->wFIL needed?)
// View functions for user's subscription details

// LATER:
// Payments in DAI/USDC/MATIC with SushiSwap convert to DAI

contract Ferry {
    constructor() {}
}
