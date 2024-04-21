// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PolarBearStash.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PolarBearStashTest is Test {
    PolarBearStash private stash;
    address private deployer;
    address private constant alice = address(0x1);
    address private constant bob = address(0x2);

    function setUp() public {
        deployer = address(this); // The test contract itself, holding *all* initial tokens
        stash = new PolarBearStash();

        vm.startPrank(deployer);
        stash.transfer(alice, 500000 * 1 ether);
        vm.stopPrank();
    }

    function testInitialMint() public view {
        uint256 totalSupply = stash.totalSupply();
        uint256 deployerBalance = stash.balanceOf(deployer);

        assertEq(totalSupply, 1_000_000 * 1 ether, "Total supply should match the initial mint amount");
        assertEq(deployerBalance, 500000 * 1 ether, "Deployer should have half of all tokens after distribution");
    }

    function testRewardDistribution() public {
        // Simulate passage of time and trigger transfer
        vm.startPrank(alice);
        stash.transfer(bob, 1000 * 1 ether); // Initial transfer to kick off them sweet, sweet rewards
        vm.stopPrank();

        // Fast forward time by n minutes
        vm.warp(block.timestamp + 30 minutes);

        // Transfer from bob to alice
        vm.startPrank(bob);
        stash.transfer(alice, 100 * 1 ether);
        vm.stopPrank();

        // Check balance to verify reward was paid
        /*
        * Expected balance calculation:
        * - Initial balance: 990 tokens (received from Alice, after 1% burn)
        * - Transferred to Alice: -100 tokens
        * - Reward: +10 tokens
        * - Expected balance: 900 tokens (990 - 100 + 10)
        */
        uint256 balanceAfterRewards = stash.balanceOf(bob);
        uint256 expectedBalance = 900 * 1 ether;
        assertEq(balanceAfterRewards, expectedBalance, "Rewards not distributed correctly");
    }
}
