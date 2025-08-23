// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Payable 
{
    address payable public owner;

    constructor ()payable 
    {
        owner = payable (msg.sender);
    }

    function deposit() public payable 
    {

    }

    function notpayable() public 
    {

    }

    function withdraw() public
    {
        uint amount = address(this).balance;
        (bool success, ) = owner.call{value: amount}("");
        require(success, "failed to send");
    }

    function transfer(address payable  _address, uint _amount) public 
    {
        (bool success,) = _address.call{value: _amount}("");
        require(success, "failed to send");
    }
}

contract ReceiveFunds
{
    receive() external payable { }

    fallback() external payable { }

    function getbalance() public view returns(uint)
    {
        return address(this).balance;
    }
}

contract sendeth
{
    function sendviaTransfer(address payable _addy) public payable 
    {
        //not recommended
        _addy.transfer(msg.value);
    }

    function sendViaSend(address payable _addy) public payable 
    {
        bool send = _addy.send(msg.value);
        require(send, 'not sent');
    }

    function sendViaCall(address payable _addy) public payable
    {
        //recomended
        (bool sent, bytes memory data) = _addy.call{value: msg.value}('paid');
        require(sent, 'not sent');
    }
}