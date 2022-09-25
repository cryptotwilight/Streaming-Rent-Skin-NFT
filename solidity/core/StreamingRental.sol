// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/561d0eead30d3977847f2c2b4ae54eac31c218df/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

import {ISuperfluid, ISuperToken, ISuperApp} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import {ISuperfluidToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluidToken.sol";
import {IConstantFlowAgreementV1} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import {CFAv1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/CFAv1Library.sol";

import "../interfaces/ISkinnable.sol";
import "../interfaces/IStreamingRental.sol";


contract StreamingRental is IStreamingRental {

    using CFAv1Library for CFAv1Library.InitData;

    address NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        //initialize cfaV1 variable
    CFAv1Library.InitData public cfaV1;

    ISuperToken superfluidToken; 
    ISuperfluid host; 

    RentalListing listing; 
    uint256 startDate; 
    uint256 endDate; 
    uint256 amountPaid; 
    address skinnableNFT; 
    address renter; 
    address self; 
    address marketPlace; 
    uint256 localTokenId; 

    constructor( address _marketPlace, ISuperfluid _host, RentalListing memory _listing, uint256 _amountPaid, address _skinnableNFT, uint256 _localTokenId, address _renter){
        listing         = _listing; 
        amountPaid      = _amountPaid; 
        renter          = _renter; 
        skinnableNFT    = _skinnableNFT;
        self            = address(this);
        host            = _host; 
        marketPlace     = _marketPlace; 
        localTokenId    = _localTokenId; 
    }

    function initialize() payable external { 
        require(msg.sender == marketPlace, " market place only ");
         // hold the rental fee for streaming 
        if(listing.paymentErc20 == NATIVE) {
            require(msg.value >= listing.rentalFee);
        }
        else {
        
            IERC20 erc20_ = IERC20(listing.paymentErc20);
            require(erc20_.allowance(msg.sender, self) >= listing.rentalFee);
            require(amountPaid >= listing.rentalFee);
            erc20_.transferFrom(msg.sender, self, amountPaid);
        }
        // transfer nft to rental contract
        IERC721 n721 = IERC721(listing.nftContract);
        n721.safeTransferFrom(listing.owner, self, listing.nftId);

        // apply nft to local token
        ISkinnable skinnable_ = ISkinnable(skinnableNFT);
        skinnable_.lock(listing.nftContract, listing.nftId, localTokenId);

        //initialize InitData struct, and set equal to cfaV1
        cfaV1 = CFAv1Library.InitData(
                                        host,
                                        //here, we are deriving the address of the CFA using the host contract
                                        IConstantFlowAgreementV1(
                                            address(host.getAgreementClass(
                                                    keccak256("org.superfluid-finance.agreements.ConstantFlowAgreement.v1")
                                                ))
                                            )
                                        );

        int96 rate_ = int96(int(listing.rentalFee / listing.period));

        superfluidToken = ISuperToken(getSuperfluidToken(listing.paymentErc20));

        cfaV1.createFlow(listing.owner, superfluidToken , rate_);
    }

    function getErc20() view external returns (address _erc20){
        return listing.paymentErc20; 
    }

    function getBalances() view external returns (RentalBalance memory _balance){
        _balance = RentalBalance({
                                    ownerBalance : superfluidToken.balanceOf(listing.owner),
                                    renterBalance : superfluidToken.balanceOf(renter)
                                });
        return _balance; 
    }

    function getBalance() view external returns (uint256 _balance){
       return superfluidToken.balanceOf(msg.sender);
    }

    function getNFT() view external returns (address _nftContract, uint256 _nftId){
        return (listing.nftContract, listing.nftId);
    }

    function getListing() view external returns (RentalListing memory _listing){
        return listing; 
    }

    function getStartDate() view external returns (uint256 _startDate){
        return startDate; 
    }

    function getExpiry() view external returns (uint256 _expiryDate){
        return endDate; 
    }

    function cancel() external returns( RentalBalance memory _balance){
        require(msg.sender == listing.owner || msg.sender == renter, " invalid party ");
        
        // terminate value transfer
        cfaV1.deleteFlow(self, listing.owner, ISuperfluidToken(getSuperfluidToken(listing.paymentErc20)));

        // return nft to  owner
        IERC721 n721 = IERC721(listing.nftContract);
        n721.safeTransferFrom(self, listing.owner, listing.nftId);
        
        // unlock the skin 
        ISkinnable skinnable_ = ISkinnable(skinnableNFT);
        skinnable_.unlock(listing.nftContract, listing.nftId);

        return this.getBalances();
    }

    //============================================ INTERNAL =============================================


    function getSuperfluidToken(address _erc20) view internal returns (address _superfluidToken) {


    }

    
}