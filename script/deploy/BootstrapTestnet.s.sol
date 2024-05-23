// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {console} from "@forge-std/console.sol";
import {Script} from "@forge-std/Script.sol";
import {Addresses} from "@proposals/Addresses.sol";
import {Proposal} from "@proposals/proposalTypes/Proposal.sol";

import {aip000} from "@proposals/aips/aip000.sol";
import {aip001} from "@proposals/aips/aip001.sol";

/*
How to use:
forge script script/deploy/BootstrapTestnet.s.sol:BootstrapTestnet \
    -vvvv \
    --rpc-url $ETH_RPC_URL \
    --broadcast \
    --private-key <KEY>
Remove --broadcast and --private-key if you want to try locally first, without paying any gas.
*/

contract BootstrapTestnet is Script {
    uint256 public privateKey;

    Addresses addresses;
    Proposal[] public proposals;

    function setUp() public {
        string memory environment = vm.envOr("ENVIRONMENT", string("localnet"));
        string memory addressPath = string(abi.encodePacked("proposals/Addresses/", environment, ".json"));
        addresses = new Addresses(addressPath);
        addresses.resetRecordingAddresses();

        // Load proposals
        proposals.push(Proposal(address(new aip000()))); /// Genesis token proposal
        proposals.push(Proposal(address(new aip001()))); /// 
    }

    function run() public {
        for (uint256 i = 0; i < proposals.length; i++) {
            string memory name = proposals[i].name();
            console.log("Proposal", name, "deploy()");
            addresses.resetRecordingAddresses();

            // Run the deploy for testing only workflow
            proposals[i].run();

            /// output deployed contract addresses and names
            (string[] memory recordedNames, , address[] memory recordedAddresses) = Addresses(proposals[i].addresses())
                .getRecordedAddresses();
            for (uint256 j = 0; j < recordedNames.length; j++) {
                console.log("  Deployed", recordedAddresses[j], recordedNames[j]);
            }
        }
    }
}
