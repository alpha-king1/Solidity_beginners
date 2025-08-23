// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Array
{
    uint[] private array;

    uint[] private array2 = [1,2,2];

    uint[5] private fixedSizeArray;

    function get(uint _i) public view returns(uint)
    {
        return array2[_i];
    } 

    function getAll() public view returns(uint[] memory)
    {
        return array2;
    }

    function push(uint _i) public 
    {
        array.push(_i);
    }

    function pop() public 
    {
        array.pop();
    }

    function lenght() public view returns (uint)
    {
        return array.length;
    }

    function remove(uint _i) public 
    {
        delete array[_i];
    }

    function examples() external pure returns (uint[] memory)
    {
        uint[] memory a = new uint[](5);
        return a;
    }

}

