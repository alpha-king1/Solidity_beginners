// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Counter
{
    uint number = 0;
    address owner ;

    event detail (address user, uint number);

    constructor()
    {
        owner = msg.sender;
    }

    function addNumber() public 
    {
        number++;
        emit detail(msg.sender, number);
    }

    function subtract() public 
    {
        require(number>0, 'cant go below zero');
        number--;
        emit detail(msg.sender, number);
    }

    function reset() public 
    {
        require(owner == msg.sender, "only owner can use this function");
        number = 0;
        emit detail(msg.sender, number);
    }
}