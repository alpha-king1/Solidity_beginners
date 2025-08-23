
// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// contract StateVariable
// {
//     string public myState;
//     uint public myNum;
//     // string public defaultText = 'default text';
//     // uint public defaultNumber = 5;

//     // bytes public defaultByte = 'yooo';
//     // bytes public dByte;

//     // uint [] public numbers;

//     constructor(string memory _text, uint _no)
//     {
//         myState = _text;
//         myNum = _no;
//     }

//     function update(string memory _text, uint _no) public 
//     {
//         myState = _text;
//         myNum = _no;
//     }
// }

// contract LocalVariable
// {
//     uint initial;

//     function calculate()public returns (uint, address, uint)
//     {
//         uint i = 56;
//         i += 10;
//         initial = i;
//         address myAddress = address(1);
//         return (i, myAddress, initial);
//     }
// }

contract GlobalValue
{
    address public owner;
    address public  myBlockHash;
    uint public difficulty;
    uint public gasLimit;
    uint public number;
    uint public value;
    uint public nowOn;
    uint public origin;
    uint public gasPrice;
    bytes public callData;
    uint public firstFour;


    constructor()  
    {
        owner = msg.sender;
        myBlockHash = block.coinbase;
        //difficulty = block.difficulty;
        callData = msg.data;

    }
}