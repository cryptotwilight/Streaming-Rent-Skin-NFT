iSRSNFTMarketplaceAbi = [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_listingId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_skinnableNFT",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_localTokenId",
				"type": "uint256"
			}
		],
		"name": "createRentalAgreement",
		"outputs": [
			{
				"internalType": "address",
				"name": "_rentalContract",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getListings",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "nftContract",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "nftId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "period",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "paymentErc20",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "rentalFee",
						"type": "uint256"
					}
				],
				"internalType": "struct RentalListing[]",
				"name": "_listings",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getRentals",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "_rentalContracts",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_nftContractAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_nftId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_rentalFee",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_period",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_paymentErc20",
				"type": "address"
			}
		],
		"name": "postListing",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_posted",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_listingId",
				"type": "uint256"
			}
		],
		"name": "withdrawListing",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_withdrawn",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]