//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

import {console} from "@forge-std/console.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

import {Addresses} from "@proposals/Addresses.sol";
import {Proposal} from "@proposals/proposalTypes/Proposal.sol";
import {TimelockProposal} from "@proposals/proposalTypes/TimelockProposal.sol";

contract aipTest is TimelockProposal {
    string private constant ADDRESSES_PATH = "proposals/Addresses.json";

    Core private _core;
    address[] public whitelistAddresses;

    constructor() Proposal("ADMIN_TIMELOCK_CONTROLLER") {}

    // Returns the name of the proposal.
    function name() public pure override returns (string memory) {
        return "AIPTest";
    }

    // Provides a brief description of the proposal.
    function description() public pure override returns (string memory) {
        return "The Last Eclipse AI Proposal (For Testing only)";
    }

    function _beforeDeploy() internal override {
        _core = Core(addresses.getAddress("CORE"));
    }

    function _deploy() internal override {
        {

        }

    }

    function _validate() internal override {
        
    }

    function _build() internal override {
    }
}
