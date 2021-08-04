// SPDX-License-Identifier: MIT
// Forked from Sushiswap's SushiBar staking contract

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// This contract handles swapping to and from xSHIP, Ferry's staking token.
contract ShipHarbor is ERC20("StakedShip", "xSHIP") {
    IERC20 public ship;

    // Define the SHIP token contract
    constructor(IERC20 _ship) {
        ship = _ship;
    }

    // Enter the bar. Pay some SHIPs. Earn some shares.
    // Locks SHIP and mints xSHIP
    function enter(uint256 _amount) public {
        // Gets the amount of SHIP locked in the contract
        uint256 totalShip = ship.balanceOf(address(this));
        // Gets the amount of xSHIP in existence
        uint256 totalShares = totalSupply();
        // If no xSHIP exists, mint it 1:1 to the amount put in
        if (totalShares == 0 || totalShip == 0) {
            _mint(msg.sender, _amount);
        }
        // Calculate and mint the amount of xSHIP the SHIP is worth. The ratio will change overtime, as xSHIP is burned/minted and SHIP deposited + gained from fees / withdrawn.
        else {
            uint256 what = (_amount * totalShares) / totalShip;
            _mint(msg.sender, what);
        }
        // Lock the SHIP in the contract
        ship.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your SHIP.
    // Unlocks the staked + gained SHIP and burns xSHIP
    function leave(uint256 _share) public {
        // Gets the amount of xSHIP in existence
        uint256 totalShares = totalSupply();
        // Calculates the amount of SHIP the xSHIP is worth
        uint256 what = (_share * ship.balanceOf(address(this))) / totalShares;
        _burn(msg.sender, _share);
        ship.transfer(msg.sender, what);
    }
}
