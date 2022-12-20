// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ticketing {
    uint public primaryPrice;
    uint public ticketCount;

    // Constructor
    constructor(uint _primaryPrice) {
        // Set the ticket's primary price
        primaryPrice = _primaryPrice;
        ticketCount = 0;
    }

    // Ticket struct
    struct Ticket {
        address owner;
        uint price;
        bool isUsed;
    }


    // Primary market ticket sales
    mapping (uint => Ticket) public primaryMarketTickets;
    // Secondary market ticket sales
    mapping (uint => Ticket) public secondaryMarketTickets;
    // Number of tickets for the corresponding address
    mapping (address => uint) public numOfTicket;


    // Buy a ticket from the primary market
    function buyTicketFromPrimaryMarket(address owner, uint _price, bool isUsed, uint ticketId) public payable {
        require(!primaryMarketTickets[ticketId].isUsed, "Ticket is already used.");
        require(_price == primaryPrice, "Invalid price");

        // Assign the ticket to the current user
        primaryMarketTickets[ticketId].owner = msg.sender;

        Ticket memory ticket = Ticket(owner, _price, isUsed);
        ticketCount++;
        numOfTicket[msg.sender] = ticketCount; // Add 1 ticket to the current user
        primaryMarketTickets[ticketId] = ticket; // Assign an id to a ticket
    }

    
    // Buy a ticket from the secondary market
    function buyTicketFromSecondaryMarket(address owner, bool isUsed, uint ticketId) public payable {
        require(!secondaryMarketTickets[ticketId].isUsed, "Ticket is already used.");
        require(msg.value > 0, "Invalid price");
        require(secondaryMarketTickets[ticketId].owner != address(this), "Ticket is not for sale");
        // Check if the ticket is available
        require(secondaryMarketTickets[ticketId].owner != msg.sender, "Cannot buy your own ticket");
        // Check if the caller has enough balance to buy the ticket
        require(msg.value >= secondaryMarketTickets[ticketId].price, "Insufficient balance");

        // Transfer ownership of the ticket to the current user
        secondaryMarketTickets[ticketId].owner = msg.sender;

        Ticket memory ticket = Ticket(owner, msg.value, isUsed);
        ticketCount++;
        numOfTicket[msg.sender] = ticketCount; // Add 1 ticket to the current user
        secondaryMarketTickets[ticketId] = ticket; // Assign an id to a ticket
    }

    // Sell a ticket on the secondary market
    function sellSecondaryMarketTicket(uint ticketId, uint price) public payable{
        require(!secondaryMarketTickets[ticketId].isUsed, "Ticket has already been used and cannot be sold.");
        require(secondaryMarketTickets[ticketId].owner == msg.sender, "Only the ticket owner can sell the ticket.");
        require(price <= primaryPrice, "Ticket price should be less than or equal to the primary market price.");

        // Set the new price and transfer ownership to the contract
        secondaryMarketTickets[ticketId].price = price;
        secondaryMarketTickets[ticketId].owner = address(this);

        // Ticket memory ticket = Ticket(owner, isUsed);
        ticketCount--;
        numOfTicket[msg.sender] = ticketCount; // Take 1 ticket out of the current user
    }

    // Verify a ticket hasn't been used
    function verifyTicketIsUnused(uint ticketId) public view returns(bool) {
        return !primaryMarketTickets[ticketId].isUsed || !secondaryMarketTickets[ticketId].isUsed;
    }

    // Use a ticket
    function useTicket(uint ticketId) public {
        require(msg.sender == primaryMarketTickets[ticketId].owner || msg.sender == secondaryMarketTickets[ticketId].owner, "Only the ticket owner can use the ticket.");
        require(!primaryMarketTickets[ticketId].isUsed || !secondaryMarketTickets[ticketId].isUsed, "Ticket is already been used.");
        require(numOfTicket[primaryMarketTickets[ticketId].owner] > 0 || numOfTicket[secondaryMarketTickets[ticketId].owner] > 0, "Not enough tickets."); // New added

        ticketCount--;
        numOfTicket[msg.sender] = ticketCount;

        // Set both the primary and secondary market ticket to be used
        primaryMarketTickets[ticketId].isUsed = true;
        secondaryMarketTickets[ticketId].isUsed = true;
    }

    // Get total of tickets
    function getTotalTickets() public view returns (uint) {
        return numOfTicket[msg.sender];
    }
}