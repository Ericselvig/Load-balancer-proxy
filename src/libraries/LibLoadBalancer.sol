// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ILoadBalancer} from "../interfaces/ILoadBalancer.sol";

library LibLoadBalancer {
    error LibLoadBalancer__NotOwner();
    error LibLoadBalancer__ZeroAddress();
    error LibLoadBalancer__AleadyInitialized();

    event ImplementationAddedOrChanged(uint256 indexed id, address indexed implementation);
    event ImplementationRemoved(uint256 indexed id);

    bytes32 constant LOAD_BALANCER_STORAGE_POSITION =
        keccak256("diamond.standard.diamond.storage");

    struct Storage {
        address owner;
        mapping(uint256 id => address implementation) implementations;
    }

    modifier onlyOwner() {
        Storage storage ds = loadBalancerStorage();
        if (msg.sender != ds.owner) {
            revert LibLoadBalancer__NotOwner();
        }
        _;
    }

    function loadBalancerStorage() internal pure returns (Storage storage ds) {
        bytes32 position = LOAD_BALANCER_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function initialize(address _owner) external {
        Storage storage ds = loadBalancerStorage();
        if (ds.owner != address(0)) {
            revert LibLoadBalancer__AleadyInitialized();
        }
        ds.owner = _owner;
    }

    function addOrChangeImplementation(uint256 _id, address _newImplementation) external onlyOwner {
        if (_newImplementation == address(0)) {
            revert LibLoadBalancer__ZeroAddress();
        }
        Storage storage ds = loadBalancerStorage();

        ds.implementations[_id] = _newImplementation;
        emit ImplementationAddedOrChanged(_id, _newImplementation);
    }

    function removeImplementation(uint256 _id) external onlyOwner {
        Storage storage ds = loadBalancerStorage();
        delete ds.implementations[_id];
        emit ImplementationRemoved(_id);
    }

    function getImplementationAddress(uint256 _id) external view returns (address implementation) {
        Storage storage ds = loadBalancerStorage();
        return ds.implementations[_id];
    }

}
