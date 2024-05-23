// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@forge-std/Test.sol";
import {getAIModelPlatform, getRevertMessage} from "@test/fixtures/Fixtures.sol";

import {AIModelPlatform} from "@protocol/AIModelPlatform.sol";
import {Roles} from "@protocol/Roles.sol";
import {TestAddresses} from "@test/fixtures/TestAddresses.sol";


contract UnitTestAIModelPlatform is Test {
    AIModelPlatform public aiModelPlatform;

    function setUp() public {
        aiModelPlatform = getAIModelPlatform(vm);
    }

    function testRoleAssignments() public {
        assertTrue(aiModelPlatform.hasRole(Roles.ADMIN_ROLE, TestAddresses.admin));
        assertTrue(aiModelPlatform.hasRole(Roles.SUB_NODE_ROLE, TestAddresses.subNode1));
        assertTrue(aiModelPlatform.hasRole(Roles.SUB_NODE_ROLE, TestAddresses.subNode2));
        assertTrue(aiModelPlatform.hasRole(Roles.MASTER_NODE_ROLE, TestAddresses.masterNode));
    }

    function testRegisterModel() public {
        vm.prank(TestAddresses.admin);
        aiModelPlatform.registerModel("Model1", "TypeA", "QuantType1", "ExecutionCode1", "ModelData1", "CalibrationData1");
        (uint256 modelId, string memory name,,,,,) = aiModelPlatform.models(1);
        assertEq(modelId, 1);
        assertEq(name, "Model1");
    }

    function testRegisterModelRoleFail() public {
        string memory errorMessage = getRevertMessage(Roles.ADMIN_ROLE, TestAddresses.user);
        testRegisterModel();
        vm.prank(TestAddresses.user);
        vm.expectRevert(bytes(errorMessage));
        aiModelPlatform.registerModel("Model1", "TypeA", "QuantType1", "ExecutionCode1", "ModelData1", "CalibrationData1");
    }

    function testCreateRequest() public {
        testRegisterModel();
        vm.prank(TestAddresses.user);
        aiModelPlatform.createRequest("RequestData1", 1);
        (uint256 requestId, uint256 modelId, string memory requestData, address userAddress,,) = aiModelPlatform.requests(1);
        assertEq(requestId, 1);
        assertEq(modelId, 1);
        assertEq(requestData, "RequestData1");
        assertEq(userAddress, TestAddresses.user);
    }

    function testCreateRequestNoModelFail() public {
        vm.prank(TestAddresses.user);
        vm.expectRevert('AIModelPlatform: no model exist');
        aiModelPlatform.createRequest("RequestData1", 1);
    }


    function testSubNodeRaiseHand() public {
        testCreateRequest();
        vm.prank(TestAddresses.subNode1);
        aiModelPlatform.subNodeRaiseHand(1);
        // Check event emitted in logs
    }

    function testSubNodeRaiseHandRoleFail() public {
        string memory errorMessage = getRevertMessage(Roles.SUB_NODE_ROLE, TestAddresses.user);
        vm.prank(TestAddresses.user);
        vm.expectRevert(bytes(errorMessage));
        aiModelPlatform.subNodeRaiseHand(1);
        // Check event emitted in logs
    }

    function testMasterNodeAcceptSubNode() public {
        testSubNodeRaiseHand();
        address[] memory subNodes = new address[](1);
        subNodes[0] = TestAddresses.subNode1;
        // subNodes[1] = TestAddresses.subNode2;
        
        vm.prank(TestAddresses.masterNode);
        aiModelPlatform.masterNodeAcceptSubNode(subNodes, 1);
        // Check event emitted in logs
    }


    function testMasterNodeAcceptSubNode_RequestNotReadyFail() public {
        address[] memory subNodes = new address[](2);
        subNodes[0] = TestAddresses.subNode1;
        subNodes[1] = TestAddresses.subNode2;
        
        vm.prank(TestAddresses.masterNode);
        vm.expectRevert("AIModelPlatform: request not ready");
        aiModelPlatform.masterNodeAcceptSubNode(subNodes, 1);
        // Check event emitted in logs
    }


    function testMasterNodeAcceptSubNode_SubNodeNotReadyFail() public {
        testSubNodeRaiseHand();
        address[] memory subNodes = new address[](2);
        subNodes[0] = TestAddresses.subNode1;
        subNodes[1] = TestAddresses.subNode2;
        
        vm.prank(TestAddresses.masterNode);
        vm.expectRevert("AIModelPlatform: subnode not ready");

        aiModelPlatform.masterNodeAcceptSubNode(subNodes, 1);
        // Check event emitted in logs
    }

    function testMasterNodeAcceptSubNode_RoleFail() public {
        string memory errorMessage = getRevertMessage(Roles.MASTER_NODE_ROLE, TestAddresses.user);
        address[] memory subNodes = new address[](2);
        subNodes[0] = TestAddresses.subNode1;
        subNodes[1] = TestAddresses.subNode2;
    
        vm.prank(TestAddresses.user);
        vm.expectRevert(bytes(errorMessage));
        aiModelPlatform.masterNodeAcceptSubNode(subNodes, 1);
        // Check event emitted in logs
    }
    function testSubNodeIntermediateAnswer() public {
        testMasterNodeAcceptSubNode();
        vm.prank(TestAddresses.subNode1);
        aiModelPlatform.subNodeIntermediateAnswer(1, "AnswerLink1");
        // Check event emitted in logs
    }

    function testMasterNodeFinalAnswer() public {
        testSubNodeIntermediateAnswer();
        vm.prank(TestAddresses.masterNode);
        aiModelPlatform.masterNodeFinalAnswer(1, "FinalAnswerLink1");
        // Check event emitted in logs
    }

    function testAssignSubNode() public {
        address newSubNode = address(0x6);
        vm.prank(TestAddresses.admin);
        aiModelPlatform.assignSubNode(newSubNode, 1);
        assertTrue(aiModelPlatform.hasRole(Roles.SUB_NODE_ROLE, newSubNode));
    }

    function testAssignMasterNode() public {
        address newMasterNode = address(0x7);
        vm.prank(TestAddresses.admin);
        aiModelPlatform.assignMasterNode(newMasterNode);
        assertTrue(aiModelPlatform.hasRole(Roles.MASTER_NODE_ROLE, newMasterNode));
    }
}