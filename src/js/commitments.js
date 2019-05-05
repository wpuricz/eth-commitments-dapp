import contract from 'truffle-contract'
import CommitmentsContract from '@contracts/Commitments.json'
import { inherits } from 'util';

class Commitments {
    // const instance = null
    // const contract = null
    
    async init() {
        const contract = contract(CommitmentsContract)
        contract.setProvider(window.web3.currentProvider)
        try{
            const instance = contract.deployed()
            return instance 
        }catch(err) {
            return err
        }
    }

    
}