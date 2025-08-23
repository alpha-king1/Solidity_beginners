// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Enum 
{
    enum Status
    {
        pending,
        shipped,
        accepted,
        rejected,
        cancelled
    }

    Status public status;

    function get() public view returns(Status)
    {
        return status;
    }

    function set(Status _status) public 
    {
        status = _status;
    }

    function cancel() public 
    {
        status = Status.cancelled;
    }

    function reset() public {
        delete status;
    }
}