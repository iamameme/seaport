// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

/**
 * @title DigestHelper
 * @author iamameme
 * @notice DigestHelper contains an external pure view function
 *         related to deriving a digest.
 */
contract DigestHelper {
    // Cached constants from ConsiderationConstants
    uint256 constant EIP712_DomainSeparator_offset = 0x02;
    uint256 constant EIP712_OrderHash_offset = 0x22;
    uint256 constant EIP_712_PREFIX = (
        0x1901000000000000000000000000000000000000000000000000000000000000
    );
    uint256 constant EIP712_DigestPayload_size = 0x42;

    /**
     * @dev External pure function to efficiently derive an digest to sign for
     *      an order in accordance with EIP-712.
     *
     * @param domainSeparator The domain separator.
     * @param orderHash       The order hash.
     *
     * @return value The hash.
     */
    function deriveEIP712Digest(bytes32 domainSeparator, bytes32 orderHash)
        external
        pure
        returns (bytes32 value)
    {
        // Leverage scratch space to perform an efficient hash.
        assembly {
            // Place the EIP-712 prefix at the start of scratch space.
            mstore(0, EIP_712_PREFIX)

            // Place the domain separator in the next region of scratch space.
            mstore(EIP712_DomainSeparator_offset, domainSeparator)

            // Place the order hash in scratch space, spilling into the first
            // two bytes of the free memory pointer — this should never be set
            // as memory cannot be expanded to that size, and will be zeroed out
            // after the hash is performed.
            mstore(EIP712_OrderHash_offset, orderHash)

            // Hash the relevant region (65 bytes).
            value := keccak256(0, EIP712_DigestPayload_size)

            // Clear out the dirtied bits in the memory pointer.
            mstore(EIP712_OrderHash_offset, 0)
        }
    }
}
