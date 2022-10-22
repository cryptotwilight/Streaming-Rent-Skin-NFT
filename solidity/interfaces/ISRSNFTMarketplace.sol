// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

struct RentalListing {
    uint256 id; 
    address owner; 
    address nftContract; 
    uint256 nftId; 
    uint256 period; 
    address paymentErc20;
    uint256 rentalFee;  
}

interface ISRSNFTMarketplace {

    function getListings() view external returns (RentalListing [] memory _listings);

    function getRentals() view external returns (address [] memory _rentalContracts);

    function createRentalAgreement(uint256 _listingId, address _skinnableNFT, uint256 _localTokenId) external returns (address _rentalContract);

    function postListing(address _nftContractAddress, 
                        uint256 _nftId, 
                        uint256 _rentalFee, 
                        uint256 _period, address _paymentErc20) external returns (bool _posted);
    
    function withdrawListing(uint256 _listingId) external returns (bool _withdrawn);
}