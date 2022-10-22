// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/561d0eead30d3977847f2c2b4ae54eac31c218df/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/5e8e8bb9f0c6c5e1a8d3a38bcedd7861906f692b/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import "https://github.com/Block-Star-Logic/open-roles/blob/b05dc8c6990fd6ba4f0b189e359ef762118d6cbe/blockchain_ethereum/solidity/v2/contracts/core/OpenRolesSecureCore.sol";

import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

import "https://github.com/Block-Star-Logic/open-version/blob/e161e8a2133fbeae14c45f1c3985c0a60f9a0e54/blockchain_ethereum/solidity/V1/interfaces/IOpenVersion.sol";

import "https://github.com/Block-Star-Logic/open-libraries/blob/703b21257790c56a61cd0f3d9de3187a9012e2b3/blockchain_ethereum/solidity/V1/libraries/LOpenUtilities.sol";

import "https://github.com/Block-Star-Logic/open-roles/blockchain_ethereum/solidity/v2/contracts/interfaces/IOpenRolesManaged.sol"; 

import "../interfaces/ISkinnable.sol";
import "../interfaces/ISRSNFTMarketplace.sol";
import "../interfaces/IStreamingRental.sol";
import "../interfaces/IStreamingRentalFactory.sol";


contract SRSNFTMarketPlace is ISRSNFTMarketplace, OpenRolesSecureCore, IOpenVersion, IOpenRolesManaged {

    using LOpenUtilities for uint256;

    address constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    string constant name     = "RESERVED_SRS_NFT_MARKET_PLACE";
    uint256 constant version = 6; 

    string constant registryCA               = "RESERVED_OPEN_REGISTER_CORE";  
    string constant roleManagerCA            = "RESERVED_OPEN_ROLES_CORE";
   

    string constant streamingRentalFactoryCA = "RESERVED_STREAMING_RENTAL_FACTORY_CORE";
    
    string constant openAdminRole            = "OPEN_ADMIN_ROLE";
    string constant marketPlaceAdminRole     = "MARKET_PLACE_ADMIN_ROLE";
    string constant barredListingUserRole    = "BARRED_LISTING_USER_ROLE";
    string constant barredRentingUserRole    = "BARRED_RENTING_USER_ROLE";

    string [] roles     = [openAdminRole,marketPlaceAdminRole,barredListingUserRole,barredRentingUserRole];

    uint256 [] listingIds; 
    mapping(uint256=>bool) knownListing; 
    mapping(uint256=>RentalListing) listingsById; 
    mapping(address=>uint256[]) listingsIdsByAddress; 

    address [] rentals; 
    mapping(address=>address[]) rentalsByAddress; 

    string [] roleNames; 
    mapping(string=>bool) hasDefaultFunctionsByRole;
    mapping(string=>string[]) defaultFunctionsByRole;

    IOpenRegister registry;      

    IStreamingRentalFactory factory; 

    constructor(address _registry, string memory _dappName) OpenRolesSecureCore(_dappName) {
        registry    = IOpenRegister(_registry);        
        setRoleManager(registry.getAddress(roleManagerCA));
        factory     = IStreamingRentalFactory(registry.getAddress(streamingRentalFactoryCA));
        self        = address(this);

        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));   
        addConfigurationItem(address(factory));

        initDefaultFunctionsForRoles();
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getDefaultRoles() override view external returns (string [] memory _roles){    
        return roleNames; 
    }

    function hasDefaultFunctions(string memory _role) override view external returns(bool _hasFunctions){
        return hasDefaultFunctionsByRole[_role];
    }

    function getDefaultFunctions(string memory _role) override view external returns (string [] memory _functions){
        return defaultFunctionsByRole[_role];
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
    
    function getListingsForUser(address _user) view external returns (RentalListing [] memory _listings){
        require(isSecure(marketPlaceAdminRole, "getListingsForUser"), " market place admin only ");
        return getRentalListings(listingsIdsByAddress[_user]);
    }

    function getRentals() view external returns (address [] memory _rentalContracts){
        require(isSecure(marketPlaceAdminRole, "getRentals") || isSecure(openAdminRole, "getRentals"), " admin only ");
        return rentals; 
    }
    
    function getUserRentals() view external returns (address [] memory _rentalContracts) {
        return rentalsByAddress[msg.sender];
    }

    function createRentalAgreement(uint256 _listingId, address _skinnableNFT, uint256 _localNFTId) external returns (address _rentalContract){
        require(isSecureBarring(barredRentingUserRole, "rent"), "user barred");
        require(knownListing[_listingId], "unknown listing");
        RentalListing memory listing_ = listingsById[_listingId];
        withdrawListingInternal(_listingId);
        // check the approval is still in place 
        IERC721 erc721 = IERC721(listing_.nftContract);
        
        // case for dud listings, withdraw the listing refund the renter
        if(!(erc721.getApproved(listing_.nftId) == self)) { 
            refund(listing_); // return the renter's funds 
            return address(0); 
        }

        // create the rental contract
        _rentalContract = getRentalInternal(listing_, _skinnableNFT,  _localNFTId);      
        
        // secure the NFT 
        erc721.transferFrom(listing_.owner, self, listing_.nftId);
        // approve transfer to the rental 
        erc721.approve(_rentalContract, listing_.nftId);
        
        ISkinnable skinnable_ = ISkinnable(_skinnableNFT);
        require(IERC721(_skinnableNFT).ownerOf(_localNFTId) == msg.sender, " ensure the sender owns the NFT to be Skinned "); 
        // delegate approval to apply the Skin 
        skinnable_.delegateApproval(_localNFTId, self, _rentalContract); 
        
        rentals.push(_rentalContract);
        rentalsByAddress[msg.sender].push(_rentalContract);
        rentalsByAddress[listing_.owner].push(_rentalContract);

        return _rentalContract;
    }

    function postListing(address _nftContractAddress, 
                        uint256 _nftId, 
                        uint256 _rentalFee, 
                        uint256 _period, address _paymentErc20) external returns (bool _posted){
                        // only the nft owner can post a listing 
                        require(isSecureBarring(barredListingUserRole, "postListing"), "user barred");
                        requireOwnership(_nftContractAddress, _nftId);
                        // make sure the poster has approved the market place
                        require(IERC721(_nftContractAddress).getApproved(_nftId) == self, " market place not approved "); 
                        RentalListing memory listing_ = RentalListing({
                                                                        id              : block.timestamp, 
                                                                        owner           : msg.sender,  
                                                                        nftContract     : _nftContractAddress, 
                                                                        nftId           : _nftId, 
                                                                        period          : _period, 
                                                                        paymentErc20    : _paymentErc20,
                                                                        rentalFee       : _rentalFee
                                                                    });
                        knownListing[listing_.id] = true; 
                        listingIds.push(listing_.id);
                        listingsById[listing_.id] = listing_;
                        listingsIdsByAddress[msg.sender].push(listing_.id);
                        return true;
    }
    
    function withdrawListing(uint256 _listingId) external returns (bool _withdrawn){
        require(knownListing[_listingId], " unknown listing ");
        RentalListing memory listing_ = listingsById[_listingId];
        requireOwnership(listing_.nftContract, listing_.nftId);
        withdrawListingInternal(_listingId);
        return true; 
    }

    function revertNFT(uint256 _listingId) external returns (bool _reverted) {
        require(isSecure(marketPlaceAdminRole, "revertNFT")," marketplace admin only "); 
        RentalListing memory listing_ = listingsById[_listingId]; 
        IERC721 erc721 = IERC721(listing_.nftContract);
        erc721.transferFrom(self, listing_.owner, listing_.nftId);
        return true; 
    }

    function notifyChangeOfAddress() external returns (bool _recieved){
        require(isSecure(openAdminRole, "notifyChangeOfAddress")," admin only "); 
        registry                = IOpenRegister(registry.getAddress(registryCA)); // make sure this is NOT a zero address          
        setRoleManager(registry.getAddress(roleManagerCA));
        factory                 = IStreamingRentalFactory(registry.getAddress(streamingRentalFactoryCA));               

        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));   
        addConfigurationItem(address(factory));
        return true; 
    }
    //============================================ INTERNAL ==================================================

    function refund(RentalListing memory listing_) internal returns (bool _refunded) {
        address erc20Address = listing_.paymentErc20;
        if(erc20Address == NATIVE) {
            payable(listing_.owner).transfer(msg.value);            
        }
        // ignore anything else
        return true; 
    }

    function withdrawListingInternal(uint256 _listingId) internal returns (bool _withdrawn) {
        listingIds = _listingId.remove(listingIds);
        knownListing[_listingId ] = false;
        return true; 
    }

    function requireOwnership(address _erc721, uint256 _nft) view internal {
        IERC721 ierc721_ = IERC721(_erc721);
        require(ierc721_.ownerOf(_nft) == msg.sender || isSecure(marketPlaceAdminRole, "requireOwnership" ), " nft owner / market place admin only ");
        
    }

    function getRentalListings(uint256 [] memory _listingIds)  view internal returns (RentalListing [] memory _listings){
        _listings = new RentalListing[](_listingIds.length);
        for(uint256 x = 0; x < _listings.length; x++){
            _listings[x] = listingsById[_listingIds[x]];
        }
        return _listings; 
    }

    function getRentalInternal( RentalListing memory listing_, address _skinnableNFT, uint256 _localNFTId) internal returns (address _rental) {
        RentalSeed memory seed_ = RentalSeed({
                                                register    : address(registry),
                                                marketPlace : self,                                                 
                                                listing     : listing_,
                                                skinnableNFT: _skinnableNFT,
                                                localNFTId  : _localNFTId,
                                                renter      : msg.sender
                                            });                                                    
        return factory.createRentalContract(seed_); 
    }

    function initDefaultFunctionsForRoles() internal returns (bool _initiated) {
        
        hasDefaultFunctionsByRole[openAdminRole] = true; 
        defaultFunctionsByRole[openAdminRole].push("notifyChangeOfAddress");
        defaultFunctionsByRole[openAdminRole].push("getRentals");
        defaultFunctionsByRole[openAdminRole].push("revertNFT");

        hasDefaultFunctionsByRole[marketPlaceAdminRole] = true; 
        defaultFunctionsByRole[marketPlaceAdminRole].push("getListingsForUser");
        defaultFunctionsByRole[marketPlaceAdminRole].push("getRentals");

        hasDefaultFunctionsByRole[barredRentingUserRole] = true; 
        defaultFunctionsByRole[barredRentingUserRole].push("rent");
        
        hasDefaultFunctionsByRole[barredListingUserRole] = true; 
        defaultFunctionsByRole[barredListingUserRole].push("postListing");
        
        return true; 
    }
}