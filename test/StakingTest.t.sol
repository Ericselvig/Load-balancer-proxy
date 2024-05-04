// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {Test, console} from "forge-std/Test.sol";
import {Staking} from "../src/implementations/Staking.sol";
import {LoadBalancer} from "../src/core/LoadBalancer.sol";

contract StakingTest is Test {
    ERC20Mock public token;
    Staking public staking;
    LoadBalancer public lb;

    address alice;
    address bob;

    function setUp() public {
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        token = new ERC20Mock();
        staking = new Staking();
        lb = new LoadBalancer();
        lb.addOrChangeImplementation(1, address(staking));
        (bool ok, ) = address(lb).call(abi.encode(1, abi.encodeWithSignature("initialize(address)", address(token))));
        if (!ok) {
            revert();
        }
        token.mint(alice, 10e18);
        token.mint(bob, 10e18);
    }

    function test_userCanStake() public {
        vm.startPrank(alice);
        token.approve(address(lb), 1e18);
        uint256 id = 1;
        bytes memory payload = abi.encodeWithSignature("stake(uint256)", 1e18);
        (bool ok, ) = address(lb).call(abi.encode(id, payload));
        if (!ok) {
            revert();
        }
        vm.stopPrank();
        bytes memory data = abi.encodeWithSignature("getStakedAmount(address)", alice);
        (bool success, bytes memory returndata) = address(lb).call(abi.encode(id, data));
        if (!success) {
            revert();
        }

        uint256 stakedAmount = abi.decode(returndata, (uint256));
        assertEq(stakedAmount, 1e18);
        assertEq(token.balanceOf(address(lb)), 1e18);
        assertEq(token.balanceOf(alice), 9e18);
    }

    function test_userCanUnstake() public {
        vm.startPrank(alice);
        token.approve(address(lb), 1e18);
        uint256 id = 1;
        bytes memory payload = abi.encodeWithSignature("stake(uint256)", 1e18);
        (bool ok, ) = address(lb).call(abi.encode(id, payload));
        if (!ok) {
            revert();
        }
        payload = abi.encodeWithSignature("unstake(uint256)", 1e18);
        (ok, ) = address(lb).call(abi.encode(id, payload));
        vm.stopPrank();

        assertEq(token.balanceOf(address(lb)), 0);
        assertEq(token.balanceOf(alice), 10e18);
    }

    function test_userCanCollectRewards() public {
        token.mint(address(lb), 1e18); // mint extra tokens to load balancer to distribute as rewards
        vm.startPrank(alice);
        token.approve(address(lb), 1e18);
        uint256 id = 1;
        bytes memory payload = abi.encodeWithSignature("stake(uint256)", 1e18);
        (bool ok, ) = address(lb).call(abi.encode(id, payload));
        if (!ok) {
            revert();
        }
        vm.warp(100);
        payload = abi.encodeWithSignature("collectRewards()");
        (ok, ) = address(lb).call(abi.encode(id, payload));
        vm.stopPrank();

        assertEq(token.balanceOf(alice), 9e18 + 1e16); // 1e16 is the reward for 100 seconds
    }
}