// SPDX-License-Identifier: MIT
pragma solidity ^0.8 ;
import './enum.sol';

contract Personal
{
    address public owner;
    string public  name;
    int constant add = 3;

    constructor()
    {
        owner = msg.sender;
    }

    function changeUserName(string memory _name) public
    {
        name = _name;  
    }

    function addToken()public user() view returns (int) 
    {
        int b = 6;
        int calculation = add + b;
        return calculation;
    } 

    modifier user() 
    {
        require(owner == msg.sender, 'not allowed');
        _;
    }

    function changeOwner(address _owner) public 
    {
        owner = _owner;
    }
}