//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {Addresses} from "@proposals/Addresses.sol";
import {Proposal} from "@proposals/proposalTypes/Proposal.sol";
import {TimelockProposal} from "@proposals/proposalTypes/TimelockProposal.sol";

import {AIModelPlatform} from "@protocol/AIModelPlatform.sol";
import {Roles} from "@protocol/Roles.sol";

contract aip001 is TimelockProposal {
    string private constant ADDRESSES_PATH = "proposals/Addresses.json";
    AIModelPlatform private aiModelPlatform;

    constructor() Proposal("DEPLOYER") {}

    // Returns the name of the proposal.
    function name() public pure override returns (string memory) {
        return "AIP001";
    }

    // Provides a brief description of the proposal.
    function description() public pure override returns (string memory) {
        return "The AIP Deploy Main Contract";
    }

    function _beforeDeploy() internal override {}

    function _deploy() internal override {
        /// Token deployment
        {
            aiModelPlatform = new AIModelPlatform();
            addresses.addAddress("AIModelPlatform", address(aiModelPlatform), true);

        }
    }

    function _afterDeploy() internal override {

            aiModelPlatform.grantRole(Roles.ADMIN_ROLE, addresses.getAddress("ADMIN"));
            aiModelPlatform.assignSubNode(addresses.getAddress("SUBNODE1"), 2);
            aiModelPlatform.assignSubNode(addresses.getAddress("SUBNODE2"), 1);
            aiModelPlatform.assignMasterNode(addresses.getAddress("MASTER_NODE"));    
    }

    function _validate() internal override {
        /// Check Treasury balance
        // assertEq(
        //     IERC20(addresses.getAddress("TOKEN")).balanceOf(addresses.getAddress("TREASURY_WALLET_MULTISIG")),
        //     10_000_000_000e18 // hardcoded to verfiy all code is working
        // );
    }

}
