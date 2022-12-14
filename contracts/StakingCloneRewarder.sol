// SPDX-FileCopyrightText: 2021 Lido <info@lido.fi>
// SPDX-License-Identifier: MIT

pragma solidity 0.5.17;

import "./StakingRewards.sol";

/// @notice Interface which any contract has to implement
/// to be used in MasterChefV2 contract as Rewarder
interface IRewarder {
    function onSushiReward(
        uint256 pid,
        address user,
        address recipient,
        uint256 sushiAmount,
        uint256 newLpAmount
    ) external;

    function pendingTokens(
        uint256 pid,
        address user,
        uint256 sushiAmount
    ) external view returns (IERC20[] memory, uint256[] memory);
}

/// @notice Slice of methods of MasterChefV2 contract used in StakingRewardsSushi contract
interface IMasterChefV2 {
    function lpToken(uint256 pid) external view returns (IERC20 _lpToken);
}

/// @notice Rewarder to be used in MasterChefV2 contract based on
/// Synthetix's StakingRewards contract
/// @author psirex
contract StakingCloneRewarder is StakingRewards, IRewarder {
    //address public constant MASTERCHEF_V2 = 0xEF0881eC094552b2e128Cf945EF17a6752B4Ec5d;
    
    address public MASTERCHEF;
    address public rewarder_factory;
    constructor(
        address _masterchef,
        address _owner,
        address _rewardsDistribution,
        address _rewardsToken,
        address _stakingToken,
        uint256 _rewardsDuration
    )
        public
        StakingRewards(_owner, _rewardsDistribution, _rewardsToken, _stakingToken, _rewardsDuration)
    {
        rewarder_factory = msg.sender;
        MASTERCHEF = _masterchef;
    }

    /// @notice Implements abstract methods from StakingRewards contract
    /// and returns total amount of staked tokens in the pool.
    /// @dev Instead of storing this value in standalone variable and update it
    /// when user balances updates, we can take this value from the stakingToken directly.
    function totalSupply() public view returns (uint256) {
        return stakingToken.balanceOf(MASTERCHEF);
    }

    /// @notice Returns list of rewardTokens and list of corresponding earned rewards of user
    function pendingTokens(
        uint256 pid,
        address user,
        uint256
    ) external view returns (IERC20[] memory _rewardTokens, uint256[] memory _rewardAmounts) {
        if (_isCorrectPoolId(pid)) {
            _rewardTokens = new IERC20[](1);
            _rewardTokens[0] = rewardsToken;
            _rewardAmounts = new uint256[](1);
            _rewardAmounts[0] = earned(user);
        }
    }

    /// @notice Returns current reward per second value
    /// @dev This method is required to make Rewarder compatible with SushiSwap's UI
    function rewardPerSecond() external view returns (uint256) {
        if (block.timestamp > periodFinish) {
            return 0;
        }
        return rewardRate;
    }

    /// @notice Returns address of reward token
    /// @dev This method is required to make Rewarder compatible with SushiSwap's UI
    function rewardToken() external view returns (IERC20) {
        return rewardsToken;
    }

    /// @notice Pays reward to user and updates balance of user when called by MasterChefV2 contract
    /// with correct pid value
    /// @dev On every call of this method StakingRewardsSushi will transfer earned tokens of user
    /// to passed recipient address.
    function onSushiReward(
        uint256 pid,
        address user,
        address recipient,
        uint256,
        uint256 newLpAmount
    ) external onlyMCV2 {
        require(_isCorrectPoolId(pid), "Wrong PID.");
        _payReward(user, recipient);
        _balances[user] = newLpAmount;
    }

    function _isCorrectPoolId(uint256 pid) private view returns (bool) {
        return IMasterChefV2(MASTERCHEF).lpToken(pid) == stakingToken;
    }

    modifier onlyMCV2() {
        require(msg.sender == MASTERCHEF, "Only MCV2 can call this function.");
        _;
    }
}