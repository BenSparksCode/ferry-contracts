// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./interfaces/IZoraMedia.sol";

// Integrates with Chainlink's VRF to generate truly unique NFTs with random numbers
// Integrates with Zora to mint the NFTs

contract FerryNFTMinter is VRFConsumerBase, Ownable {
    address public ferry;
    IMedia ZoraMedia;

    // Chainlink vars
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    constructor(
        address _ferry,
        address _zoraMediaAddress,
        address _vrfCoordinator,
        address _link,
        bytes32 _keyHash,
        uint256 _fee
    )
        VRFConsumerBase(
            _vrfCoordinator, // VRF Coordinator
            _link // LINK Token
        )
    {
        ferry = _ferry;
        ZoraMedia = IMedia(_zoraMediaAddress);
        // Chainlink setup
        keyHash = _keyHash;
        fee = _fee;
    }

    // ==================== //
    //        ZORA          //
    // ==================== //

    // TODO minted NFTs act as transferrable key to Superfluid stream of gov tokens ???

    function mint() external onlyFerry {
        // TODO
        // build SVG NFT
        // populate basic data and 0 for bidshares
        // ZoraMedia.mint(data, bidShares);
    }

    modifier onlyFerry() {
        require(ferry == msg.sender);
        _;
    }

    // ==================== //
    //      CHAINLINK       //
    // ==================== //

    event RequestedRandomness(bytes32 requestId);

    // TODO shouldn't be public, haters will drain the linkies
    // Request random number
    function getRandomNumber() public returns (bytes32 requestId) {
        requestId = requestRandomness(keyHash, fee);
        emit RequestedRandomness(requestId);
    }

    // Recieve random number callback result
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
    }

    function withdrawLINK() external onlyOwner {
        require(
            LINK.transfer(msg.sender, LINK.balanceOf(address(this))),
            "FERRY_NFT: LINK WITHDRAW FAILED"
        );
    }
}
