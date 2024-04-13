// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";


contract PolarBearStash is ERC20, ReentrancyGuard {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 1 ether;
    uint256 public constant BURN_PERCENTAGE = 1; // 1%
    address public constant BURN_ADDRESS = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;

    mapping(address => uint256) private lastTransfer;
    EnumerableSet.AddressSet private holders;

    constructor() ERC20("ColdStash", "COLD"){
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 burnAmount = (amount * BURN_PERCENTAGE) / 100;
        super._transfer(sender, recipient, amount - burnAmount);
        super._transfer(sender, BURN_ADDRESS, burnAmount);

        _rewardPolarBearStash(sender);
        lastTransfer[sender] = block.timestamp;
        lastTransfer[recipient] = block.timestamp;

        holders.add(sender);
        holders.add(recipient);
    }

    function _rewardPolarBearStash(address holder) private {
        if (block.timestamp - lastTransfer[holder] > 30 days) {
            uint256 reward = calculateReward(holder);
            _mint(holder, reward);
        }
    }

    function calculateReward(address holder) public view returns (uint256) {
        // Implement reward calculation logic based on token holding duration and amount
        // Simplified example: 1 token reward for each week of holding, capped at a certain max
        uint256 heldWeeks = (block.timestamp - lastTransfer[holder]) / 7 days;
        return heldWeeks * 1 ether; // Simplified reward calculation
    }
}
