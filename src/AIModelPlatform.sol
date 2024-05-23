// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Importing necessary OpenZeppelin contracts and custom roles
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Roles} from "@protocol/Roles.sol";

contract AIModelPlatform is AccessControl {
    using Counters for Counters.Counter;

    // Struct to store model information
    struct Model {
        uint256 modelId;
        string name;
        string modelType;
        string quantizationType;
        string executionCode;
        string modelData;
        string calibrationData;
    }

    // Struct to store subnode information
    struct SubNode {
        address subNodeAddress;
        uint32 failCount;
        uint32 successCount;
        uint8 performanceTier; // 0: not assigned, 1: High, 2: Low
    }

    // Struct to store intermediate answer information
    struct IntermediateAnswer {
        string answerLink;
        uint8 status; // 0: not assigned, 1: raised hand, 2: assigned, 3: answered
    }

    // Struct to store final answer information
    struct FinalAnswer {
        address masterNodeAddress;
        string answerLink;
    }

    // Struct to store request information
    struct Request {
        uint256 requestId;
        uint256 modelId;
        string requestData;
        address userAddress;
        uint8 status; // 0: not created, 1: created, 2: subnode raised hand, 3: masternode Selected, 4: subnode answered, 5: answer finished 
        address[] subNodes;
        mapping(address => IntermediateAnswer) intermediateAnswers;
        FinalAnswer finalAnswer;
    }

    // Counters for model and request IDs
    Counters.Counter private _modelIdCounter;
    Counters.Counter private _requestIdCounter;

    // Mappings to store models, subnodes, and requests
    mapping(uint256 => Model) public models;
    mapping(address => SubNode) public subNodes;
    mapping(uint256 => Request) public requests;

    // Events for logging actions
    event ModelRegistered(uint256 modelId, string name);
    event RequestRegistered(uint256 requestId, uint256 modelId, address indexed user);
    event SubNodeRaiseHand(address indexed subNodeAddress, uint256 requestId);
    event MasterNodeAcceptSubNode(address[] subNodeAddresses, uint256 requestId);
    event SubNodeIntermediateAnswer(address indexed subNodeAddress, uint256 requestId);
    event MasterNodeFinalAnswer(address indexed masterNodeAddress, uint256 requestId);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(Roles.ADMIN_ROLE, msg.sender);
        _modelIdCounter.increment(); // Start model ID counter at 1
        _requestIdCounter.increment(); // Start request ID counter at 1
    }

    // Function to get intermediate answers for a request and subnode address
    function intermediateAnswers(uint256 requestId, address subNodeAddress) public view returns (string memory, uint8) {
        require(requestId < _requestIdCounter.current(), "Invalid requestId");
        require(requests[requestId].status > 0, "Request not found");
        require(requests[requestId].intermediateAnswers[subNodeAddress].status != 0, "No intermediate answer for this subNode");

        return (
            requests[requestId].intermediateAnswers[subNodeAddress].answerLink,
            requests[requestId].intermediateAnswers[subNodeAddress].status
        );
    }

    // Function to register a model
    function registerModel(string memory name, string memory modelType, string memory quantizationType, string memory executionCode, string memory modelData, string memory calibrationData) public onlyRole(Roles.ADMIN_ROLE) returns(uint) {
        uint256 modelId = _modelIdCounter.current();
        models[modelId] = Model(modelId, name, modelType, quantizationType, executionCode, modelData, calibrationData);
        _modelIdCounter.increment();
        emit ModelRegistered(modelId, name);
        return modelId;
    }

    // Function to create a request
    function createRequest(string memory requestData, uint256 modelId) public {
        require(modelId < _modelIdCounter.current() && modelId != 0, "AIModelPlatform: no model exist");
        uint256 requestId = _requestIdCounter.current();
        Request storage tempRequest = requests[requestId];
        tempRequest.requestId = requestId;
        tempRequest.modelId = modelId;
        tempRequest.requestData = requestData;
        tempRequest.userAddress = msg.sender;
        tempRequest.status = 1;
        _requestIdCounter.increment();
        emit RequestRegistered(requestId, modelId, msg.sender);
    }

    // Function for subnode to raise hand
    function subNodeRaiseHand(uint256 requestId) public onlyRole(Roles.SUB_NODE_ROLE) {
        require(requests[requestId].status != 0, "AIModelPlatform: request not created");
        require(requests[requestId].status < 3, "AIModelPlatform: master node already accepted");
        require(requests[requestId].intermediateAnswers[msg.sender].status == 0, "AIModelPlatform: already raised hand");
        requests[requestId].intermediateAnswers[msg.sender].status = 1;
        requests[requestId].status = 2;

        emit SubNodeRaiseHand(msg.sender, requestId);
    }

    // Function for master node to accept subnodes
    function masterNodeAcceptSubNode(address[] memory subNodeAddresses, uint256 requestId) public onlyRole(Roles.MASTER_NODE_ROLE) {
        require(requests[requestId].status == 2, "AIModelPlatform: request not ready");
        requests[requestId].status = 3;
        requests[requestId].finalAnswer.masterNodeAddress = msg.sender;
        for (uint256 i = 0; i < subNodeAddresses.length; i++) {
            require(requests[requestId].intermediateAnswers[subNodeAddresses[i]].status == 1, "AIModelPlatform: subnode not ready");
            requests[requestId].intermediateAnswers[subNodeAddresses[i]].status = 2;
        }
        requests[requestId].subNodes = subNodeAddresses;
        emit MasterNodeAcceptSubNode(subNodeAddresses, requestId);
    }

    // Function for subnode to submit intermediate answer
    function subNodeIntermediateAnswer(uint256 requestId, string memory answerLink) public onlyRole(Roles.SUB_NODE_ROLE) {
        require(requests[requestId].status == 3 || requests[requestId].status == 4, "AIModelPlatform: No MasterNode");
        require(requests[requestId].intermediateAnswers[msg.sender].status > 1, "AIModelPlatform: work not assigned");
        require(requests[requestId].intermediateAnswers[msg.sender].status < 3, "AIModelPlatform: already answered");
        requests[requestId].status = 4;
        requests[requestId].intermediateAnswers[msg.sender].status = 3;
        requests[requestId].intermediateAnswers[msg.sender].answerLink = answerLink;

        emit SubNodeIntermediateAnswer(msg.sender, requestId);
    }

    // Function for master node to submit final answer
    function masterNodeFinalAnswer(uint256 requestId, string memory answerLink) public onlyRole(Roles.MASTER_NODE_ROLE) {
        require(requests[requestId].status == 4, "AIModelPlatform: request not ready");
        require(requests[requestId].finalAnswer.masterNodeAddress == msg.sender, "AIModelPlatform: invalid masternode");

        address[] memory subNodeAddresses = requests[requestId].subNodes;
        for (uint256 i = 0; i < subNodeAddresses.length; i++) {
            if(requests[requestId].intermediateAnswers[subNodeAddresses[i]].status != 3) {
                subNodes[subNodeAddresses[i]].failCount++;
            } else {
                subNodes[subNodeAddresses[i]].successCount++;
            }
        }
        requests[requestId].status = 5;
        requests[requestId].finalAnswer.answerLink = answerLink;
        emit MasterNodeFinalAnswer(msg.sender, requestId);
    }

    // Function to assign a subnode
    function assignSubNode(address subNodeAddress, uint8 performanceTier) public onlyRole(Roles.ADMIN_ROLE) {
        subNodes[subNodeAddress] = SubNode(subNodeAddress, 0, 0, performanceTier);
        _setupRole(Roles.SUB_NODE_ROLE, subNodeAddress);
    }

    // Function to assign a master node
    function assignMasterNode(address masterNodeAddress) public onlyRole(Roles.ADMIN_ROLE) {
        _setupRole(Roles.MASTER_NODE_ROLE, masterNodeAddress);
    }
}
