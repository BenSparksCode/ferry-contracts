// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.6;
pragma experimental ABIEncoderV2;

import {IMarket} from "./IZoraMarket.sol";

/**
 * @title Interface for Zora Protocol's Media
 */
interface IMedia {

    struct MediaData {
        // A valid URI of the content represented by this token
        string tokenURI;
        // A valid URI of the metadata associated with this token
        string metadataURI;
        // A SHA256 hash of the content pointed to by tokenURI
        bytes32 contentHash;
        // A SHA256 hash of the content pointed to by metadataURI
        bytes32 metadataHash;
    }


    /**
     * @notice Mint new media for msg.sender.
     */
    function mint(MediaData calldata data, IMarket.BidShares calldata bidShares)
        external;

}