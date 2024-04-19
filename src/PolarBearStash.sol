// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";


contract PolarBearStash is ERC20, ReentrancyGuard {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public constant INITIAL_SUPPLY = 1_000_000 * 1 ether;
    uint256 public constant BURN_PERCENTAGE = 1; // 1%
    uint256 public constant REWARD = 10 * 1 ether; // 10 tokens as a small reward
    uint256 public constant REWARD_INTERVAL = 30 minutes;
    uint256 public constant REWARD_DURATION = 7 days;
    address public constant BURN_ADDRESS = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;

    mapping(address => uint256) private lastTransfer;
    mapping(address => uint256) private rewardStart;
    EnumerableSet.AddressSet private holders;

    constructor() ERC20("PolarBearStash", "COLD") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 burnAmount = (amount * BURN_PERCENTAGE) / 100;
        super._transfer(sender, recipient, amount - burnAmount);
        super._transfer(sender, BURN_ADDRESS, burnAmount);

        if (rewardStart[sender] == 0) {
            rewardStart[sender] = block.timestamp;
        }
        if (rewardStart[recipient] == 0) {
            rewardStart[recipient] = block.timestamp;
        }

        _rewardPolarBearStash(sender);
        _rewardPolarBearStash(recipient);

        lastTransfer[sender] = block.timestamp;
        lastTransfer[recipient] = block.timestamp;

        holders.add(sender);
        holders.add(recipient);
    }

    function _rewardPolarBearStash(address holder) private {
        if (block.timestamp - lastTransfer[holder] >= REWARD_INTERVAL &&
            block.timestamp - rewardStart[holder] <= REWARD_DURATION) {
            _mint(holder, REWARD);
            lastTransfer[holder] = block.timestamp;
        }
    }
}
