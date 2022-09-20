import { ethers } from "hardhat";
import { Signer, BigNumber } from "ethers";
import { expect } from "chai";
import { StakingCloneRewarder__factory, RewardsManager__factory, MiniChefManager__factory } from '../types'

describe("Factory Deployment & Setup", function () {

});


describe("CloneRewarder Deployment & Setup", function() {
    it("Owner is EOA that interacted with factory", async function () {
    
    });

    it("Stranger cannot transfer ownership", async function () {
    
    });

    it("Owner can transfer ownership", async function () {
    
    });

    it("Owner can transfer ownership to 0x0 address", async function () {
    
    });

    it("Stranger cannot set rewards contract", async function () {
    
    });

    it("Owner can set rewards contract", async function () {
    
    });

    it("Stranger cannot recover tokens", async function () {
    
    });

    it("Owner can recover tokens", async function () {
    
    });

    it("Stranger can check if rewards period is finished", async function () {
    
    });

    it("Stranger can check rewards period", async function () {
    
    });

    it("Stranger cannot start new reward period w/o reward contract set", async function () {
    
    });

    it("Stranger cannot start new reward period w/ zero amount", async function () {
    
    });

    it("Stranger starts next reward period", async function () {
    
    });

    it("Stranger cannot start new reward period while current is active", async function () {
    
    });

    it("Stranger cannot start new reward period while current is active", async function () {
    
    });

    it("Stranger can start new reward period after current is finished", async function () {
    
    });
    
});

describe("Integration Tests", function () {
    let accounts: Signer[];


    before(async function () {
        accounts = await ethers.getSigners();
        const ERC20 = await ethers.getContractFactory('TestERC20');

    });

    it("Should fully setup a new StakingCloneRewarder & RewardManager", async function () {
        const ERC20 = await ethers.getContractFactory('TestERC20');
        const sushiToken = await ERC20.deploy();
        const rewardToken = await ERC20.deploy();
        const stakingToken = await ERC20.deploy();

        
        const StakingCloneRewarder: StakingCloneRewarder__factory = await ethers.getContractFactory(
            "StakingCloneRewarder"
        );

        const RewardsManager: RewardsManager__factory = await ethers.getContractFactory(
            "RewardsManager"
        );

        const MiniChefManager: MiniChefManager__factory = await ethers.getContractFactory(
            "MiniChefV2"
        );

        // init minichef
        const minichef = await MiniChefManager.deploy(sushiToken.address);
        await minichef.setSushiPerSecond(1);

        expect(await minichef.sushiPerSecond()).to.equal(1);


        // init reward manager
        const rewards_manager = await RewardsManager.deploy();
        rewards_manager.init(rewardToken.address, rewards_manager.address, "0x4bb4c1B0745ef7B4642fEECcd0740deC417ca0a0");
        
        // init rewarder
        const test_rewarder = await StakingCloneRewarder.deploy(
            minichef.address, // masterchef
            "0x4bb4c1B0745ef7B4642fEECcd0740deC417ca0a0", // owner
            rewards_manager.address, // distributor
            rewardToken.address, // rewardToken
            stakingToken.address, // stakingToken
            2592000
        );
        

        // check rewarder is setup
        expect(await test_rewarder.rewardToken()).to.equal(rewardToken.address);


        // check reward manager is setup
        expect(await rewards_manager.owner()).to.equal("0x4bb4c1B0745ef7B4642fEECcd0740deC417ca0a0");

    });

});


describe("Test User Actions", function () {
    it("User successfully deposits tokens", async function () {
    
    });

    it("User successfully withdraws tokens", async function () {
    
    });

    it("User successfully harvests w/ no rewards", async function () {
    
    });

    it("User successfully harvests w/ rewards", async function () {
    
    });

    it("User successfully withdraws & harvests", async function () {
    
    });

    it("User successfully withdraws & harvests empty balance", async function () {
    
    });

    it("Users successfully emergency withdraws", async function () {
    
    });
});


describe("Rewarder Details", function () {
    it("Total supply matches what's staked", async function () {
        
    });

    it("onSushiReward reverts when called by stranger", async function () {
    
    });

    it("onSushiReward reverts when called w/ wrong pid", async function () {
    
    });

    it("onSushiRewards updates balance", async function () {
    
    });

    it("pendingTokens called with wrong pid", async function () {
    
    });

    it("pendingTokens called with correct pid", async function () {
    
    });

    it("rewardPerSecond is correct", async function () {
    
    });

    it("rewardToken is correct", async function () {
    
    });

    it("updatePeriodFinish called by stranger", async function () {
    
    });

    it("updatePeriodFinish called", async function () {
    
    });
});


describe("Full Test", function () {
   /* Test Case:
# 1. Deploy Rewarder and add to MasterChefV2 pool with deployed rewarder
# 2. Deploy RewardManager and connect it to Rewarder
# 3. DAO transfers LDO to RewardsManager contract
# 4. Someone starts new reward period
# 5. Users A and B buy wstETH tokens and exchange ETH on DAI to become lp providers
# 6. Users A and B deposit their lp tokens into the created pool via MasterChefV2 contract
# 7. Wait half of the reward period and harvest rewards by test users
# 8. Harvest reward again when reward period passed
# 9. DAO transfers LDO to RewardsManager contract to start second reward period
# 10. Stranger starts new reward period
# 11. User A withdraws money and harvest at the middle of second reward period
# 12. Wait till the end of the second reward period
# 13. User B harvest money for passed period
# 14. User A has no rewards because he withdrawn his tokens earlier */
});