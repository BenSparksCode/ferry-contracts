// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

interface IFerryNFTMinter {
    function createNFT(address _account) external;

    function mintNFT(address _account) external;
}
