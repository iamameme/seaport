// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

/**
 * @title DomainHelper
 * @author iamameme
 * @notice DomainHelper contains an external view function
 *         for getting a domain separator.
 */
contract DomainHelper {
    // Constants from ConsiderationBase
    uint256 internal immutable _CHAIN_ID;
    bytes32 internal immutable _DOMAIN_SEPARATOR;
    address internal immutable _MARKETPLACE_ADDRESS;
    // Derived typehash constants 
    bytes32 constant EIP_712_DOMAIN_TYPEHASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
    bytes32 constant NAME_HASH = 0x32b5c112df393a49218d7552f96b2eeb829dfb4272f4f24eef510a586b85feef;
    bytes32 constant VERSION_HASH = 0x722c0e0c80487266e8c6a45e3a1a803aab23378a9c32e6ebe029d4fad7bfc965;
 
    /**
     * @dev Derive domain separator for current chain with given marketplace address
     *
     * @param marketplaceAddress Address for the seaport marketplace
     *
     */

    constructor(address marketplaceAddress) {
        // Store the current chainId and derive the current domain separator.
        _CHAIN_ID = block.chainid;
        _MARKETPLACE_ADDRESS = marketplaceAddress;
        _DOMAIN_SEPARATOR = _deriveDomainSeparator();
    }

    /**
     * @dev External view function to get the EIP-712 domain separator. If the
     *      chainId matches the chainId set on deployment, the cached domain
     *      separator will be returned; otherwise, it will be derived from
     *      scratch.
     *
     * @return The domain separator.
     */
    function domainSeparator() external view returns (bytes32) {
        // prettier-ignore
        return block.chainid == _CHAIN_ID
            ? _DOMAIN_SEPARATOR
            : _deriveDomainSeparator();
    }

    /**
     * @dev Internal view function to derive the EIP-712 domain separator.
     *
     * @return The derived domain separator.
     */
    function _deriveDomainSeparator() internal view returns (bytes32) {
        // prettier-ignore
        return keccak256(
            abi.encode(
                EIP_712_DOMAIN_TYPEHASH,
                NAME_HASH,
                VERSION_HASH,
                block.chainid,
                _MARKETPLACE_ADDRESS
            )
        );
    }
}
