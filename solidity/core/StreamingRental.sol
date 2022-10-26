// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

// Openzeppelin 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/561d0eead30d3977847f2c2b4ae54eac31c218df/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/5e8e8bb9f0c6c5e1a8d3a38bcedd7861906f692b/contracts/token/ERC20/extensions/IERC20Metadata.sol";

// Superfluid 
import {ISuperToken} from "https://github.com/superfluid-finance/protocol-monorepo/blob/b9806acd1055d2dec1cd1051ca87d22ad147958e/packages/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";
import {ISuperApp} from "https://github.com/superfluid-finance/protocol-monorepo/blob/b9806acd1055d2dec1cd1051ca87d22ad147958e/packages/ethereum-contracts/contracts/interfaces/superfluid/ISuperApp.sol";

import {CFAv1Library, IConstantFlowAgreementV1} from "https://github.com/superfluid-finance/protocol-monorepo/blob/b9806acd1055d2dec1cd1051ca87d22ad147958e/packages/ethereum-contracts/contracts/apps/CFAv1Library.sol";
import {ISuperfluid } from "https://github.com/superfluid-finance/protocol-monorepo/blob/b9806acd1055d2dec1cd1051ca87d22ad147958e/packages/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

// Open Block EI
import "https://github.com/Block-Star-Logic/open-version/blob/e161e8a2133fbeae14c45f1c3985c0a60f9a0e54/blockchain_ethereum/solidity/V1/interfaces/IOpenVersion.sol";
import "https://github.com/Block-Star-Logic/open-libraries/blob/703b21257790c56a61cd0f3d9de3187a9012e2b3/blockchain_ethereum/solidity/V1/libraries/LOpenUtilities.sol";
import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

// SRS NFT 
import "../interfaces/ISkinnable.sol";
import {RentalListing} from "../interfaces/ISRSNFTMarketplace.sol";
import {IStreamingRental, RentalBalance, RentalSeed} from "../interfaces/IStreamingRental.sol";  
import "../interfaces/ISuperTokenRegistry.sol";

contract StreamingRental is IStreamingRental, IOpenVersion {

    using CFAv1Library for CFAv1Library.InitData;

    using LOpenUtilities for string; 


    string constant name        = "STREAMING_RENTAL";
    uint256 constant version    = 15; 

    address constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    bool native; 

    string constant superFluidHostEA                 = "EXTERNAL_SUPERFLUID_HOST";    
    string constant superTokenRegistryCA             = "RESERVED_SUPER_TOKEN_REGISTRY";

    IOpenRegister registry; 
    
    //initialize cfaV1 variable
    CFAv1Library.InitData cfaV1;

    ISuperToken superfluidToken; 
    ISuperfluid host; 
    IConstantFlowAgreementV1 iCFAV1; 
    RentalSeed seed; 
    string status = "NOT_STARTED";    

    uint256 createDate; 
    uint256 startDate; 
    uint256 endDate;     
    int96 flowRate; 

    address self; 
    /*
    constructor( RentalSeed memory _seed) {

        // get superfluid config from the register 
        seed = _seed; 
        registry = IOpenRegister(seed.register);
        superfluidToken = ISuperToken(ISuperTokenRegistry(registry.getAddress(superTokenRegistryCA)).getSuperToken(_seed.listing.paymentErc20));
        host = ISuperfluid(registry.getAddress(superFluidHostEA));
        iCFAV1 = IConstantFlowAgreementV1(address(host.getAgreementClass(keccak256("org.superfluid-finance.agreements.ConstantFlowAgreement.v1"))));
        cfaV1 = CFAv1Library.InitData(
                                        host,
                                        //here, we are deriving the address of the CFA using the host contract
                                        iCFAV1
                                        );
        if(_seed.listing.paymentErc20 == NATIVE) {
            native = true; 
        }
        flowRate = int96(int(seed.listing.rentalFee / seed.listing.period));

        self = address(this);
        createDate = block.timestamp; 
    }
    */

    constructor(    address _register,address _marketPlace,  uint256 _id,
    address _owner,
    address _nftContract,
    uint256 _nftId,
    uint256 _period, 
    address _paymentErc20,
    uint256 _rentalFee, address _skinnableNFT, uint256 _localNFTId, address _renter){
               registry = IOpenRegister(_register);
        superfluidToken = ISuperToken(ISuperTokenRegistry(registry.getAddress(superTokenRegistryCA)).getSuperToken(_paymentErc20));
        host = ISuperfluid(registry.getAddress(superFluidHostEA));
        iCFAV1 = IConstantFlowAgreementV1(address(host.getAgreementClass(keccak256("org.superfluid-finance.agreements.ConstantFlowAgreement.v1"))));
        cfaV1 = CFAv1Library.InitData(
                                        host,
                                        //here, we are deriving the address of the CFA using the host contract
                                        iCFAV1
                                        );
        if(_paymentErc20 == NATIVE) {
            native = true; 
        }
        flowRate = int96(int(_rentalFee /  _period));

        RentalListing memory listing_ = RentalListing({
                                                       id           : _id,
                                                       owner        : _owner,
                                                       nftContract  : _nftContract,
                                                       nftId        : _nftId,
                                                       period       : _period, 
                                                       paymentErc20 : _paymentErc20,
                                                       rentalFee    : _rentalFee
                                                    });
        seed = RentalSeed({
                            register : _register,
                            marketPlace : _marketPlace,
                            listing : listing_,
                            skinnableNFT : _skinnableNFT,
                            localNFTId : _localNFTId,
                            renter : _renter
                            });


        self = address(this);
        createDate = block.timestamp; 
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getRentalStatus() view external returns (string memory _status){
        if(block.timestamp > endDate 
            && endDate > 0 
            && !status.isEqual("CLOSED") 
            && !status.isEqual("CANCELLED")){
            return "ENDED";
        }
        return status; 
    }

    function getCreateDate() view external returns (uint256 _createDate) {
        return createDate; 
    }

    function getSeed() view external returns (RentalSeed memory _seed) {
        return seed; 
    }

    function getFlowRate() view external returns (int96 _flowRate) {
        return flowRate; 
    }

    function getPaymentErc20() view external returns (address _erc20){
        return seed.listing.paymentErc20; 
    }

    function getBalances() view external returns (RentalBalance memory _balance){
        return getBalancesInternal(); 
    }    

    function getBalance() view external returns (uint256 _balance){
       RentalBalance memory balance_ = getBalancesInternal();
       if(msg.sender == seed.renter) {
           return balance_.renterBalance; 
       }
       if(msg.sender == seed.listing.owner) {
           return balance_.ownerBalance; 
       }
       return superfluidToken.balanceOf(self);
    }

    function getSuperToken() view external returns (address _superToken) {
        return address(superfluidToken);
    }

    function getNFT() view external returns (address _nftContract, uint256 _nftId){
        return (seed.listing.nftContract, seed.listing.nftId);
    }

    function getListing() view external returns (RentalListing memory _listing){
        return seed.listing; 
    }

    function getStartDate() view external returns (uint256 _startDate){
        return startDate; 
    }

    function getEndDate() view external returns (uint256 _expiryDate){
        return endDate; 
    }

    function initialize() payable external returns (bool _initialized) { 
        require(msg.sender == seed.renter, " renter only ");
        // hold the rental fee for streaming 
        transferFundsInbound(); // - works

        // prime the token flows prior to starting the flows
        primeTokenFlows();

        // transfer nft to rental contract
//        transferNFTInbound(); 

        // start value flows 
        // startFlows(); 

        // apply nft to local token
//        applySkin();

        // start the rental after full initialization
        startRental(); 
        status = "STARTED";
        return true; 
    }

    function cancel() external returns( RentalBalance memory _balance){
        require(msg.sender == seed.listing.owner || msg.sender == seed.renter, " invalid party ");       
        require(((block.timestamp < endDate) || endDate == 0), " rental ended ");
        if(status.isEqual("NOT_STARTED")) { // activation period 
            transferNFTInbound();
        }                
        closeRentalInternal(); 
        status = "CANCELLED";
        return getBalancesInternal(); // these should both be zero 
    }
    
    function close() external returns (bool _rentalClosed) {
        require(block.timestamp > endDate, " rental not ended ");
        if(status.isEqual("NOT_STARTED")) { // activation period 
            transferNFTInbound();
        }  
        _rentalClosed = closeRentalInternal();
        status = "CLOSED";
        return _rentalClosed;
    }



    //============================================ INTERNAL =============================================


    function closeRentalInternal() internal returns (bool _closed) {
        // end the rental 
        endRental();

        // stop flows 
        // endFlows();     

        // remove the skin
       // removeSkin();

        // return nft to owner
       // transferNFTOutbound();  

        // dePrime the tokens
        deprimeTokenFlowsInternal();

        // refund the renter 
        refund(); // works
       
        return true; 
    }

    function applySkin() internal returns (bool _applied) {
        ISkinnable skinnable_ = ISkinnable(seed.skinnableNFT);
        skinnable_.applySkin(seed.listing.nftContract, seed.listing.nftId, seed.localNFTId);
        return true; 
    }

    function removeSkin() internal returns (bool _removed) {
        ISkinnable skinnable_ = ISkinnable(seed.skinnableNFT);
        skinnable_.removeSkin(seed.listing.nftContract,  seed.listing.nftId);
        return true; 
    }

    function transferNFTInbound() internal returns (bool _secured) {
        IERC721 n721 = IERC721(seed.listing.nftContract);
        n721.transferFrom(seed.marketPlace, self, seed.listing.nftId);  
        return true; 
    }

    function transferNFTOutbound() internal returns (bool _released) {
        IERC721 erc721 = IERC721(seed.listing.nftContract);
        // transfer back to the owner
        erc721.transferFrom(self, seed.listing.owner, seed.listing.nftId);
        return true; 
    }

    function startRental() internal returns (bool _rentalStarted){
        startDate = block.timestamp; 
        endDate = startDate + seed.listing.period; 
        return true; 
    }

    function endRental() internal returns (bool _rentalEnded) {
        endDate = block.timestamp; 
        return true; 
    }

    function primeTokenFlows() internal  returns (bool _primed) {
        return primeTokenFlowsInternal();         
    }

    function dePrimeTokenTokenFlows() internal returns (bool _deprimed){
        return deprimeTokenFlowsInternal(); 
    }

    function startFlows() external returns (bool _flowsStarted) {                   
        cfaV1.createFlow(seed.listing.owner, superfluidToken , flowRate); 
        return true; 
    }   

    function endFlows() external returns (bool flowsEnded) {
       // terminate value transfer
       cfaV1.deleteFlow(self, seed.listing.owner, superfluidToken);
       
       return true; 
    }

    function transferFundsInbound() internal returns (bool _transferred) {
        if(native) {
            require(msg.value >= seed.listing.rentalFee, "insufficient rental fee transmitted");
        }
        else {        
            IERC20 erc20_ = IERC20(seed.listing.paymentErc20);
            require(erc20_.allowance(msg.sender, self) >= seed.listing.rentalFee, " allowance less than rental fee ");
            erc20_.transferFrom(msg.sender, self, seed.listing.rentalFee);
        }
        return true; 
    }

    function getSuperTokenBalance() view external returns (uint256 _superTokenBalance) {
        return superfluidToken.balanceOf(self);
    }

    function refund() internal returns (bool _refunded) {
        if(status.isEqual("NOT_STARTED")){
            IERC20 erc20_ = IERC20(seed.listing.paymentErc20);
            erc20_.transfer(seed.renter, erc20_.balanceOf(self));
            return true; 
        }        

        RentalBalance memory rentalBalance_ = getBalancesInternal();
        if(rentalBalance_.renterBalance > 0) {
            
            if(native) {
                payable(seed.renter).transfer(rentalBalance_.renterBalance);
            }
            else {
                IERC20 erc20_ = IERC20(seed.listing.paymentErc20);
                erc20_.transfer(seed.renter, rentalBalance_.renterBalance);
            }    
            _refunded = true;         
        }

        if(hasOtherBalance()) {
            if(native) {
                payable(seed.renter).transfer(payable(self).balance);
            }
            else { 
                IERC20 erc20_ = IERC20(seed.listing.paymentErc20);
                erc20_.transfer(seed.renter, erc20_.balanceOf(self));            
            }
            _refunded = true;
        }
        return _refunded; 
    }

    function hasOtherBalance() view internal returns (bool _hasOtherBalance) { 
        if(payable(self).balance > 0 || IERC20(seed.listing.paymentErc20).balanceOf(self) > 0){
            return true; 
        }
        return false; 
    }

    function getBalancesInternal() view internal returns (RentalBalance memory _balance) {
        if(status.isEqual("NOT_STARTED")) {
            IERC20 erc20_ = IERC20(seed.listing.paymentErc20);
            _balance = RentalBalance({
                                    ownerBalance : 0,
                                    renterBalance : erc20_.balanceOf(self)
                                });
            return _balance; 
        }
        _balance = RentalBalance({
                                    ownerBalance : superfluidToken.balanceOf(seed.listing.owner),
                                    renterBalance : superfluidToken.balanceOf(self)
                                });
        return _balance; 
    }

    function primeTokenFlowsInternal() internal returns (bool _primed) {
    
        IERC20 underlyingToken_ = IERC20(seed.listing.paymentErc20);        
        underlyingToken_.approve(address(superfluidToken), seed.listing.rentalFee);        
        superfluidToken.upgrade(seed.listing.rentalFee);        
        return true; 
    }

    function deprimeTokenFlowsInternal() internal returns (bool _primed) {
        RentalBalance memory rentalBalance_ = getBalancesInternal();
        if(rentalBalance_.renterBalance > 0){
            superfluidToken.downgrade(rentalBalance_.renterBalance);        
            return true; 
        }
        return false; 
    }

}