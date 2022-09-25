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
		"name": "getErc20",
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
		"name": "getExpiry",
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
		"name": "getListing",
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
				"internalType": "struct RentalListing",
				"name": "_listing",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getNFT",
		"outputs": [
			{
				"internalType": "address",
				"name": "_nftContract",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_nftId",
				"type": "uint256"
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
	}
]