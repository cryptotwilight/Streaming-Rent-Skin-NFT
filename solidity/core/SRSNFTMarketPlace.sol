// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/561d0eead30d3977847f2c2b4ae54eac31c218df/contracts/token/ERC721/IERC721.sol";

import {ISuperfluid, ISuperToken, ISuperApp} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import "../interfaces/ISRSNFTMarketplace.sol";
import "../interfaces/IStreamingRental.sol";
import "./StreamingRental.sol";

contract SRSNFTMarketPlace is ISRSNFTMarketplace {

    address NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address self; 

    address administrator; 

    uint256 [] listingIds; 
    mapping(uint256=>RentalListing) listingsById; 
    mapping(address=>uint256[]) listingsIdsByAddress; 

    address [] rentals; 
    mapping(address=>address[]) rentalsByAddress; 

    ISuperfluid host; 
    
    constructor(address _administrator) {
        administrator = _administrator; 
        self = address(this);
    }

    function getListing(uint256 _listingId) view external returns (RentalListing memory _listing) {
        return listingsById[_listingId];
    }

    function getListings() view external returns (RentalListing [] memory _listings){
        return getRentalListings(listingIds); 
    }

    function getUserListings() view external returns (RentalListing [] memory _listings) {
        return getRentalListings(listingsIdsByAddress[msg.sender]); 
    }
    
    function getRentals() view external returns (address [] memory _rentalContracts){
        return rentals; 
    }
    
    function getUserRentals() view external returns (address [] memory _rentalContracts) {
        return rentalsByAddress[msg.sender];
    }

    function rent(uint256 _listingId, address _skinnableNFT, uint256 _localTokenId) payable external returns (address _rentalContract){
        RentalListing memory listing_ = listingsById[_listingId];
        listingIds = remove(_listingId, listingIds);
        uint256 amountPaid_ = listing_.rentalFee; 
        if(listing_.paymentErc20 == NATIVE) {
            amountPaid_ = msg.value; 
        }
        StreamingRental rental_ = new StreamingRental(self, host, listing_, amountPaid_, _skinnableNFT, _localTokenId, msg.sender);
        payForRental(listing_.paymentErc20, listing_.rentalFee, address(rental_));

        rentals.push(address(rental_));
        rentalsByAddress[msg.sender].push(address(rental_));
        rentalsByAddress[listing_.owner].push(address(rental_));
        return address(rental_);
    }

    function postListing(address _nftContractAddress, 
                        uint256 _nftId, 
                        uint256 _rentalFee, 
                        uint256 _period, address _paymentErc20) external returns (bool _posted){
        // only the nft owner can post a listing 
        requireOwnership(_nftContractAddress, _nftId);
        RentalListing memory listing_ = RentalListing({
                                                        id              : block.timestamp, 
                                                        owner           : msg.sender,  
                                                        nftContract     : _nftContractAddress, 
                                                        nftId           : _nftId, 
                                                        period          : _period, 
                                                        paymentErc20    : _paymentErc20,
                                                        rentalFee       : _rentalFee
                                                    });
        listingIds.push(listing_.id);
        listingsById[listing_.id] = listing_;
        listingsIdsByAddress[msg.sender].push(listing_.id);
        return true;
    }
    
    function withdrawListing(uint256 _listingId) external returns (bool _withdrawn){
        RentalListing memory listing_ = listingsById[_listingId];
        requireOwnership(listing_.nftContract, listing_.nftId);

        listingIds = remove(_listingId, listingIds);

        return true; 
    }

    //============================================ INTERNAL ==================================================

    function requireOwnership(address _erc721, uint256 _nft) view internal {
        IERC721 ierc721_ = IERC721(_erc721);
        require(ierc721_.ownerOf(_nft) == msg.sender, " nft owner only ");
    }

    function getRentalListings(uint256 [] memory _listingIds)  view internal returns (RentalListing [] memory _listings){
        _listings = new RentalListing[](_listingIds.length);
        for(uint256 x = 0; x < _listings.length; x++){
            _listings[x] = listingsById[_listingIds[x]];
        }
        return _listings; 
    }

    function remove(uint256 a, uint256[] memory b) pure internal returns (uint256 [] memory){
        uint256 [] memory c = new uint256[](b.length-1);
        uint256 y = 0; 
        for(uint256 x = 0; x < b.length; x++) {
            uint256 d = b[x];
            if( a != d){    
                if(y == c.length){ // i.e. element not found
                    return b; 
                } 
                c[y] = d; 
                y++;
            }
        }
        return c; 
    }

    function payForRental(address _erc20, uint256 _fee, address _rental) internal {
                // hold the rental fee for streaming 
        if(_erc20 == NATIVE) {
            require(msg.value >= _fee, " insufficient fee paid ");
            StreamingRental(_rental).initialize{value : _fee}();
        }
        else {
        
            IERC20 erc20_ = IERC20(_erc20);
            require(erc20_.allowance(msg.sender, self) >= _fee);
            erc20_.transferFrom(msg.sender, self, _fee);

            erc20_.approve(_rental, _fee);
            StreamingRental(_rental).initialize(); 
        }
    } 
}