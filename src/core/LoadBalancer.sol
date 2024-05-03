// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Registry} from "./Registry.sol";

contract LoadBalancer is Registry {
    //////////////
    /// ERRORS ///
    //////////////
    error Proxy__ImplementationNotFound();
    error Proxy__DelegateCallError();

    fallback(bytes calldata _data) external returns (bytes memory) {
        return _fallback(_data);
    }

    receive() external payable {}

    //////////////////////////
    /// INTERNAL FUNCTIONS ///
    //////////////////////////

    /**
     * @notice Delegates the call to the implementation contract
     * @dev Low level sensitive function
     * @param implementation The address of the implementation
     */
    function _delegate(address implementation) internal returns (bytes memory) {
        (bool success, bytes memory returnData) = implementation.delegatecall(msg.data);
        if (!success) {
            revert Proxy__DelegateCallError();
        }
        return returnData;
    }

    /**
     * @notice Fallback function to delegate the call to the implementation contract
     * @dev Low level sensitive function
     * @param _data The data to be used for the delegate call
     */
    function _fallback(bytes calldata _data) internal returns (bytes memory) {
        uint256 id = abi.decode(_data, (uint256));
        address implementation = implementations[id];
        if (implementation == address(0)) {
            revert Proxy__ImplementationNotFound();
        }
        return _delegate(implementation);
    }
}
