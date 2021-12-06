pragma solidity ^0.8.6;

contract Voting {
    mapping (address=>bool) public voters;

    address public admin;

    mapping (address=>mapping (uint=>bool)) public votes;

    struct Choice {
        uint id;
        string name;
        uint votes;
    }

    struct Ballet {
        uint id;
        string name;
        Choice[] choices;
        uint end;

    }

    mapping(uint => Ballet) ballets;
    uint nextBallotId;

    constructor(){
        admin = msg.sender;
    }

    // ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]
    function addVoters(address[] memory _voters) external onlyAdmin() {
        for(uint i = 0; i < _voters.length ; i++) {
            voters[_voters[i]] = true;
        }
    }

    // "India Election", ["Narendra Modi", "Rahul Gandhi", "Arvind Kejriwal"],  60
    function createBallot(string memory name, string[] memory choices,  uint offset) external onlyAdmin() {
        ballets[nextBallotId].id = nextBallotId;
        ballets[nextBallotId].name = name;
        ballets[nextBallotId].end = block.timestamp + offset;
        for(uint i = 0 ; i < choices.length ; i++) {
            ballets[nextBallotId].choices.push(Choice(i, choices[i], 0));
        }
    }

    // 0,2
    function vote(uint ballotId, uint choiceId) external {
        require(voters[msg.sender] == true, "You are not the voters");
        require(votes[msg.sender][ballotId] == false, "You already voted for this ballet");
        require(block.timestamp < ballets[ballotId].end , "Voting already ended");
        votes[msg.sender][ballotId] = true;
        ballets[ballotId].choices[choiceId].votes++;
    }

    // 0
    function results(uint ballotId ) view external returns(Choice[] memory){
        require(block.timestamp >= ballets[ballotId].end, 'voting is still not ended');
        return ballets[ballotId].choices;   
    }
    modifier onlyAdmin() {
        require(msg.sender == admin, 'Your are not the admin');
        _;
    }
}