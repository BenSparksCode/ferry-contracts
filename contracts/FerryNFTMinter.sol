// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./interfaces/IZoraMedia.sol";
import "./interfaces/IZoraMarket.sol";
import "./interfaces/IFerryNFTMinter.sol";
import "./interfaces/IFerry.sol";
import "./utils/Decimal.sol";

// Integrates with Chainlink's VRF to generate truly unique NFTs with random numbers
// Integrates with Zora to mint the NFTs

contract FerryNFTMinter is
    VRFConsumerBase,
    Ownable,
    IFerryNFTMinter,
    IERC721Receiver
{
    address public ferry;
    address private currentAccount; //for temp storage of NFT owner during mint

    IMedia ZoraMedia;
    bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

    mapping(bytes32 => address) private nftRequests;
    mapping(address => uint256) private randomNums;

    IMarket.BidShares private bidShares;

    string public constant LegendaryNFT = 'https://bafybeifpukazozmq4bq4kw6qhhwa7cixhjiepvx3vaeqck4yq5citrdrcq.ipfs.dweb.link/Solid%20Gold%20Legendary.svg';
    string public constant EpicNFT = 'https://bafybeigejh2uazcdlypk3kzutqsju77vhvtkaaic2il2pkl27bwu3h3avy.ipfs.dweb.link/You%20Look%20So%20Good%20In%20Teal%20-%20Epic.svg';
    string public constant RareNFT = 'https://bafybeiftgxqpm42nphlvpgo5fk4r6ypzedsxwbd3h25652lwgz6cnoyrxa.ipfs.dweb.link/Rare%20Sighting.svg';
    string public constant CommonNFT = 'https://bafybeid6tfyhxxw4kcfv3vyimwv4lpiemkhsdfl2kamagursix32h6cdda.ipfs.dweb.link/Common%20Little%20Ferry.svg';
    
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
            owner: Decimal.D256(100000000000000000000)
        });
    }

    // ==================== //
    //        ZORA          //
    // ==================== //

    // TODO minted NFTs act as transferrable key to Superfluid stream of gov tokens ???

    function createNFT(address _account) external override onlyFerry {
        // Request random num from Chainlink for account
        _getRandomNumber(_account);
        // Callback in 10 blocks will generate and mint NFT
    }

    // TODO Needs to be completed
    // TODO should be onlyFerry
    function mintNFT(address _account) external override onlyFerry {
        // Call from Ferry once account has random num from Chainlink
        // retrieves random num for account from mapping
        uint256 rarityScore = (randomNums[_account] % 1000) + 1;

        string memory nftURI;
        // TODO add real content URIs from IPFS
        if (rarityScore == 1000) {
            // LEGENDARY (0.1%)
            nftURI = LegendaryNFT;
        } else if (rarityScore > 980) {
            // EPIC (1.9%)
            nftURI = EpicNFT;
        } else if (rarityScore > 780) {
            // RARE (20%)
            nftURI = RareNFT;
        } else {
            // COMMON (78%)
            nftURI = CommonNFT;
        }

        bytes32 dataHash = sha256(abi.encodePacked(nftURI, randomNums[_account]));

        IMedia.MediaData memory data = IMedia.MediaData({
            tokenURI: nftURI,
            metadataURI: nftURI,
            contentHash: dataHash,
            metadataHash: dataHash
        });

        currentAccount = _account; // to store who owns this NFT being minted

        ZoraMedia.mint(data, bidShares);
    }

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external override returns (bytes4) {

        IFerry(ferry).updateNFTData(currentAccount, _tokenId);

        ZoraMedia.safeTransferFrom(address(this), currentAccount, _tokenId);

        currentAccount = address(0); // reset to zero address

        return ERC721_RECEIVED;
    }

    modifier onlyFerry() {
        require(ferry == msg.sender, "FERRY_NFT: ONLY FERRY IS AUTHORIZED");
        _;
    }

    // ==================== //
    //      CHAINLINK       //
    // ==================== //

    event RequestedRandomness(bytes32 requestId);
    event RandomnessFulfilled(bytes32 requestId);

    // Request random number
    function _getRandomNumber(address _account)
        private
        returns (bytes32 requestId)
    {
        requestId = requestRandomness(keyHash, fee);
        nftRequests[requestId] = _account;
        emit RequestedRandomness(requestId);
    }

    // Recieve random number callback result
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        address _account = nftRequests[requestId];

        randomNums[_account] = randomness;
        IFerry(ferry).nftCreatedCallback(_account, randomness);

        emit RandomnessFulfilled(requestId);
    }

    function withdrawLINK() external onlyOwner {
        require(
            LINK.transfer(msg.sender, LINK.balanceOf(address(this))),
            "FERRY_NFT: LINK WITHDRAW FAILED"
        );
    }

    //------------------------------//
    //      VIEW FUNCTIONS          //
    //------------------------------//

    function getAccountRandomNum(address _account)
        external
        view
        returns (uint256)
    {
        return randomNums[_account];
    }
}
