# Eclipse AI Protocol

## Introduction

The Eclipse AI Protocol is designed to create a decentralized platform for AI model execution and data labeling. By leveraging blockchain technology and decentralized file storage systems, it ensures security, transparency, and efficiency in handling AI-related tasks.

### Overview
The Eclipse AI Protocol comprises several smart contracts and utility scripts that work together to facilitate the decentralized management of AI models and data labeling services. The primary components include core contracts for managing AI models, roles, and constants, as well as utility scripts for interacting with the blockchain and IPFS. The protocol also includes specific nodes (MasterNode and SubNode) that handle AI tasks and process results.

![](protocol.png)

## Contracts
The primary components are as follows:

### Core
- [AIModelPlatform](contracts/AIModelPlatform.md): Manages AI model registration, request handling, and interaction between Master Nodes and Sub Nodes.
- [Constants](contracts/Constants.md): Defines various constants used across the contracts.
- [Roles](contracts/Roles.md): Manages role-based access control for the different participants in the platform.

### Token
- [Token](contracts/Token.md): Implements the ERC20 token used for transactions and rewards within the platform.

## Scripts
The primary components are as follows:

### Utils
- [web3Manager](program/web3Manager.md): Provides functions to interact with the Ethereum blockchain, including transaction execution and contract interactions.
- [ipfsManager](program/ipfsManager.md): Provides functions to interact with IPFS, including file uploads, downloads, and content management.

### Nodes
- [MasterNode](program/masterNodeLoop.md): Listens for events related to AI task requests and coordinates Sub Nodes to process these tasks, ensuring efficient and accurate AI model execution.
- [SubNode](program/subNodeLoop.md): Listens for task assignments from Master Nodes, performs AI computations, and submits intermediate results.

### Foundry
- [Deploy](contracts/Deploy.md): Contains scripts for deploying the smart contracts to the Ethereum blockchain.

## Known Issues
- TBD
