import React from "react";
import Web3 from "web3";

const Ticket = () => {
    
    const connectWalletHandler = async () => {
        if(typeof window !== 'undefined' && typeof window.ethereum !== 'undefined') {
            try {
                await window.ethereum.request({ method: "eth_requestAccounts"});
                Web3 = new Web3(window.ethereum);
            } catch(err) {
                console.log(err.message);
            }
        } else {
            console.log('Please install MetaMask');
        }
    }

    return ( 
        <>
            <div id="page">
                <div className="dropdown">
                   <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">Buy or Sell Tickets</button>
                   <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="primary">Buy Primary Ticket</a></li>
                        <li><a class="dropdown-item" href="secondary">Buy Secondary Ticket</a></li>
                        <li><a class="dropdown-item" href="sell">Sell Ticket</a></li>
                    </ul>
                </div>
            </div>
            <div className="container">
                <button onClick={connectWalletHandler} className="btn btn-primary">Connect Metamask</button>
            </div>
        </>
    );
}

export default Ticket;