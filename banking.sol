// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Banking
{
    address owner;
    event depositFunds(address userAddress, uint amount);
    event withdrawFunds(address userAddress, uint amount);

    mapping (address=>uint) userDeposit;
    
    function deposit(uint _amount) public payable  
    {
        uint funds= _amount * 1 ether;
        address sender = msg.sender;
        require(_amount > 0, "deposit must be greater than zero ");

        userDeposit[sender] += _amount;

        //send amount to contract.
        if (_amount > 0) 
        {
            (bool success,  ) = sender.call{value: msg.value - funds}("");
            require(success);
        }
        emit depositFunds(sender, _amount); 
    }

    function withdraw(uint _amount) public payable 
    {
        uint balance = userDeposit[msg.sender];
        require(balance > 0, "cant process zero amount");
        require(_amount <= balance, "cant withdraw more than you deposited");
        
        userDeposit[msg.sender] -= _amount;
        uint value = _amount * 1 ether;
        if (_amount <= balance) 
        {
            (bool success,  ) = msg.sender.call{value: value}("");
            require(success);
        }
        emit withdrawFunds(msg.sender, _amount);
    }

    function checkDeposit()public view returns(uint)
    {
        return userDeposit[msg.sender];
    }
}