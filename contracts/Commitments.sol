pragma solidity ^0.4.21;

contract Commitments {
    
    enum CommitmentStatus { proposed, active, finished, pending, verified }

    mapping(uint => Commitment) private commitments;

    string public name;
    uint private transactionId;

    event CommitmentCreated(uint transactionId);
    
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

    constructor() public {
        name = "will";
        transactionId = 0;
    }

    function addCommitment(
        string _description, 
        uint _dueDate, 
        uint _stake, 
        address _stakeRecipient,  
        address _referee ) public  {

        require(keccak256(_description) != keccak256(""));
        require(_dueDate > now);
        require(_stake > 0);

        Commitment commitment;
        commitment.description = _description;
        commitment.dueDate = _dueDate;
        commitment.stake = _stake;
        commitment.stakeRecipient = _stakeRecipient;
        commitment.referee = _referee;
        commitment.commitmentPerson = msg.sender;
        commitment.status = CommitmentStatus.active;
        commitment.completed = false;
        commitments[transactionId] = commitment;  
        transactionId++;
        //emit CommitmentCreated(transactionId);  
    }

    function updateTransaction(uint transactionId, uint status) {
        // check msg.sender
        require(status >= 0 && status <= uint(CommitmentStatus.verified));
        Commitment c = commitments[transactionId];
        c.status = CommitmentStatus(status);
        commitments[transactionId] = c;
        // emit event here

    }

    

    


}

//https://ethereum.stackexchange.com/questions/32173/how-to-handle-dates-in-solidity-and-web3