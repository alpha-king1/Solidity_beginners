// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract x
{
    string public  name;

    constructor (string memory _name)
    {
        name = _name;
    }
}

contract y
{
    string public text;

    constructor (string memory _text)
    {
        text = _text;
    }
}

contract B is x('input to x'), y ('input to y')
{

}

contract C is x,y 
{
    constructor (string memory _name, string memory _text) x(_name) y(_text)
    {

    }
}

contract D is x, y{
    constructor() x('x was called') y('y was called')
    {

    }
}

contract e is x, y 
{
    constructor () x('hi') y('hello')
    {

    }
}