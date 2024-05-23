// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

library Roles {

    bytes32 internal constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 internal constant MASTER_NODE_ROLE = keccak256("MASTER_NODE_ROLE");
    bytes32 internal constant SUB_NODE_ROLE = keccak256("SUB_NODE_ROLE");

}
