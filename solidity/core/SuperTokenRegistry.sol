// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;


import {ISuperToken} from "https://github.com/superfluid-finance/protocol-monorepo/blob/b9806acd1055d2dec1cd1051ca87d22ad147958e/packages/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";

import "https://github.com/Block-Star-Logic/open-libraries/blob/703b21257790c56a61cd0f3d9de3187a9012e2b3/blockchain_ethereum/solidity/V1/libraries/LOpenUtilities.sol";

import "https://github.com/Block-Star-Logic/open-roles/blob/b05dc8c6990fd6ba4f0b189e359ef762118d6cbe/blockchain_ethereum/solidity/v2/contracts/core/OpenRolesSecureCore.sol";
import "https://github.com/Block-Star-Logic/open-roles/blockchain_ethereum/solidity/v2/contracts/interfaces/IOpenRolesManaged.sol";

import "https://github.com/Block-Star-Logic/open-register/blob/0959ffa2af2ca2cb3e5dd0f7b495e831cca2d506/blockchain_ethereum/solidity/V1/interfaces/IOpenRegister.sol";

import "../interfaces/ISuperTokenRegistry.sol";

contract SuperTokenRegistry is OpenRolesSecureCore, IOpenVersion, IOpenRolesManaged, ISuperTokenRegistry { 

    using LOpenUtilities for address; 

    string constant name                     = "RESERVED_SUPER_TOKEN_REGISTRY";
    uint256 constant version                 = 1; 

    string constant registryCA               = "RESERVED_OPEN_REGISTER_CORE";  
    string constant roleManagerCA            = "RESERVED_OPEN_ROLES_CORE";

    string constant openAdminRole            = "OPEN_ADMIN_ROLE";

    string [] roleNames                      =  [openAdminRole];

    address []                  supportedErc20s;
    mapping(address=>bool)      isSupportedErc20; 
    mapping(address=>address)   superTokenByErc20;
    mapping(string=>bool)       hasDefaultFunctionsByRole;
    mapping(string=>string[])   defaultFunctionsByRole;
    
    IOpenRegister registry; 
    
    constructor(address _register, string memory _dappName) OpenRolesSecureCore(_dappName) {
        registry = IOpenRegister(_register);
        setRoleManager(registry.getAddress(roleManagerCA));
        
        self        = address(this);

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

    function isSupported(address _erc20) view external returns (bool _suppored) {
        return isSupportedErc20[_erc20];
    }

    function getSuperToken(address _erc20) view external returns (address _superToken) {
        return superTokenByErc20[_erc20];
    }

    function addSuperToken(address _superToken) external returns (bool _added) {  
        require(isSecure(openAdminRole, "addSuperToken")," admin only ");       
        address underlying_ = ISuperToken(_superToken).getUnderlyingToken(); 
        superTokenByErc20[underlying_] = _superToken;
        isSupportedErc20[underlying_] = true; 
        supportedErc20s.push(_superToken);
        return true; 
    }

    function removeSuperToken(address _superToken) external returns (bool _removed) {
        require(isSecure(openAdminRole, "removeSuperToken")," admin only "); 
        address underlying_ = ISuperToken(_superToken).getUnderlyingToken();
        delete superTokenByErc20[underlying_];
        delete isSupportedErc20[underlying_];
        supportedErc20s = underlying_.remove(supportedErc20s);
        return true; 
    }

    function notifyChangeOfAddress() external returns (bool _recieved){
        require(isSecure(openAdminRole, "notifyChangeOfAddress")," admin only "); 
        registry                = IOpenRegister(registry.getAddress(registryCA)); // make sure this is NOT a zero address          
        setRoleManager(registry.getAddress(roleManagerCA));
        
        addConfigurationItem(address(registry));   
        addConfigurationItem(address(roleManager));   
        return true; 
    }

    //================================ INTERNAL =========================================================


    function initDefaultFunctionsForRoles() internal returns (bool _initiated) {
        
        hasDefaultFunctionsByRole[openAdminRole] = true; 
        defaultFunctionsByRole[openAdminRole].push("notifyChangeOfAddress");
        defaultFunctionsByRole[openAdminRole].push("removeSuperToken");
        defaultFunctionsByRole[openAdminRole].push("addSuperToken");

        return true; 
    }

}