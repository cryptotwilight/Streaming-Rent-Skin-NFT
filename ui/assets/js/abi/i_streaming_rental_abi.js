iStreamingRentalAbi = [
	{
		"inputs": [],
		"name": "cancel",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "ownerBalance",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "renterBalance",
						"type": "uint256"
					}
				],
				"internalType": "struct RentalBalance",
				"name": "_balance",
				"type": "tuple"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "close",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_rentalClosed",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_balance",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getBalances",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "ownerBalance",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "renterBalance",
						"type": "uint256"
					}
				],
				"internalType": "struct RentalBalance",
				"name": "_balance",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getEndDate",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_expiryDate",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getPaymentErc20",
		"outputs": [
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getRentalStatus",
		"outputs": [
			{
				"internalType": "string",
				"name": "_status",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getSeed",
		"outputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "register",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "marketPlace",
						"type": "address"
					},
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
						"internalType": "struct RentalListing",
						"name": "listing",
						"type": "tuple"
					},
					{
						"internalType": "address",
						"name": "skinnableNFT",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "localNFTId",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "renter",
						"type": "address"
					}
				],
				"internalType": "struct RentalSeed",
				"name": "_seed",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getStartDate",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_startDate",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getSuperToken",
		"outputs": [
			{
				"internalType": "address",
				"name": "_superToken",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "initialize",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_initialized",
				"type": "bool"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	}
]