const onboardButton = ge("connect_web_3");
const showWallet = ge("show_wallet");
const metamask = ge("metamask_logo");

var account;
	
	//Created check function to see if the MetaMask extension is installed
const isMetaMaskInstalled = () => {onboardButton
	//Have to check the ethereum binding on the window object to see if it's installed
	const { ethereum } = window;
	return Boolean(ethereum && ethereum.isMetaMask);
};

const MetaMaskClientCheck = () => {
		//Now we check to see if Metmask is installed
		if (!isMetaMaskInstalled()) {
			console.log("metamask not installed");
		//If it isn't installed we ask the user to click to install it
		onboardButton.innerText = 'Click here to install MetaMask!';
		//When the button is clicked we call this function
		onboardButton.onclick = onClickInstall;
		//The button is now disabled
		onboardButton.disabled = false;
		} else {
		//If it is installed we change our button text
		onboardButton.innerText = 'Click to Connect Metamask';
		console.log("metamask installed");
		onboardButton.addEventListener('click', () => {
				getAccount();
		});
		}
	};
const initialize = () => {							  
	MetaMaskClientCheck();
	
};
window.addEventListener('DOMContentLoaded', initialize);

async function getAccount() {
	const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
	account = accounts[0];
	showWallet.innerHTML = account;
	metamask.innerHTML = "<img src='assets/img/logo/metamask.png' width=15 height=15/>"
	onboardButton.innerText = "Web 3 Connected";
}
		
//We create a new MetaMask onboarding object to use in our app
//const onboarding = new MetaMaskOnboarding({ forwarderOrigin });

//This will start the onboarding proccess
const onClickInstall = () => {
	onboardButton.innerText = 'Onboarding in progress';
	onboardButton.disabled = true;
	//On this object we have startOnboarding which will start the onboarding process for our end user
	onboarding.startOnboarding();
};
		
const onClickConnect = async () => {
	try {
	// Will open the MetaMask UI
	// You should disable this button while the request is pending!
	await ethereum.request({ method: 'eth_requestAccounts' });
	} catch (error) {
	console.error(error);
	}
};

function ge(name) {
	return document.getElementById(name);
}

function ce(name) {
	return document.createElement(name);
}

function text(txt) {
	return document.createTextNode(txt);
}