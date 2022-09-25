// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ISkinnable {

    function lock(address _nftContractAddress, uint256 _nftId, uint256 _lockToNftId) external returns (bool _locked);

    function isLocked(address _nftContractAddress, uint256 _nftId) view external returns (bool _locked);

    function isLocked(uint256 _nftId) view external returns (bool _locked);

    function unlock(address _nftContractAddress, uint256 _nftId) external returns (bool _locked);

    function getFunctionalTokenURI(uint256 _lockToNftId) view external returns (string memory _uri);

}