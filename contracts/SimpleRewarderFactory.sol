pragma solidity 0.8.7;
import "./utils/BoringFactory.sol";

contract SimpleRewarderFactory is BoringFactory {
    event LogWhiteListMasterContract(address indexed masterContract, bool approved);
    
    mapping(address => bool) public whitelistedMasterContracts;
    address owner;
    address masterRewarder;
    address masterManager;


    constructor(address _owner) public {
        owner = _owner;

    }

    function whitelistedMasterContract(address masterContract, bool approved) public {
        require(masterContract != address(0), "Cannot whitelist 0x0 address");

        whitelistedMasterContracts[masterContract] = approved;
        emit LogWhiteListMasterContract(masterContract, approved);
    }

    function deploySetup(bytes calldata _data, bytes calldata_ data) external returns (address rewarder, address manager) {
        // parse calldata

        // create rewarder
        rewarder = _createRewarder()

        // create manager

        
    }

    function createRewarder(address masterContract, bytes calldata _data) external returns (address rewarder) {
        rewarder = deploy(rewarderTemplates[_templateId], _data, true);
        // prob should emit event
    }
}