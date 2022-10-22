# Streaming-Rent-Skin-NFTs

## What are they?
The Streaming Rent Skin NFT has been created to introduce the phenomenon of Skinned NFT's. Skin NFTS provide a new and exciting use case for NFTs by 
allowing users to rent expensive NFTs, and apply them over functional and perhaps less exciting cover NFTs. To illustrate a typical user might own 
a Bored Ape or Crypto Punk and then with no additional work beyond raising their listing they would be able to lease their asset to others. On the other side 
a user that may never be able to support a Bored Ape would be able to lease an Ape for a period and display it in place of their own Skinnable / Functional NFT. 
This allows NFTs with form to meet NFTs with function. 

## How do they work?
SRS NFTs work by utilising a Rental Smart Contract that works as the broker between the NFT Lord and the Renter. The contract works by taking control of the NFT from
the original owner and taking funds from the renter. The Rented Skin is then applyed to the Renter's NFT which should implement the [Skinnable Interface](https://github.com/cryptotwilight/Streaming-Rent-Skin-NFT/blob/94327cc23cff7db522b208c613556dc3423f6928/solidity/interfaces/ISkinnable.sol). 
The Renter's NFT will now display the genuine data of the Skin NFT whilst the NFT Lord will not be able to simultaneously utilise the NFT under rent, akin to how a Landlord is unable to use a property that is under rental. 
The funds are streamed using the [Superfluid Protocol](https://www.superfluid.finance/) to the NFT Lord for the duration of the rental allowing either party to cancel the arrangement at any time. The NFT Lord is able to immediately claim any streamed payments without impacting the behaviour of the rental. 
At the end of the rental the NFT Lord is entitled to claim back their NFT removing it from the Renter's NFT. The Renter's NFT then reverts to expressing it's default data. 


## Technical Data 

### SRS NFT Architecture 
SRS NFT has been built using HTML, CSS, JS, and EVM based smart contract built using Solidity. Currently it also leverages the Superfluid Protocol to manage the streaming of payments. 

### SMART Contract Deployment 
SRS NFT is currently deployed on the Goerli EVM Testnet. The relevant contract address for the project are listed below:

|Contract Name              |Contract Address                          |
|---------------------------|------------------------------------------|
|SRSNFTMarketPlace          |0xeCB233CC201124b97222538625c03b28aFD76bFa|
|StreamingRentalFactory     |0x1882973Ad1818dF4DdDE22fBA7e832ae6626B32 |
|SuperTokenRegistry         |0x07101Fc3e9770419730d4e7557e3948FabFe5501|
|OpenRegister               |0x08C5727dD1162a3Ed6E03e81fB25202E6Ded6faD|
|Test Skinnable             |0x72966b1B43573dd5A6A6F4B19178E2733CF0091e|
|Test Payment fUSDC         |0xc94dd466416A7dFE166aB2cF916D3875C049EBB7| 


### UI Deployment 
The Experimental SRS NFT User Interface can be found here:
https://wandering-forest-2153.on.fleek.co/

