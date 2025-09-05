// pragma solidity ^0.8.30;

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

// SPDX-License-Identifier: MIT

// Make sure the compiler version is below 0.8.24 since Cancun compiler is not supported just yet
pragma solidity >=0.8.0 <=0.8.24;

contract Gmonad { 
    string public greeting;

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function setGreeting(string calldata _greeting) external {
        greeting = _greeting;
    }
}