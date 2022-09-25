// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {RentalListing} from "./ISRSNFTMarketplace.sol";

struct RentalBalance {
        uint256 ownerBalance; 
        uint256 renterBalance; 
}

interface IStreamingRental {

    function getErc20() view external returns (address _erc20);

    function getBalances() view external returns (RentalBalance memory _balance);

    function getBalance() view external returns (uint256 _balance);

    function getNFT() view external returns (address _nftContract, uint256 _nftId);

    function getListing() view external returns (RentalListing memory _listing);

    function getStartDate() view external returns (uint256 _startDate);

    function getExpiry() view external returns (uint256 _expiryDate); 

    function cancel() external returns( RentalBalance memory _balance);

}