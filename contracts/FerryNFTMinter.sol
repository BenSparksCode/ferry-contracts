// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IZoraMedia.sol";

// Integrates with Chainlink's VRF to generate truly unique NFTs with random numbers
// Integrates with Zora to mint the NFTs

contract FerryNFTMinter {
    address public minter;
    IMedia ZoraMedia;

    constructor(address _zoraMediaAddress) {
        ZoraMedia = IMedia(_zoraMediaAddress);
    }

    function mint() external onlyMinter{
        // TODO
        // build SVG NFT
        // populate basic data and 0 for bidshares

        // ZoraMedia.mint(data, bidShares);
    }

    modifier onlyMinter {
        require(minter == msg.sender);
        _;
    }
}
