pragma solidity ^0.4.21;

contract Commitments {
    
    enum CommitmentStatus { proposed, active, finished, pending, verified }

    string public name;
    
    struct Commitment {
        string description;
        uint dueDate;
        uint stake;
        address stakeRecipient;
        address commitmentPerson;
        address referee;
        CommitmentStatus status;
        bool completed;
    }
    Commitment[] public commits;

    constructor() public {
        name = "will";
    }

    function addCommitment(
        string _description, 
        uint _dueDate, 
        uint _stake, 
        address _stakeRecipient,  
        address _commitmentPerson,
        address _referee ) public  {
        require(keccak256(_description) != keccak256(""));
        require(_dueDate > now);
        require(_stake > 0);
        
        
        Commitment memory commitment;
        commitment.description = _description;
        commitment.dueDate = _dueDate;
        commitment.stake = _stake;
        commitment.stakeRecipient = _stakeRecipient;
        commitment.referee = _referee;
        commitment.commitmentPerson = _commitmentPerson;
        commitment.status = CommitmentStatus.active;
        commitment.completed = false;
        commits.push(commitment);    
        
    }


}

//https://ethereum.stackexchange.com/questions/32173/how-to-handle-dates-in-solidity-and-web3