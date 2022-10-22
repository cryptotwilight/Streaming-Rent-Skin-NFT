// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/Block-Star-Logic/open-libraries/blob/703b21257790c56a61cd0f3d9de3187a9012e2b3/blockchain_ethereum/solidity/V1/libraries/LOpenUtilities.sol";

import "https://github.com/Block-Star-Logic/open-roles/blob/b05dc8c6990fd6ba4f0b189e359ef762118d6cbe/blockchain_ethereum/solidity/v2/contracts/core/OpenRolesSecureCore.sol";
import "https://github.com/Block-Star-Logic/open-roles/blockchain_ethereum/solidity/v2/contracts/interfaces/IOpenRolesManaged.sol";

import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

import "../interfaces/IStreamingRentalFactory.sol";
import "./StreamingRental.sol";

contract StreamingRentalFactory is  OpenRolesSecureCore, IStreamingRentalFactory, IOpenVersion, IOpenRolesManaged  { 

    IOpenRegister registry;     

    string constant name              = "RESERVED_STREAMING_RENTAL_FACTORY_CORE"; 
    uint256 constant version          = 1; 

    string constant registryCA        = "RESERVED_OPEN_REGISTER_CORE";  
    string constant roleManagerCA     = "RESERVED_OPEN_ROLES_CORE";
    
    string constant openAdminRole     = "OPEN_ADMIN_ROLE";
    string constant srsNFTCoreRole    = "SRS_NFT_CORE_ROLE";

    string [] roleNames = [openAdminRole, srsNFTCoreRole];

    address [] rentals; 
    mapping(address=>bool) knownRentals; 

    mapping(string=>bool) hasDefaultFunctionsByRole;
    mapping(string=>string[]) defaultFunctionsByRole;

    constructor(address _registry, string memory _dappName) OpenRolesSecureCore(_dappName) {
        registry = IOpenRegister(_registry);
        
        setRoleManager(registry.getAddress(roleManagerCA));
        
        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));   

        initDefaultFunctionsForRoles();      
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    } 

    function getDefaultRoles() override view external returns (string [] memory _roles){    
        return  roleNames; 
    }

    function hasDefaultFunctions(string memory _role) override view external returns(bool _hasFunctions){
        return hasDefaultFunctionsByRole[_role];
    }

    function getDefaultFunctions(string memory _role) override view external returns (string [] memory _functions){
        return defaultFunctionsByRole[_role];
    }

    function createRentalContract(RentalSeed memory _seed)  payable external returns (address _rentalContract){ 
        require(isSecure(srsNFTCoreRole, "createRental"), "srs nft core only");
        return createRentalInternal(_seed);                 
    }

    function getRentals() view external returns (address [] memory _proposals) {
        require(isSecure(openAdminRole, "getRentals")," admin only ");    
        return rentals; 
    }

    function isKnownRental(address _rental) view external returns (bool) {
         require(isSecure(openAdminRole, "isKnownRental")," admin only ");    
        return knownRentals [ _rental ];
    }
    
    function notifyChangeOfAddress() external returns (bool _recieved){
        require(isSecure(openAdminRole, "notifyChangeOfAddress")," admin only ");    
        registry                = IOpenRegister(registry.getAddress(registryCA)); // make sure this is NOT a zero address       
        roleManager             = IOpenRoles(registry.getAddress(roleManagerCA));                

        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));         
        return true; 
    }
    
    //=========================================== INTERNAL ========================================================================  
 

    function initDefaultFunctionsForRoles() internal returns (bool _initiated) {
        
        hasDefaultFunctionsByRole[openAdminRole] = true; 
        defaultFunctionsByRole[openAdminRole].push("notifyChangeOfAddress");
        defaultFunctionsByRole[openAdminRole].push("isKnownRental");
        defaultFunctionsByRole[openAdminRole].push("getRentals");

        hasDefaultFunctionsByRole[srsNFTCoreRole] = true;  
        defaultFunctionsByRole[srsNFTCoreRole].push("createRental");
        return true; 
    }

    function createRentalInternal(RentalSeed memory _seed) internal returns (address _rental) {
        StreamingRental rental_ = new StreamingRental(_seed);
        _rental = address(rental_);
        rentals.push(_rental);
        knownRentals[_rental] = true; 
        return _rental; 
    }

}