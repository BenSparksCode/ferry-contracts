// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Integrates with Chainlink's VRF to generate truly unique NFTs with random numbers
// Integrates with Zora to mint the NFTs

contract FerryNFTMinter {
    address public minter;

    constructor() {}

    function mint() external onlyMinter{}

    modifier onlyMinter {
        require(minter == msg.sender);
        _;
    }
}
