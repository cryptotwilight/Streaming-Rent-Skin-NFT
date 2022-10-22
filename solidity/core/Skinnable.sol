// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/561d0eead30d3977847f2c2b4ae54eac31c218df/contracts/token/ERC721/ERC721.sol";
import "../interfaces/ISkinnable.sol";

 contract Skinnable is ERC721, ISkinnable { 

    struct Skin {
        uint256 id; 
        address erc721; 
        uint256 nftId; 
        address operator; 
        uint256 skinnedNFTId; 
    }


    Skin [] skins; 
    mapping(uint256=>Skin) skinById; 
    
    mapping(uint256=>bool) hasSkinByLocalNFTId; 
    mapping(uint256=>uint256) skinIdByLocalNFTId; 
    
    mapping(address=>mapping(uint256=>bool))    isSkinByNFTIdByNFTContract; 

    mapping(address=>mapping(uint256=>uint256)) skinIdByNFTIdByNFTContract; 

    mapping(uint256=>mapping(address=>bool))    isApprovedByOperatorByLocalNFTId;     
    mapping(address=>mapping(uint256=>address)) approvingOwnerByLocalNFTIdByOperator; 

    mapping(uint256=>mapping(address=>mapping(address=>mapping(address=>bool)))) isApprovedByDelegateByOperatorByLocalNFTId; 
    
    mapping(uint256=>mapping(address=>bool))    approvalDelegatedByOperatorByLocalNFTId; 

    mapping(address=>mapping(uint256=>address)) approvingOperatorByLocalNFTByDelegate; 
    mapping(uint256=>mapping(address=>bool))    isApprovedByDelegateByLocalNFTId;
    mapping(address=>mapping(uint256=>address)) delegateOperatorByLocalNFTIdByOperator; 

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
    }

    function getAllSkins() view external returns (Skin [] memory _skins) {
        return skins; 
    }

    function getSkin(uint256 _skinId) view external returns(Skin memory _skin) {
        return skinById[_skinId];
    }

     function tokenURI(uint256 _localNFTId) override public view returns (string memory){
         if(hasSkinByLocalNFTId[_localNFTId]){
             Skin memory skin = skinById[skinIdByLocalNFTId[_localNFTId]];
             IERC721Metadata metadata = IERC721Metadata(skin.erc721);
             return metadata.tokenURI(skin.nftId);
         }
         return super.tokenURI(_localNFTId);
     }

    function approveSkinApplication(address _operator, uint256 _localNFTId) external returns (bool _approved) {
        require(msg.sender == _ownerOf(_localNFTId), " not Local NFT owner " );
        isApprovedByOperatorByLocalNFTId[_localNFTId][_operator] = true; 
        approvingOwnerByLocalNFTIdByOperator[_operator][_localNFTId] = msg.sender; 
        return true; 
    }

    function removeSkinApplicationApproval(address _operator, uint256 _localNFTId) external returns (bool _approvalRemoved) {
        require(msg.sender == _ownerOf(_localNFTId), " not Local NFT owner " );
        if(approvalDelegatedByOperatorByLocalNFTId[_localNFTId][_operator]){
            removeDelegateApprovalInternal(_localNFTId, _operator);
        }        
        delete isApprovedByOperatorByLocalNFTId[_localNFTId][_operator]; 
        delete approvingOwnerByLocalNFTIdByOperator[_operator][_localNFTId]; 
        return true; 
    }


    function delegateApproval(uint256 _localNFTId, address _operator, address _delegateOperator) external returns (bool _approvalDelegated) {
        require(isApprovedByOperatorByLocalNFTId[_localNFTId][_operator], " no primary approval ");                
        require(approvingOwnerByLocalNFTIdByOperator[_operator][_localNFTId] == _ownerOf(_localNFTId), " no approval ownership change ");

        isApprovedByDelegateByLocalNFTId[_localNFTId][_delegateOperator] = true; 
        approvingOperatorByLocalNFTByDelegate[_delegateOperator][_localNFTId] = _operator;
        approvalDelegatedByOperatorByLocalNFTId[_localNFTId][_operator] = true; 
        return true;     
    }


    function removeDelegateApproval(uint256 _localNFTId, address _operator) external returns (bool _delegateApprovalRemoved) {
        return removeDelegateApprovalInternal(_localNFTId, _operator);
    }


    function applySkin(address _nftContractAddress, uint256 _nftId, uint256 _localNFTId) external returns (bool _skinApplied){
        require(!isSkinByNFTIdByNFTContract[_nftContractAddress][_nftId]," skin already applied ");  
        require(isOperatorApproved(msg.sender, _localNFTId) || isDelegateApproved(msg.sender, _localNFTId), " no approval to apply Skin " );

        IERC721 erc721_ = IERC721(_nftContractAddress);
        require(erc721_.ownerOf(_nftId) == msg.sender, " operator not owner of Skin NFT "); // the owner of the skin has to apply the skin to the Local NFT                

        Skin memory skin_ = Skin({
                                    id              : block.timestamp, 
                                    erc721          : _nftContractAddress, 
                                    nftId           : _nftId, 
                                    operator        : msg.sender,
                                    skinnedNFTId    : _localNFTId
                                });
         skinIdByLocalNFTId[_localNFTId] = skin_.id; 
         hasSkinByLocalNFTId[_localNFTId] = true; 
         isSkinByNFTIdByNFTContract[_nftContractAddress][_nftId] = true; 
         skins.push(skin_);
         skinIdByNFTIdByNFTContract[skin_.erc721][skin_.nftId] = skin_.id;
         skinById[skin_.id] = skin_; 
         return true; 
    }

    function isSkin(address _nftContractAddress, uint256 _nftId) view external returns (bool _isSkin){
        return isSkinByNFTIdByNFTContract[_nftContractAddress][_nftId];
    }

    function hasSkinApplied(uint256 _localNFTId, address _nftContractAddress) view external returns (bool _hasSkinApplied){
        return skinById[skinIdByLocalNFTId[_localNFTId]].erc721 == _nftContractAddress; 
    }
    
    function hasSkinApplied(uint256 _localNFTId) view external returns (bool _hasSkinApplied){
        return hasSkinByLocalNFTId[_localNFTId];
    }

    function removeSkin(uint256 _localNFTId) external returns (bool _removed) {
        Skin memory skin_ = skinById[skinIdByLocalNFTId[_localNFTId]];
        require(msg.sender == skin_.operator, " invalid operator ");
        unlockInternal(skin_);
        return false; 
    }

    function removeSkin(address _nftContractAddress, uint256 _nftId) external returns (bool _removed){
         Skin memory skin_ = skinById[skinIdByNFTIdByNFTContract[_nftContractAddress][_nftId]];
         require(msg.sender == skin_.operator, " invalid operator ");
         unlockInternal(skin_);
         return false; 
    }

    function getFunctionalTokenURI(uint256 _localTokenId) view external returns (string memory _uri){
        return super.tokenURI(_localTokenId);
    }

    function mint(address _localNFTOwner) external returns (uint256 _localNFTId) {
       _localNFTId = getIndex(); 
       _safeMint(_localNFTOwner, getIndex());
       return _localNFTId; 
    }

    //======================================== INTERNAL ====================================================

    function removeDelegateApprovalInternal(uint256 _localNFTId, address _operator) internal returns (bool _removed) {
        address delegateOperator_ = delegateOperatorByLocalNFTIdByOperator[_operator][_localNFTId];
        delete isApprovedByDelegateByLocalNFTId[_localNFTId][delegateOperator_]; 
        delete approvingOperatorByLocalNFTByDelegate[delegateOperator_][_localNFTId];
        delete approvalDelegatedByOperatorByLocalNFTId[_localNFTId][_operator];
        return true; 

    }

    function isOperatorApproved(address _operator, uint256 _localNFTId) view internal returns (bool _approved) {
        return _ownerOf(_localNFTId) == approvingOwnerByLocalNFTIdByOperator[_operator][_localNFTId]
                && isApprovedByOperatorByLocalNFTId[_localNFTId][_operator]
                && !approvalDelegatedByOperatorByLocalNFTId[_localNFTId][_operator];
    }

    function isDelegateApproved(address _delegateOperator, uint256 _localNFTId) view internal returns (bool _approved){
            address operator_ = approvingOperatorByLocalNFTByDelegate[_delegateOperator][_localNFTId];
            address owner_ = approvingOwnerByLocalNFTIdByOperator[operator_][_localNFTId];
            return _ownerOf(_localNFTId) == owner_ && 
                    isApprovedByOperatorByLocalNFTId[_localNFTId][operator_] && 
                    isApprovedByDelegateByLocalNFTId[_localNFTId][_delegateOperator];
    }

    function _baseURI() internal override pure returns (string memory _uri) {
        return "https://wandering-forest-2153.on.fleek.co/nft/";
    }

    function unlockInternal(Skin memory _skin) internal returns (bool _locked) {
        delete skinIdByLocalNFTId[_skin.skinnedNFTId]; 
        
        delete hasSkinByLocalNFTId[_skin.skinnedNFTId]; 
        
        delete isSkinByNFTIdByNFTContract[_skin.erc721][_skin.nftId]; 

        delete skinIdByNFTIdByNFTContract[_skin.erc721][_skin.nftId];
        return false; 
    }

    uint256 private index = 0; 
    function getIndex() internal returns (uint _index) { 
        _index = index++; 
        return _index;
    }
 }