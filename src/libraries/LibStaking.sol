// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Staking Library
 * @author Ericselvig
 * @notice Library used to store and manage data for Staking contract
 */

library LibStaking {
    using SafeERC20 for IERC20;

    // location for the storage
    bytes32 constant STAKING_STORAGE_POSITION =
        keccak256("facet.staking.diamond.storage");

    struct Storage {
        address owner;
        address asset;
        uint256 totalStaked;
        mapping(address => uint256) staked;
        mapping(address => uint256) rewards;
        mapping(address => uint256) lastUpdated;
    }

    function getStorage() internal pure returns (Storage storage ds) {
        bytes32 position = STAKING_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function initialize(address _asset) internal {
        Storage storage ds = getStorage();
        if (ds.owner != address(0)) {
            revert Staking__AlreadyInitialized();
        }
        ds.owner = msg.sender;
        ds.asset = _asset;
    }

    //////////////
    /// EVENTS ///
    //////////////
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event FeeCollected(address indexed user, uint256 amount);

    //////////////
    /// ERRORS ///
    //////////////
    error Staking__ZeroAmount();
    error Staking__AlreadyInitialized();

    function stake(uint256 _amount) internal {
        if (_amount == 0) {
            revert Staking__ZeroAmount();
        }
        Storage storage ds = getStorage();
        ds.staked[msg.sender] += _amount;

        SafeERC20.safeTransferFrom(IERC20(ds.asset), msg.sender, address(this), _amount);
    }

    function unstake(uint256 _amount) internal {
        if (_amount == 0) {
            revert Staking__ZeroAmount();
        }
        Storage storage ds = getStorage();
        ds.staked[msg.sender] -= _amount;
        SafeERC20.safeTransfer(IERC20(ds.asset), msg.sender, _amount);
    }

    function _calculateReward(address _user) internal {}

    function getStakedAmount(address _user) internal view returns (uint256) {
        Storage storage ds = getStorage();
        return ds.staked[_user];
    }
}
