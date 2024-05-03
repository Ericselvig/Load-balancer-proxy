// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Registry} from "../../src/core/Registry.sol";

contract RegistryTest is Test {
    Registry public registry;

    function setUp() public {
        registry = new Registry();
    }

    function test_unauthorizedUserCannotAddOrChangeImplementation() public {}

    function test_ownerCanAddOrChangeImplementation() public {}

    function test_unauthorizedUserCannotRemoveImplementation() public {}

    function test_ownerCanRemoveImplementation() public {}

    
}