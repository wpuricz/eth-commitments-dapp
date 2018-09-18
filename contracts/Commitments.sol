pragma solidity ^0.4.21;

contract Commitments {
    
    enum CommitmentStatus { proposed, active, finished, pending, verified }
    
    struct Commitment {
        string description;
        uint dueDate;
        uint stake;
        address stakeRecipient;
        address referee;
        address commitmentPerson;
        CommitmentStatus status;
        bool completed;
    }
    Commitment[] public commits;

    function addCommitment(
        string _description, 
        uint _dueDate, 
        uint _stake, 
        address _stakeRecipient, 
        address _referee, 
        address _commitmentPerson ) public  {
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