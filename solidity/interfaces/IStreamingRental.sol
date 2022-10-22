// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import {ISuperfluid} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {RentalListing} from "./ISRSNFTMarketplace.sol";

struct RentalSeed { 
    address register; 
    address marketPlace;        
    RentalListing listing;
    address skinnableNFT; 
    uint256 localNFTId; 
    address renter;
}

struct RentalBalance {
        uint256 ownerBalance; 
        uint256 renterBalance; 
}

interface IStreamingRental {

    function getRentalStatus() view external returns (string memory _status);

    function getSeed() view external returns (RentalSeed memory _seed);

    function getPaymentErc20() view external returns (address _erc20);
    
    function getSuperToken() view external returns (address _superToken);

    function getBalances() view external returns (RentalBalance memory _balance);

    function getBalance() view external returns (uint256 _balance);

    function getStartDate() view external returns (uint256 _startDate);

    function getEndDate() view external returns (uint256 _expiryDate); 
            
    function initialize() payable external returns (bool _initialized);

    function cancel() external returns( RentalBalance memory _balance);

    function close() external returns (bool _rentalClosed);

}