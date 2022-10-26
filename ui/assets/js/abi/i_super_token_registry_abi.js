iSuperTokenRegistry = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_superToken",
				"type": "address"
			}
		],
		"name": "addSuperToken",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_added",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			}
		],
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
		"inputs": [
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			}
		],
		"name": "isSupported",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_suppored",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_superToken",
				"type": "address"
			}
		],
		"name": "removeSuperToken",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_removed",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]