# Roles.md

## Introduction
The `Roles` library in the `AIModelPlatform` contract is designed to manage role-based access control. By defining specific roles, it ensures that only authorized participants can perform certain actions within the system. This document outlines the roles and their purposes within the platform.

## Overview
The `Roles` library defines three primary roles: `ADMIN_ROLE`, `MASTER_NODE_ROLE`, and `SUB_NODE_ROLE`. Each role is represented by a unique identifier and has distinct permissions within the `AIModelPlatform` contract.

## Roles

### `ADMIN_ROLE`
- **Identifier**: `keccak256("ADMIN_ROLE")`
- **Description**: 
  - The `ADMIN_ROLE` is the highest level of access within the `AIModelPlatform`. It is typically assigned to the contract deployer or other trusted entities responsible for managing the platform.
  - **Permissions**: 
    - Registering new AI models.
    - Assigning roles to Master Nodes and Sub Nodes.
    - Managing and overseeing the overall functionality of the contract.
  - **Responsibilities**:
    - Ensuring the integrity and security of the platform.
    - Delegating responsibilities by assigning appropriate roles to other participants.

### `MASTER_NODE_ROLE`
- **Identifier**: `keccak256("MASTER_NODE_ROLE")`
- **Description**: 
  - The `MASTER_NODE_ROLE` is assigned to entities responsible for overseeing the execution of AI model requests and managing the Sub Nodes.
  - **Permissions**:
    - Accepting Sub Nodes for handling requests.
    - Submitting final answers for AI model requests.
  - **Responsibilities**:
    - Coordinating with Sub Nodes to ensure efficient and accurate processing of requests.
    - Providing final validation and aggregation of answers from Sub Nodes.

### `SUB_NODE_ROLE`
- **Identifier**: `keccak256("SUB_NODE_ROLE")`
- **Description**: 
  - The `SUB_NODE_ROLE` is assigned to entities that execute specific tasks related to AI model requests. These nodes perform intermediate computations and submit answers for further validation.
  - **Permissions**:
    - Expressing interest in handling requests.
    - Submitting intermediate answers for requests.
  - **Responsibilities**:
    - Executing assigned tasks accurately and efficiently.
    - Collaborating with Master Nodes to ensure the quality of the final output.

## Usage

### Defining Roles
Roles are defined using the `keccak256` hashing function to ensure unique identifiers for each role. This prevents collisions and maintains the integrity of the role-based access control system.

### Assigning Roles
Roles are assigned using the `AccessControl` functionality provided by OpenZeppelin. The `ADMIN_ROLE` can assign `MASTER_NODE_ROLE` and `SUB_NODE_ROLE` to appropriate addresses, ensuring that only authorized participants can perform specific actions.

### Role Management
The `Roles` library is integrated with the `AccessControl` contract from OpenZeppelin, which provides built-in functions to manage roles, including granting, revoking, and checking roles for addresses.

## Implementation

```solidity
// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

library Roles {
    bytes32 internal constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 internal constant MASTER_NODE_ROLE = keccak256("MASTER_NODE_ROLE");
    bytes32 internal constant SUB_NODE_ROLE = keccak256("SUB_NODE_ROLE");
}
```

This implementation ensures that the roles within the `AIModelPlatform` contract are clearly defined and managed, providing a secure and efficient mechanism for role-based access control.
