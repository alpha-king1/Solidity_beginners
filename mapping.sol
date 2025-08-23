// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Mapping 
{
    mapping (address=>uint) public myMap;

    function get(address _addr) public view returns(uint)
    {
        return myMap[_addr];
    }

    function set(address _addr, uint _i) public
    {
        myMap[_addr] = _i;
    }

    function remove(address _addr)public 
    {
        delete myMap[_addr];
    }
}

contract NextedMapping
{
    mapping(address=> mapping (uint=> bool)) public nextedMap;
    function get (address _addr, uint _id) public view returns(bool)
    {
        return nextedMap[_addr][_id];
    }

    function set(address _addr, uint _id, bool _boolean) public 
    {
        nextedMap[_addr][_id] = _boolean;
    }

    function remove(address _addr, uint _id) public 
    {
        delete  nextedMap[_addr][_id];
    }
}