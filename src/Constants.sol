// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.18;

library Constants {
    uint256 public constant ONE_YEAR = 365.25 days;

    /// @notice Wei per ETH, i.e. 10**18
    uint256 public constant ETH_GRANULARITY = 1e18;

    /// @notice number of decimals in ETH, 18
    uint256 public constant ETH_DECIMALS = 18;

    /// @notice max-uint
    uint256 public constant MAX_UINT = type(uint256).max;
}
