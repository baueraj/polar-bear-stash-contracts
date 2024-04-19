// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/PolarBearStash.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PolarBearStashTest is DSTest {
    PolarBearStash stash;
    address deployer;

    function setUp() public {
        deployer = address(this);
        stash = new PolarBearStash();
    }

    function testInitialMint() public {
        uint256 totalSupply = stash.totalSupply();
        uint256 deployerBalance = stash.balanceOf(deployer);

        assertEq(totalSupply, 1_000_000 * 1 ether, "Total supply should match the initial mint amount");
        assertEq(deployerBalance, totalSupply, "Deployer should have all tokens");
    }
}
