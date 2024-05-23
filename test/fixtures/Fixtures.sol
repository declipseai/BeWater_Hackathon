// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {AIModelPlatform} from "@protocol/AIModelPlatform.sol";
import {Roles} from "@protocol/Roles.sol";
import {TestAddresses} from "./TestAddresses.sol";
import "@forge-std/Test.sol";

/// @notice Deploy and configure Core
/// @param vm Virtual machine
/// @return Core
function getAIModelPlatform(Vm vm) returns (AIModelPlatform) {
    // Deploy Core from admin address
    vm.startPrank(TestAddresses.admin);
    AIModelPlatform aiModelPlatform = new AIModelPlatform();
    aiModelPlatform.grantRole(Roles.ADMIN_ROLE, TestAddresses.admin);
    aiModelPlatform.assignSubNode(TestAddresses.subNode1, 1);
    aiModelPlatform.assignSubNode(TestAddresses.subNode2, 0);
    aiModelPlatform.assignMasterNode(TestAddresses.masterNode);
    vm.stopPrank();
    return aiModelPlatform;
}


/// @notice Get the revert message
/// @param role Role
/// @param account Account address
/// @return Revert message
function getRevertMessage(bytes32 role, address account) pure returns (string memory) {
    return
        string(
            abi.encodePacked(
                "AccessControl: account ",
                Strings.toHexString(account),
                " is missing role ",
                Strings.toHexString(uint256(role), 32)
            )
        );
}
