// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ILoadBalancer} from "../interfaces/ILoadBalancer.sol";
import {LibLoadBalancer} from "../libraries/LibLoadBalancer.sol";

/**
 * @title LoadBalancer
 * @author Yash Goyal
 * @notice This contract serves as a Load balancer to multiple implementations
 */
contract LoadBalancer is ILoadBalancer {

    constructor() {
        LibLoadBalancer.initialize(msg.sender);
    }

    fallback(bytes calldata) external returns (bytes memory) {
        return _fallback(msg.data);
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
    function _delegate(address implementation, bytes memory _data) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = implementation.delegatecall(_data);
        if (!success) {
            revert LoadBalancer__DelegateCallError();
        }
        return returndata;
    }

    /**
     * @notice Fallback function to delegate the call to the implementation contract
     * @dev Low level sensitive function
     * @param _data The data to be used for the delegate call
     */
    function _fallback(bytes calldata _data) internal returns (bytes memory) {
        (uint256 id, bytes memory data) = abi.decode(_data, (uint256, bytes));
        address implementation = LibLoadBalancer.getImplementationAddress(id);
        if (implementation == address(0)) {
            revert LoadBalancer__ImplementationNotFound();
        }
        return _delegate(implementation, data);
    }

    ///////////////////////
    /// ADMIN FUNCTIONS ///
    ///////////////////////

    /**
     * @inheritdoc ILoadBalancer
     */
    function addOrChangeImplementation(uint256 _id, address _newImplementation) external {
        LibLoadBalancer.addOrChangeImplementation(_id, _newImplementation);
    }

    /**
     * @inheritdoc ILoadBalancer
     */
    function removeImplementation(uint256 _id) external {
        LibLoadBalancer.removeImplementation(_id);
    }

    /**
     * @inheritdoc ILoadBalancer
     */
    function getImplementationAddress(uint256 _id) external view returns (address implementation) {
        return LibLoadBalancer.getImplementationAddress(_id);
    }
}
