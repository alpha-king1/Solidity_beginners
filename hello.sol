// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

// contract MyFirstContract
// {
//     // string public hey = 'hii';
//     // uint256 public number = 7;

//     string public hey;
//     uint256 public number;

//     // constructor(string memory _hey, uint _number)
//     // {
//     //     hey = _hey;
//     //     number = _number;
//     // }

//     function addInfo(string memory _hey, uint _number) public 
//     {
//         hey = _hey;
//         number = _number;
//     }
// }

// contract NFTCount
// {
//     uint public numberOfNFT;
//     string public message;

//     function addNFT() public 
//     {
//         numberOfNFT += 1;
//         message = 'one nft added successfully';
//     }

//     function deleteNFT() public 
//     {
//         numberOfNFT -= 1;
//         message = 'one nft removed';

//     }
// }

contract PersonalContract
{
    uint  hey;
    string userName;
    function addName(string memory _userName) public 
    {
        userName = _userName;
    }

    function getInfo() public view returns (uint)
    {
        return hey;
    }

    function updateData(uint _hey) public 
    {
        hey = _hey;
    }

    function get(uint _a, uint _b) public pure returns (uint)
    {
        uint newNumbe = _a + _b;
        return newNumbe;
    }
}

