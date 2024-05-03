// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library LibVoting {
    struct Storage {
        uint256 totalVotes;
        mapping(address => uint256) votes;
        mapping(address => uint256) lastUpdated;
    }

    function vote() external {}
}
