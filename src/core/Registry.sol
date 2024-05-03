// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IRegistry} from "../interfaces/IRegistry.sol";

contract Registry is IRegistry, Ownable {
    mapping(uint256 id => address implementation) internal implementations;

    constructor() Ownable(msg.sender) {}

    ///////////////////////
    /// ADMIN FUNCTIONS ///
    ///////////////////////

    /**
     * @inheritdoc IRegistry
     */
    function addOrChangeImplementation(uint256 _id, address _newImplementation) external onlyOwner {
        if (_newImplementation == address(0)) {
            revert Registry__ZeroAddress();
        }
        implementations[_id] = _newImplementation;
        emit ImplementationAddedOrChanged(_id, _newImplementation);
    }

    /**
     * @inheritdoc IRegistry
     */
    function removeImplementation(uint256 _id) external onlyOwner {
        delete implementations[_id];
        emit ImplementationRemoved(_id);
    }

    //////////////////////
    /// VIEW FUNCTIONS ///
    //////////////////////

    /**
     * @inheritdoc IRegistry
     */
    function getImplementationAddress(uint256 _id) external view returns (address implementation) {
        return implementations[_id];
    }
}
