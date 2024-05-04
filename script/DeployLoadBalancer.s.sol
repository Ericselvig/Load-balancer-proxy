// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {LoadBalancer} from "../src/core/LoadBalancer.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Staking} from "../src/implementations/Staking.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract DeployLoadBalancer is Script {
    LoadBalancer public lb;
    Staking public staking;
    ERC20Mock public token;

    function setUp() public {
    }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        lb = new LoadBalancer();
        token = new ERC20Mock();
        staking = new Staking();
        lb.addOrChangeImplementation(1, address(staking));
        (bool ok, ) = address(lb).call(abi.encode(1, abi.encodeWithSignature("initialize(address)", address(token))));
        if (!ok) {
            revert();
        }
        vm.stopBroadcast();
    }
}