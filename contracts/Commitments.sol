pragma solidity ^0.5;

contract Commitments {
    
    enum CommitmentStatus { proposed, active, finished, pending, verified }
    Commitment[] public commitments;
    mapping(uint => Commitment) private commitmentMap;
    uint[] private commitmentIndex;

    event CommitmentCreated(uint transactionId);
    
    struct Commitment {
        uint index;
        bytes32 description;
        uint dueDate;
        uint stake;
        address stakeRecipient;
        address commitmentPerson;
        address referee;
        CommitmentStatus status;
        bool completed;
    }

    constructor() public {
    }

    function addCommitment(
        bytes32 _description,
        uint _dueDate,
        uint _stake,
        address _stakeRecipient,
        address _referee ) public returns(uint index) {

        //require(keccak256(_description) != keccak256(""));
        //TODO: Check for empty description
        require(_dueDate > now);
        require(_stake > 0);

        Commitment memory commitment;
        commitment.index = commitmentIndex.push(commitmentIndex.length)-1;
        commitment.description = _description;
        commitment.dueDate = _dueDate;
        commitment.stake = _stake;
        commitment.stakeRecipient = _stakeRecipient;
        commitment.referee = _referee;
        commitment.commitmentPerson = msg.sender;
        commitment.status = CommitmentStatus.active;
        commitment.completed = false;
        commitmentMap[commitment.index] = commitment;  
        commitments.push(commitment);
        //emit CommitmentCreated(transactionId);  
        return commitmentIndex.length -1;
    }

    function getCommitment(uint _transactionId) public view returns( bytes32 description, uint stake) {
        return(
            commitmentMap[_transactionId].description,
            commitmentMap[_transactionId].stake
        );
    }

    function updateTransaction(uint _transactionId, uint _status) public {
        // check msg.sender
        require(_status >= 0 && _status <= uint(CommitmentStatus.verified));
        //commitmentMap[_transactionId].stake = _stake;//CommitmentStatus(_status);
        Commitment memory c = commitments[_transactionId];
        c.status = CommitmentStatus(_status);
        commitments[_transactionId] = c;
        commitmentMap[_transactionId] = c; //do i need this also?
        // emit event here

    }

    function getCommitmentCount() public view returns(uint count) {
        return commitmentIndex.length;
    }

    function getAllCommitments() public view returns (bytes32[] memory, uint[] memory, address[] memory, uint[] memory) {

        uint length = getCommitmentCount();

        bytes32[] memory descriptions = new bytes32[](length);
        uint[] memory stakes = new uint[](length);
        address[] memory recipients = new address[](length);
        uint[] memory statuses = new uint[](length);

        for(uint i=0; i<length; i++) {
            Commitment memory commitment;
            commitment = commitments[i];

            descriptions[i] = commitment.description;
            stakes[i] = commitment.stake;
            recipients[i] = commitment.stakeRecipient;
            statuses[i] = uint(commitment.status);
        }

        return (descriptions, stakes, recipients, statuses);

    }

}

//https://ethereum.stackexchange.com/questions/32173/how-to-handle-dates-in-solidity-and-web3
//https://ethereum.stackexchange.com/questions/19502/passing-string-object-with-0x-value-as-bytes32-to-a-solidity-function?rq=1
