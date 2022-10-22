// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

interface ISuperTokenRegistry { 

    function isSupported(address _erc20) view external returns (bool _suppored);

    function getSuperToken(address _erc20) view external returns (address _superToken);

    function addSuperToken(address _superToken) external returns (bool _added);

    function removeSuperToken(address _superToken) external returns (bool _removed);
}