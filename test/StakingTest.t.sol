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

        bytes memory data = abi.encodeWithSignature("getStakedAmount(address)", alice);
        (bool success, bytes memory returndata) = address(lb).call(abi.encode(id, data));
        if (!success) {
            revert();
        }

        uint256 stakedAmount = abi.decode(returndata, (uint256));
        assertEq(stakedAmount, 1e18);
        assertEq(token.balanceOf(address(lb)), 1e18);
    }

    function test_userCanUnstake() public {}

    //function test_userCan

    function test_ownerCanCollectFee() public {}
}