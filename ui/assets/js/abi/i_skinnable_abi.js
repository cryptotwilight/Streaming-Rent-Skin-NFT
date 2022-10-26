iSkinnableAbi = [
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
				"name": "_localNFTId",
				"type": "uint256"
			}
		],
		"name": "applySkin",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_skinned",
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
				"name": "_operator",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_localNFTId",
				"type": "uint256"
			}
		],
		"name": "approveSkinApplication",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_approved",
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
				"name": "_localNFTId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_operator",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_delegateOperator",
				"type": "address"
			}
		],
		"name": "delegateApproval",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_approvalDelegated",
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
				"name": "_localNFTId",
				"type": "uint256"
			}
		],
		"name": "getFunctionalTokenURI",
		"outputs": [
			{
				"internalType": "string",
				"name": "_uri",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_localNFTId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_nftContractAddress",
				"type": "address"
			}
		],
		"name": "hasSkinApplied",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_hasSkinApplied",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_localNFTId",
				"type": "uint256"
			}
		],
		"name": "hasSkinApplied",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_hasSkinApplied",
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
				"name": "_nftContractAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_nftId",
				"type": "uint256"
			}
		],
		"name": "isSkin",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_isSkin",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_localNFTId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_operator",
				"type": "address"
			}
		],
		"name": "removeDelegateApproval",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_delegateApprovalRemoved",
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
				"name": "_nftContractAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_nftId",
				"type": "uint256"
			}
		],
		"name": "removeSkin",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_unskinned",
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
				"name": "_localNFTId",
				"type": "uint256"
			}
		],
		"name": "removeSkin",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_removed",
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
				"name": "_operator",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_localNFTId",
				"type": "uint256"
			}
		],
		"name": "removeSkinApplicationApproval",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_approvalRemoved",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]