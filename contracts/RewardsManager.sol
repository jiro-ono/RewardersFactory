// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "solmate/src/tokens/ERC20.sol";

interface StakingRewards {
    function periodFinish() external view returns (uint256);
    function notifyRewardAmount(uint256 reward, address rewardHolder) external;
}

contract RewardsManager {
    address public owner;
    address public rewardsContract;
    address public rewardToken;

    constructor() {
    }

    function transferOwnership(address _to) external {
        require(msg.sender == owner, "not permitted");
        owner = _to;
    }

    function init(address _rewardToken, address _rewardContract, address _owner) public payable {
        require(rewardToken == address(0), "Rewards Manager: already initialized");
       //(rewardToken, rewardContract, owner) = abi.encode(data, (ERC20, address, address));
        rewardToken = _rewardToken;
        rewardsContract = _rewardContract;
        owner = _owner;
        require(rewardToken != address(0), "Rewards Manager: bad token");
    }

    function setRewardsContract(address _rewardsContract) external {
        require(msg.sender == owner, "not permitted");
        rewardsContract = _rewardsContract;
    }

    function setRewardToken(address _rewardToken) external {
        require(msg.sender == owner, "not permitted");
        rewardToken = _rewardToken;
    }

    function _periodFinish() internal view returns (uint256) {
        return StakingRewards(rewardsContract).periodFinish();
    }

    function _isRewardsPeriodFinished() internal view returns (bool) {
        return block.timestamp >= _periodFinish();
    }

    function periodFinish() external view returns (uint256) {
        return _periodFinish();
    }

    function startNextRewardsPeriod() external {
        address rewards = rewardsContract;
        uint256 amount =  ERC20(rewardToken).balanceOf(address(this));

        require(rewards != address(0), "rewardsContract not set");
        require(amount != 0, "contract has no reward tokens");
        require(_isRewardsPeriodFinished() == true, "reward period not finished");

        ERC20(rewardToken).approve(rewards, amount);
        StakingRewards(rewards).notifyRewardAmount(amount, address(this));
    }

    function recoverERC20(address _token, uint256 amount, address _to) external {
        require(msg.sender == owner, "not permitted");
        if (amount != 0) {
            ERC20(_token).transfer(_to, amount);
        }
    }
}