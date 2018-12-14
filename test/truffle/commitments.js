var Commitments = artifacts.require("./Commitments.sol");
//truffle test ./test/truffle/commitments.js
contract('Commitments', function ([accounts,owner])  {
    beforeEach('setup contract for each test', async function () {
        c = await Commitments.new()
        sender = {from: web3.eth.accounts[0], gas: 2000000}
    })

    it('it should create an object', function () {
        console.log(web3.eth.accounts[1]);
        assert.ok(c.address);   
    });

    // it('name equals will', async function () {
    //     assert.equal(await c.name(), "will")
    // })
    
    it('should create a commitment', async () => {
        let description = "test commitment"
        let dueDate = 1549065600 // 1543536000 //fail
        let stake = 1 //0 //fail
        let stakeRecipient = web3.eth.accounts[2];
        let referree = "0x0000000000000000000000000000000000000000"
        try {
            await c.addCommitment(description,dueDate,stake,stakeRecipient,referree,sender);
            assert(true)
        }catch(err){
            assert(false)
        }
    });

    // it('should get a commitment of id 1', async () => {
    //     try{
    //         let response = await c.getCommitment(0);
    //         console.log(response)
    //         if(web3.toAscii(response[0]) === "test commitment") {
    //             assert(true);
    //         }else{
    //             assert(false);
    //         }
    //     }catch(err) {
    //         assert(false);
    //     }
    // });

});
