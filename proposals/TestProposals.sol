//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {console} from "@forge-std/console.sol";
import {Test} from "@forge-std/Test.sol";

import {Addresses} from "@proposals/Addresses.sol";
import {Proposal} from "@proposals/proposalTypes/Proposal.sol";
import {Constants} from '@proposals/utils/Constants.sol';

import {zip000} from "@proposals/zips/zip000.sol";
import {zipTest} from "@proposals/zips/zipTest.sol";

/*
How to use:
forge test --fork-url $RPC_URL --match-contract TestProposals -vvv

Or, from another Solidity file (for post-proposal integration testing):
    TestProposals proposals = new TestProposals();
    proposals.setUp();
    proposals.setDebug(false); // don't console.log
    proposals.testProposals();
    Addresses addresses = proposals.addresses();
*/

contract TestProposals is Test {
    Addresses public addresses;
    Proposal[] public proposals;

    function setUp() public {

        // Load proposals
        if (block.chainid == Constants.ANVIL) {
            proposals.push(Proposal(address(new zip000()))); /// Genesis token proposal
        }

        proposals.push(Proposal(address(new zipTest()))); /// RnD/testing only proposal

        addresses = proposals[0].addresses();

        for (uint256 i = 1; i < proposals.length; i++) {
            proposals[i].setAddresses(addresses);
        }

        vm.warp(block.timestamp + 1); /// required for timelock to work
    }

    function testProposals() public returns (uint256[] memory postProposalVmSnapshots) {
        console.log("TestProposals: running", proposals.length, "proposals.");

        /// evm snapshot array
        postProposalVmSnapshots = new uint256[](proposals.length);

        for (uint256 i = 0; i < proposals.length; i++) {
            string memory name = proposals[i].name();
            console.log("Proposal", name, "run()");

            proposals[i].run();

            /// output deployed contract addresses and names
            proposals[i].addresses().printRecordedAddresses();
            proposals[i].addresses().printChangedAddresses();

            /// take new snapshot
            postProposalVmSnapshots[i] = vm.snapshot();
        }

        return postProposalVmSnapshots;
    }
}
