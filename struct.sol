// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Struct 
{
    struct Todo
    {
        string text;
        bool complected;
    }
    Todo[] public todo;

    function create(string calldata _text) public 
    {
        todo.push(Todo(_text, false));

        //type 2
        todo.push(Todo({text: _text, complected:false}));

        ///type 3
        Todo memory todos;
        todos.text = _text;
        todo.push(todos); 
    }

    
}