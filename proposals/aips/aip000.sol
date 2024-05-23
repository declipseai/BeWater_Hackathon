//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {Addresses} from "@proposals/Addresses.sol";
import {Proposal} from "@proposals/proposalTypes/Proposal.sol";
import {TimelockProposal} from "@proposals/proposalTypes/TimelockProposal.sol";

import {Roles} from "@protocol/Roles.sol";
import {Token, MAX_SUPPLY} from "@protocol/Token.sol";

contract aip000 is TimelockProposal {
    string private constant ADDRESSES_PATH = "proposals/Addresses.json";

    constructor() Proposal("DEPLOYER") {}

    // Returns the name of the proposal.
    function name() public pure override returns (string memory) {
        return "AIP000";
    }

    // Provides a brief description of the proposal.
    function description() public pure override returns (string memory) {
        return "The Eclipse AI Genesis Proposal";
    }

    function _beforeDeploy() internal override {}

    function _deploy() internal override {
        /// Token deployment
        {
            Token token = new Token(
                string(abi.encodePacked(vm.envString("TOKEN_NAME"))),
                string(abi.encodePacked(vm.envString("TOKEN_SYMBOL")))
            );
            addresses.addAddress("TOKEN", address(token), true);
        }
    }

    function _afterDeploy() internal override {
        /// Token transfer
        IERC20(addresses.getAddress("TOKEN")).transfer(addresses.getAddress("TREASURY_WALLET_MULTISIG"), MAX_SUPPLY);
    }

    function _validate() internal override {
        /// Check Treasury balance
        assertEq(
            IERC20(addresses.getAddress("TOKEN")).balanceOf(addresses.getAddress("TREASURY_WALLET_MULTISIG")),
            10_000_000_000e18 // hardcoded to verfiy all code is working
        );
    }
}
