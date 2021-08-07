// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./interfaces/IZoraMedia.sol";
import "./interfaces/IZoraMarket.sol";
import "./utils/Decimal.sol";

import "hardhat/console.sol";

// Integrates with Chainlink's VRF to generate truly unique NFTs with random numbers
// Integrates with Zora to mint the NFTs

contract FerryNFTMinter is VRFConsumerBase, Ownable {
    address public ferry;
    IMedia ZoraMedia;

    mapping(bytes32 => address) nftRequestAddresses;
    IMarket.BidShares private bidShares;

    // Chainlink vars
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    constructor(
        address _ferry,
        address _zoraMediaAddress,
        address _vrfCoordinator,
        address _link,
        bytes32 _keyHash
    ) VRFConsumerBase(_vrfCoordinator, _link) {
        ferry = _ferry;
        ZoraMedia = IMedia(_zoraMediaAddress);
        // Chainlink setup
        keyHash = _keyHash;
        fee = 100000000000000; // 0.0001 LINK on Polygon

        bidShares = IMarket.BidShares({
            prevOwner: Decimal.D256(0),
            creator: Decimal.D256(0),
            owner: Decimal.D256(100)
        });
    }

    // ==================== //
    //        ZORA          //
    // ==================== //

    // TODO minted NFTs act as transferrable key to Superfluid stream of gov tokens ???

    function mint() external onlyFerry {
        // Request random num from Chainlink
        _getRandomNumber();
        // Callback in 10 blocks will generate and mint NFT
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
    function _getRandomNumber() private returns (bytes32 requestId) {
        requestId = requestRandomness(keyHash, fee);
        emit RequestedRandomness(requestId);
    }

    // Recieve random number callback result
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        // TODO call Ferry function to complete NFT mint accounting
        // randomResult = randomness;
        uint256 rarityScore = (randomness % 1000) + 1;

        console.log(randomness);

        if (rarityScore == 1000) {
            // LEGENDARY (0.1%)
        } else if (rarityScore > 980) {
            // EPIC (1.9%)
        } else if (rarityScore > 780) {
            // RARE (20%)
        } else {
            // COMMON (78%)
        }

        // TODO finish this - just for testing
        string memory tURI = "https://example.com";
        string memory mURI = "https://metadata.com";

        // TODO can try keccak if sha doesn't work
        IMedia.MediaData memory data = IMedia.MediaData({
            tokenURI: tURI,
            metadataURI: mURI,
            contentHash: sha256("Unique SVG string here"),
            metadataHash: sha256("Unique SVG metadata here")
        });

        ZoraMedia.mint(data, bidShares);
    }

    function withdrawLINK() external onlyOwner {
        require(
            LINK.transfer(msg.sender, LINK.balanceOf(address(this))),
            "FERRY_NFT: LINK WITHDRAW FAILED"
        );
    }
}
