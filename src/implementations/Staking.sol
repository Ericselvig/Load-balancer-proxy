// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {LibStaking} from "../libraries/LibStaking.sol";

/**
 * @title Staking
 * @author Yash Goyal
 * @notice Minimal Staking contract
 */
contract Staking {

    /**
     * @notice Initialize the Staking contract
     * @param _asset The address of the asset to be staked
     */
    function initialize(address _asset) external {
        LibStaking.initialize(_asset);
    }

    /**
     * @notice Stake the amount
     * @param _amount The amount to be staked
     */
    function stake(uint256 _amount) external {
        LibStaking.stake(_amount);
    }

    /**
     * @notice Unstake the amount
     * @param _amount The amount to be unstaked
     */
    function unstake(uint256 _amount) external {
        LibStaking.unstake(_amount);
    }

    /**
     * @notice Get the staked amount of the user
     * @param user The address of the user
     */
    function getStakedAmount(address user) external view returns (uint256) {
        uint256 stakedAmount = LibStaking.getStakedAmount(user);
        return stakedAmount;
    }
}
