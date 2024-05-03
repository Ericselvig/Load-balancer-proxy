// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {Test, console} from "forge-std/Test.sol";
import {Staking} from "../../src/implementations/Staking.sol";

contract StakingTest is Test {
    ERC20Mock public token;
    Staking public staking;

    function setUp() public {
        token = new ERC20Mock();
        staking = new Staking(address(token));
    }

    function test_userCanStake() public {}

    function test_userCanUnstake() public {}

    //function test_userCan

    function test_ownerCanCollectFee() public {}
}