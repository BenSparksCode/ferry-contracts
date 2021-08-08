// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

interface IFerry {
    function nftCreatedCallback(address _account, uint256 _randomNum) external;
}
