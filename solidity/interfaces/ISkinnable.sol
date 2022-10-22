// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
/**
 * @title IsKinnable 
 * @dev NFT Contrct Implementations of this interface are able to apply Skins on their NFTs. A Skin is the attributes of a Foreign NFT on a Foreign NFT Contract.
 * The Skinning Process works by masking the attributes of the Local NFT with the attributes of the Foreign NFT. A Local NFT can only have one skin applied at a time. 
 * 
 */
interface ISkinnable {

    /**
     * @dev this provides approval for the given Operator to apply a Skin to the given Local NFT
     * @param _operator entity that will be approved
     * @param _localNFTId Local NFT for which approval has been given
     * @return _approved true if the approval is successful 
     */
    function approveSkinApplication(address _operator, uint256 _localNFTId) external returns (bool _approved);
    
    /** 
     * @dev this removes the approval for the given Operator to apply a Skin to the given Local NFT NOTE: this should not stop the Operator removing the Skin
     * @param _operator entity that will have approval removed
     * @param _localNFTId Local NFT for which approval is to be removed
     * @return _approvalRemoved true  if the approval is successfully removed 
     */ 
    function removeSkinApplicationApproval(address _operator, uint256 _localNFTId) external returns (bool _approvalRemoved);

    /** 
     * @dev this delegates the approval given to the given Operator to the given Delegate Operator 
     * @param _localNFTId Local NFT for which approval is to be delegated
     * @param _operator entity currently holding approval 
     * @param _delegateOperator entity to which approval will be delegated
     * @return _approvalDelegated true if the approval has been successfully delegated
     */
    function delegateApproval(uint256 _localNFTId, address _operator, address _delegateOperator) external returns (bool _approvalDelegated);

    /**
     * @dev this removes the delegated approval for the given Operator 
     * @param _localNFTId Local NFT for which approval has been delegated
     * @param _operator entity for which delegated approval is to be removed
     * @return _delegateApprovalRemoved true if the approval is successfuly removed 
     */
    function removeDelegateApproval(uint256 _localNFTId, address _operator) external returns (bool _delegateApprovalRemoved);

    /**
     * @dev this locks the given Local NFT to the details of the given NFT on the given NFT Contract
     * @param _nftContractAddress the Foreign NFT Contract holding the Skin (Foreign NFT)
     * @param _nftId Foreign NFT to be used as a Skin
     * @param _localNFTId Local NFT to be skinned
     * @return _skinned true if the Local NFT has been successfully skinned
     */
    function applySkin(address _nftContractAddress, uint256 _nftId, uint256 _localNFTId) external returns (bool _skinned);

    /**
     * @dev this returns whether the given Foreign NFT on the given Foreign NFT Contract is being used as a Skin on this NFT Contract
     * @param _nftContractAddress the Foreign NFT Contract holding the Skin (Foreign NFT)
     * @param _nftId Foreign NFT that might be being used as a Skin 
     * @return _isSkin true if the Foreign NFT has been applied to a Local NFT as a Skin
     */
    function isSkin(address _nftContractAddress, uint256 _nftId) view external returns (bool _isSkin);
    
    /**
     * @dev this returns whether the given Local NFT has a Skin applied from the given NFT Contract 
     * @param _localNFTId the Local NFT that has been skinned 
     * @param _nftContractAddress the NFT Contract holding the Skin 
     * @return _hasSkinApplied true if the the Local NFT is locked to the given NFT Contract
     */
    function hasSkinApplied(uint256 _localNFTId, address _nftContractAddress) view external returns (bool _hasSkinApplied);

    /**
     * @dev this checks whether the given Local NFT has a Skin applied 
     * @param _localNFTId Local NFT to check 
     * @return _hasSkinApplied true if the given Local NFT has a SKin applied on this NFT Contract
     */
    function hasSkinApplied(uint256 _localNFTId) view external returns (bool _hasSkinApplied);

    /**
     * @dev this removes the given Foreign NFT as a Skin from this NFT Contract
     * @param _nftContractAddress Foreign NFT Contract containing the Skin (Foreign NFT)
     * @param _nftId Foreign NFT to remove as Skin
     * @return _unskinned true if the  Local NFT has had the Skin applied from the given NFT Contract removed
     */
    function removeSkin(address _nftContractAddress, uint256 _nftId) external returns (bool _unskinned);

    /**
     * @dev this removes the Skin that has been applied to the given Local NFT
     * @param _localNFTId Local NFT to have Skin removed 
     * @return _removed true if the Skinn has been successfully removed from the Local NFT
     */
    function removeSkin(uint256 _localNFTId) external returns (bool _removed);

    /**
     * @dev this returns the Local(default) URI for the Local NFT
     * @param _localNFTId Local NFT for which to return the local URI on this NFT Contract
     * @return _uri of the Local NFT on this NFT Contract
     */
    function getFunctionalTokenURI(uint256 _localNFTId) view external returns (string memory _uri);

}
