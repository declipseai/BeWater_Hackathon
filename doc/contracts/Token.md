# Token.md

## Introduction
The `Token` contract is a custom implementation of an ERC20 token with added functionalities from OpenZeppelin's ERC20 extensions. This document provides an overview of the contract, its features, and its usage.

## Overview
The `Token` contract is designed to create a fixed supply of tokens with advanced features such as permits, votes, and snapshots. The maximum supply of the token is set to 10 billion with 18 decimals. The contract integrates several OpenZeppelin libraries to enhance its functionality.

## Key Features

### ERC20 Standard
The base functionality for the `Token` contract comes from the ERC20 standard, which provides the basic methods and events for a fungible token.

### ERC20 Permit
The `ERC20Permit` extension allows for approvals to be made via signatures, enabling gasless transactions and improving user experience.

### ERC20 Votes
The `ERC20Votes` extension provides governance capabilities, allowing token holders to delegate their voting power and participate in on-chain governance.

## Constants

### `MAX_SUPPLY`
- **Description**: The maximum supply of tokens that can be minted.
- **Value**: 10 billion tokens (10^10) with 18 decimals.
- **Usage**: The `MAX_SUPPLY` constant is used to set the total supply of tokens during the contract deployment.

```solidity
uint256 constant MAX_SUPPLY = 10_000_000_000e18;
```

## Constructor

### `constructor`
- **Parameters**:
  - `name`: The name of the token.
  - `symbol`: The symbol of the token.
- **Description**: The constructor initializes the ERC20 token with the given name and symbol, sets up the permit functionality, and mints the total supply to the deployer's address.

```solidity
constructor(string memory name, string memory symbol) ERC20(name, symbol) ERC20Permit(name) {
    _mint(msg.sender, MAX_SUPPLY);
}
```

## Integration with OpenZeppelin
The `Token` contract utilizes several OpenZeppelin libraries to provide enhanced functionalities:

- **ERC20**: Basic ERC20 functionality.
- **ERC20Permit**: Allows approvals via signatures.
- **ERC20Votes**: Provides governance capabilities.
- **ERC20Snapshot**: (If required) can be added for snapshot functionalities.

These extensions make the `Token` contract versatile and suitable for various use cases, including decentralized governance and efficient token transfers.

## Conclusion
The `Token` contract is a robust implementation of an ERC20 token with additional features for governance and gasless approvals. By leveraging OpenZeppelin's libraries, it ensures security and efficiency, making it a suitable choice for modern decentralized applications.
