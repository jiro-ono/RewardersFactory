/*pragma solidity 0.8.7;

import "./utils/BoringFactory.sol";



contract RewarderFactory is BoringFactory {


    /// @notice Array of rewarders created using the factory.
    address[] public rewarders;

    /// @notice Rewarder id to track respective rewarder template.
    uint256 public rewarderTemplateId;

    /// @notice Mapping from rewarder template id to rewarder template address.
    mapping(uint256 => address) private rewarderTemplates;

    /// @notice mapping from rewarder template address to rewarder template id
    mapping(address => uint256) private rewarderTemplateToId;

    /// @notice mapping from template type to template id
    mapping(uint256 => uint256) public currentTemplateId;

    /// @notice Event emitted when a rewarder is created using template id.
    event RewarderCreated(address indexed owner, address indexed addr, address rewarderTemplate);
    
    /// @notice event emitted when a token is initialized using template id
    event RewarderInitialized(address indexed addr, uint256 templateId, bytes data);

    /// @notice Event emitted when a rewarder template is added.
    event RewarderTemplateAdded(address newToken, uint256 templateId);

    /// @notice Event emitted when a rewarder template is removed.
    event RewarderTemplateRemoved(address token, uint256 templateId);


    constructor() public {
        // set owner here
    }

    function setCurrentTemplateId(uint256 _templateType, uint256 _templateId) external {
        // require to be owner
        require(rewarderTemplates[_templateId] != address(0), "incorrect _templateId");
        require(IRewarder(rewarderTemplates[_templateId]).rewarderTemplate() == _templateType, "incorrect _templateType");
        currentTemplateId[_templateType] == _templateId;
    }

    function addRewarderTemplate(address _template) external {
        // require to be owner
        uint256 templateType = IRewarder(_template).rewarderTemplate();
        require(templateType > 0, "Incorrect template code ");
        require(tokenTemplateToId[_template] == 0, "Template exists");

        rewarderTemplateId++;
        rewarderTemplates[rewarderTemplateId] = _template;
        rewarderTemplateToId[_template] = rewarderTemplateId;
        currentTemplateId[templateType] = rewarderTemplateId;

        emit RewarderTemplateAdded(_template, rewarderTemplateId);
    }

    function removeRewarderTemplate(uint256 _templateId) external {
        // require to be owner
        require(rewarderTemplates[_templateId] != address(0));
        address template = rewarderTemplates[_templateId];
        uint256 templateType = IRewarder(rewarderTemplates[_templateId]).rewarderTemplate();
        if (currentTemplateId[templateType] == _templateId) {
            delete currentTemplateId[templateType];
        }
        rewarderTemplates[_templateId] = address(0);
        delete rewarderTemplateToId[template];
        emit RewarderTemplateRemoved(template, _templateId);
    }


    function createRewarder(
        uint256 _templateId,
        bytes calldata _data
    ) 
        external returns (address rewarder)
    {
        require(rewarderTemplates[_templateId] != address(0), "incorrect _templateId");
        rewarder = deploy(rewarderTemplates[_templateId], _data, true);
        rewarders.push(rewarder);
        emit RewarderCreated(msg.sender, rewarder, rewarderTemplates[_templateId]);
    }


    function numberOfRewarders() external view returns (uint256) {
        return rewarders.length;
    }

    function getRewarders() external view returns (address[] memory) {
        return rewarders;
    }

    function getRewarderTemplate(uint256 _templateId) external view returns (address ) {
        return rewarderTemplates[_templateId];
    }

    function getTemplateId(address _rewarderTemplate) external view returns (uint256) {
        return rewarderTemplateToId[_rewarderTemplate];
    }

}*/