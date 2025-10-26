// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// Import ERC721 interface
interface IERC721 {
    function balanceOf(address owner) external view returns (uint256);
}

// Import ERC20 interface (for reward token)
interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Treasure
{
    IERC721 public nftCollection;
    address public owner;

    event deposits(uint amount, bool success);
    event withdraws(uint amount, bool success);

    constructor(address _nftCollection) {
        nftCollection = IERC721(_nftCollection);
        owner = msg.sender;
    }

    function deposit(uint _amount) public payable 
    {
        uint value = _amount * 1 ether;
        require(msg.sender == owner, "only owners can");
        (bool success, ) = owner.call{value: msg.value - value}("");
        require(success,"insuccessful transfre");

        emit deposits(msg.value, success);
    }

    function withdraw(uint _amount) public payable 
    {
        uint value = _amount * 1 ether;
        require(msg.sender == owner, "only owners can use this");
        (bool success, ) = owner.call{value:value}('');

        emit withdraws(_amount, success);
    }

    function balance()public view returns (uint)
    {
        return address(this).balance / 1 ether;
    }

    modifier holder()
    {
        require(nftCollection.balanceOf(msg.sender) > 0, "Not eligible: No NFT");
        _;
    }


    function getRandom() public view 
    {
        uint amount = address(this).balance;
        address sender = msg.sender;
       
    }

}