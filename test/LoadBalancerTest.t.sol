// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {LoadBalancer} from "../src/core/LoadBalancer.sol";

contract LoadBalancerTest is Test {
    LoadBalancer lb;
    function setUp() public {
        lb = new LoadBalancer();
    }

    function test_ownerCanAddOrChangeImplementation() public {
        lb.addOrChangeImplementation(1, address(1));
        assertEq(lb.getImplementationAddress(1), address(1));
    }

    function test_unauthorizedUserCannotAddOrChangeImplementation() public {
        vm.prank(makeAddr("alice"));
        vm.expectRevert();
        lb.addOrChangeImplementation(1, address(1));
    }

    function test_ownerCanRemoveImplementation() public {
        lb.addOrChangeImplementation(1, address(1));
        lb.removeImplementation(1);
        assertEq(lb.getImplementationAddress(1), address(0));
    }

    function test_unauthorizedUserCannotRemoveImplementation() public {
        lb.addOrChangeImplementation(1, address(1));
        vm.prank(makeAddr("alice"));
        vm.expectRevert();
        lb.removeImplementation(1);
    }

    function test_ownerCannotAddZeroAddressImplementation() public {
        vm.expectRevert();
        lb.addOrChangeImplementation(1, address(0));
    }
}