// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {LibStaking} from "../libraries/LibStaking.sol";

contract Staking {
    constructor(address _asset) {
        LibStaking.initialize(_asset);
    }
    
    function stake(uint256 _amount) external {
        LibStaking.stake(_amount);
    }

    function unstake(uint256 _amount) external {
        LibStaking.unstake(_amount);
    }

    function collectFee() external {
        LibStaking.collectFee();
    }
}
