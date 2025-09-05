// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Voting
{
    address owner;
    constructor()
    {
        owner = msg.sender;
    }

    struct candidate
    {
        uint userId;
        address userAddress;
        string name;
        uint voteCount;
    }

    event candidateAdded(uint, address, string);
    event vottersChoice(address, uint);

    uint private voteFee = 1 ether;

    candidate[] candidates;
    mapping (address=>bool) hasVoted;

    function addCandidate(address _address, string memory _name ) public
    {
        require(msg.sender == owner, 'not allowed to add candidate');
        candidates.push(candidate(candidates.length, _address, _name, 0));
        
        emit candidateAdded(candidates.length, _address, _name);
    }

    function getAllCandidates() public view returns (candidate[] memory)
    {
        return candidates;
    }

    function voteCandidate(uint _userId) public payable returns(string memory)
    {
        require(!hasVoted[msg.sender], 'user has voted before');
        require(msg.value > voteFee, 'must have more than 0.01 ether to vote');
        candidates[_userId].voteCount++;

        if (msg.value > voteFee) {
            payable(msg.sender).transfer(msg.value - voteFee);
        }

        hasVoted[msg.sender] = true;

        emit vottersChoice(msg.sender, _userId);
        return 'voted successfully';
    }

    function getWinner() public view  returns (candidate memory)
    {
        uint highestVote = 0;
        uint winnerId = 0;

        for (uint i = 0; i < candidates.length; i++) 
        {
            if (candidates[i].voteCount > highestVote) 
            {
                highestVote = candidates[i].voteCount;
                winnerId = i;
            }
        }

        return candidates[winnerId];
    }

    function withdraw() public returns (string memory)
    {
        require(msg.sender == owner, 'Only owner can withdrw');

        payable(owner).transfer(address(this).balance);

        return 'withdraw sucessfully';
    }
}