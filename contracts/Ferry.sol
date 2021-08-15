// SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ILendingPool.sol";
import "./interfaces/IFerryNFTMinter.sol";
import "./interfaces/IFerry.sol";

// Integrates with Aave for treasury management

contract Ferry is IFerry, Ownable {
    // TODO add events
    IFerryNFTMinter NFTMinter;
    address public minterAddress;
    ILendingPool AaveLendingPool;
    IERC20 DAI;
    address public daiAddress;

    uint256 public annualFee; // annual pro fee
    uint256 public maxMembershipPeriod; // max membership you can prepay for
    bool public nftsActive;
    uint256 public nftCount;
    uint256 public maxMintedNFTs;
    uint256 public nftThresholdPayment;
    uint256 public constant YEAR = 365 days;

    struct NftData {
        uint256 index;
        uint256 randomNum;
        uint256 tokenID;
    }

    // address => membership expiry timestamp
    mapping(address => uint256) private memberships;
    // For membership NFTs -> 1 per account
    mapping(address => NftData) private nftOwned;
    mapping(address => bool) private nftRequested;

    event SubscriptionPaid(address indexed account, uint256 amount, uint256 expiry);
    event NFTNumberGenerated(address indexed account, uint256 randomNumber);
    event NFTMinted(address indexed account, uint256 index, uint256 tokenID);

    constructor(
        uint256 _annualFee,
        uint256 _maxMintedNFTs,
        uint256 _nftThreshold,
        uint256 _maxMembershipPeriod,
        address _dai,
        address _lendingPool,
        address _nftMinter
    ) {
        annualFee = _annualFee;
        maxMembershipPeriod = _maxMembershipPeriod;
        nftThresholdPayment = _nftThreshold;
        maxMintedNFTs = _maxMintedNFTs;

        DAI = IERC20(_dai);
        daiAddress = _dai;
        AaveLendingPool = ILendingPool(_lendingPool);
        NFTMinter = IFerryNFTMinter(_nftMinter);
        minterAddress = _nftMinter;

        // Infinite approve Aave for DAI deposits
        DAI.approve(_lendingPool, type(uint256).max);
    }

    // _account = user receiving subscription
    // _amount  = amount of DAI paid
    function paySubscription(address _account, uint256 _amount) public {
        require(_account != address(0), "FERRY: ZERO ADDRESS CAN'T SUBSCRIBE");
        require(_amount > 0, "FERRY: PAY SOME DAI TO SUBSCRIBE");

        // Transfer payment
        require(
            DAI.transferFrom(msg.sender, address(this), _amount),
            "FERRY: PAYMENT FAILED"
        );

        uint256 proTimeAdded = (YEAR * _amount) / annualFee;

        if (memberships[_account] < block.timestamp) {
            // Membership expired - start new one from now
            // Only charge and allocate up to max membership period
            if (proTimeAdded > maxMembershipPeriod) {
                proTimeAdded = maxMembershipPeriod;
                _amount = (maxMembershipPeriod / YEAR) * annualFee;
            }
            memberships[_account] = block.timestamp + proTimeAdded;
        } else {
            // Membership only expires in the future
            // Only charge and allocate up to max membership period
            uint256 availPeriod = block.timestamp +
                maxMembershipPeriod -
                memberships[_account];
            if (proTimeAdded > availPeriod) {
                proTimeAdded = availPeriod;
                _amount = (availPeriod / YEAR) * annualFee;
            }
            memberships[_account] += proTimeAdded;
        }

        // Only mint NFT if:
        // - NFT minting is active
        // - sender paid at least mint threshold
        // - account hasn't been minted NFT before
        // - NFTs minted doesn't exceed limit
        if (
            nftsActive &&
            _amount >= nftThresholdPayment &&
            !nftRequested[_account] &&
            nftCount < maxMintedNFTs
        ) {
            nftRequested[_account] = true;
            NFTMinter.createNFT(_account);
        }

        emit SubscriptionPaid(_account, _amount, memberships[_account]);
    }

    // Called from NFTMinter when Chainlink responds with random num
    function nftCreatedCallback(address _account, uint256 _randomNum)
        external
        override
        onlyMinter
    {
        nftOwned[_account].randomNum = _randomNum;
        
        emit NFTNumberGenerated(_account, _randomNum);
    }

    function mintNFT(address _account) external {
        require(
            nftOwned[_account].randomNum != 0,
            "FERRY: CANT MINT NFT"
        );
        // TODO add mint once only require

        nftCount++;
        nftOwned[_account].index = nftCount; 
        NFTMinter.mintNFT(_account);
    }

    function updateNFTData(address _account, uint256 _tokenID) external override onlyMinter {
        nftOwned[_account].tokenID = _tokenID;

        emit NFTMinted(_account, nftCount, _tokenID);
    }

    modifier onlyMinter() {
        require(
            minterAddress == msg.sender,
            "FERRY: ONLY MINTER IS AUTHORIZED"
        );
        _;
    }

    //------------------------------//
    //      OWNER FUNCTIONS         //
    //------------------------------//

    // Deposits DAI into Aave to earn interest
    function depositInAave(uint256 _amount) external onlyOwner {
        require(_amount > 0, "FERRY: DEPOSIT MORE THAN ZERO");
        AaveLendingPool.deposit(daiAddress, _amount, address(this), 0);
    }

    // Withdraws DAI from Aave
    function withdrawFromAave(uint256 _amount) external onlyOwner {
        require(_amount > 0, "FERRY: WITHDRAW MORE THAN ZERO");
        AaveLendingPool.withdraw(daiAddress, _amount, address(this));
    }

    // Set annual fee to [_fee] DAI
    function setAnnualFee(uint256 _annualFee) external onlyOwner {
        annualFee = _annualFee;
    }

    // Set length of max membership period that can be prepaid for
    function setMaxMembershipPeriod(uint256 _maxPeriod) external onlyOwner {
        maxMembershipPeriod = _maxPeriod;
    }

    // Set NFT threshold payment to [_threshold] DAI
    function setNftThresholdPayment(uint256 _threshold) external onlyOwner {
        nftThresholdPayment = _threshold;
    }

    // Set max number of NFTs that can be minted
    function setMaxMintedNFTs(uint256 _max) external onlyOwner {
        maxMintedNFTs = _max;
    }

    function setLendingPool(address _lendingPool) external onlyOwner {
        require(_lendingPool != address(0), "FERRY: CAN'T USE ZERO ADDRESS");
        AaveLendingPool = ILendingPool(_lendingPool);
        // Infinite approve Aave for DAI deposits
        DAI.approve(_lendingPool, type(uint256).max);
    }

    function setNFTMinter(address _minter, bool _nftsActive)
        external
        onlyOwner
    {
        require(_minter != address(0), "FERRY: CAN'T USE ZERO ADDRESS");
        NFTMinter = IFerryNFTMinter(_minter);
        minterAddress = _minter;
        nftsActive = _nftsActive;
    }

    function withdrawDAI() external onlyOwner {
        require(
            DAI.transfer(msg.sender, DAI.balanceOf(address(this))),
            "FERRY: DAI WITHDRAW FAILED"
        );
    }

    //------------------------------//
    //      VIEW FUNCTIONS          //
    //------------------------------//

    // Returns the UNIX time that membership for user will expire
    function getMembershipExpiryTime(address _account)
        public
        view
        returns (uint256)
    {
        return memberships[_account];
    }

    // Returns the random num of an address's NFT
    function getAccountNFT(address _account)
        public
        view
        returns (uint256 randomNum, uint256 index, uint256 tokenID)
    {
        return (nftOwned[_account].randomNum, nftOwned[_account].index, nftOwned[_account].tokenID);
    }
}
