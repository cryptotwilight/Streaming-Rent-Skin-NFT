// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/561d0eead30d3977847f2c2b4ae54eac31c218df/contracts/token/ERC721/ERC721.sol";
import "../interfaces/ISkinnable.sol";

 contract Skinnable is ERC721, ISkinnable { 

     struct Skin {
         uint256 id; 
         address erc721; 
         uint256 nft; 
         address rentalContract; 
         uint256 localTokenId; 
     }

     Skin [] skins; 
     mapping(uint256=>Skin) skinById; 

     mapping(address=>mapping(uint256=>bool)) lockedNFTByNFTContract; 
     mapping(uint256=>bool) isLockedByLocalTokenId; 
     mapping(uint256=>uint256) skinIdByLocalTokenId; 
     mapping(address=>mapping(uint256=>uint256)) skinIdByNftByAddress; 

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
    }

    function getAllSkins() view external returns (Skin [] memory _skins) {
        return skins; 
    }

    function getSkin(uint256 _skinId) view external returns(Skin memory _skin) {
        return skinById[_skinId];
    }

     function tokenURI(uint256 _localTokenId) override public view returns (string memory){
         if(isLockedByLocalTokenId[_localTokenId]){
             Skin memory skin = skinById[skinIdByLocalTokenId[_localTokenId]];
             IERC721Metadata metadata = IERC721Metadata(skin.erc721);
             return metadata.tokenURI(skin.nft);
         }
         return super.tokenURI(_localTokenId);
     }

    function lock(address _nftContractAddress, uint256 _nftId, uint256 _localTokenId) external returns (bool _locked){
        IERC721 erc721_ = IERC721(_nftContractAddress);
        require(erc721_.ownerOf(_nftId) == msg.sender, " skin nft not owned "); 
        Skin memory skin_ = Skin({
                                    id      : block.timestamp, 
                                    erc721  : _nftContractAddress, 
                                    nft     : _nftId, 
                                    rentalContract : msg.sender,
                                    localTokenId    : _localTokenId
                                });
         skinIdByLocalTokenId[_localTokenId] = skin_.id; 
         isLockedByLocalTokenId[_localTokenId] = true; 
         lockedNFTByNFTContract[_nftContractAddress][_nftId] = true; 
         skins.push(skin_);
         skinIdByNftByAddress[skin_.erc721][skin_.nft] = skin_.id;
         skinById[skin_.id] = skin_; 
         return true; 
    }

    function isLocked(address _nftContractAddress, uint256 _nftId) view external returns (bool _locked){
        return lockedNFTByNFTContract[_nftContractAddress][_nftId];
    }
    
    function isLocked(uint256 _localTokenId) view external returns (bool _locked){
        return isLockedByLocalTokenId[_localTokenId];
    }

    function unlock(uint256 _localTokenId) external returns (bool _locked) {
        Skin memory skin_ = skinById[skinIdByLocalTokenId[_localTokenId]];
        require(msg.sender == skin_.rentalContract, " invalid owner ");
        unlockInternal(skin_);
        return false; 
    }

    function unlock(address _nftContractAddress, uint256 _nftId) external returns (bool _locked){
         Skin memory skin_ = skinById[skinIdByNftByAddress[_nftContractAddress][_nftId]];
         require(msg.sender == skin_.rentalContract, " invalid owner ");
         unlockInternal(skin_);
         return false; 
    }

    function getFunctionalTokenURI(uint256 _localTokenId) view external returns (string memory _uri){
        return super.tokenURI(_localTokenId);
    }


    //======================================== INTERNAL ====================================================

    function unlockInternal(Skin memory _skin) internal returns (bool _locked) {
        delete skinIdByLocalTokenId[_skin.localTokenId]; 
        delete isLockedByLocalTokenId[_skin.localTokenId]; 
        delete lockedNFTByNFTContract[_skin.erc721][_skin.nft]; 
        delete skinIdByNftByAddress[_skin.erc721][_skin.nft];

        return false; 
    }
 }