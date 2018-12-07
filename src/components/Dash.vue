<template>
  <div class="Dash">
    Hello  {{msg}}
     <div class="product-form">
      <label for="description">Description</label>
      <textarea name="description" v-model="description" style="width:300px;height:100px"/><br/>
      <label for="amount">Amount</label>
      <input name="amount" v-model="amount"/><br/>
      <label for="deadline">Deadline</label>
      <input name="deadline" v-model="deadline"/><br/>
    </div>
    <b-button @click="addCommitment" size="" variant="primary">Add Commitment</b-button>
    
  </div>
</template>


<script>
// Datetime picker
//https://www.npmjs.com/package/vue-bootstrap-datetimepicker
//https://jsfiddle.net/ankurk91/01407frf/

// Import required dependencies 
import 'bootstrap/dist/css/bootstrap.css';

// Import this component
import datePicker from 'vue-bootstrap-datetimepicker';

// Import date picker css
import 'pc-bootstrap4-datetimepicker/build/css/bootstrap-datetimepicker.css';

import contract from 'truffle-contract'
import CommitmentsContract from '@contracts/Commitments.json'

export default {
  name: 'Dash',
  data () {
    return {
      msg: 'Hello',
      description: '',
      amount: '',
      deadline: '',
      instance: null,
      
      date: new Date(),
        options: {
          format: 'DD/MM/YYYY',
          useCurrent: false,
        } 

    }
  },
  components: {
    datePicker
  },
  created: function() {
    
    // initialize the contract
    var commitContract = contract(CommitmentsContract)
    commitContract.setProvider(window.web3.currentProvider)
    window.web3.eth.defaultAccount = window.web3.eth.accounts[0]

    // get an instance of the contract
    commitContract.deployed().then(returnInstance => {
      this.instance = returnInstance
      console.log("Commit contract initialized")
      //this.instance.LogNewPerson()
      //this.getPeopleList()
    }).catch(e => {
      alert("error getting contract. Did you do 'truffle migrate'?")
    })
    
  },
  methods: {
    async addCommitment () {
      if (this.description === '') {
        alert('description cannot be empty')
        return
      }
      if (isNaN(this.amount) || this.amount <= 0) {
        alert('enter a valid amount, greater than zero')
        return
      }
      // TODO: Date must be at least a day in advance
      if ( isNaN(Date.parse(this.deadline)) || this.deadline <= new Date()) {
        alert('deadline must be greater than now')
        return
      }
      let deadlineDate = new Date(this.deadline) / 1000
      
      let recipient = window.web3.eth.accounts[1]
      let referee = "0x0000000000000000000000000000000000000000"
      // TODO: Allow input in dollars and convert to ether on submit
      let etherAmount = window.web3.toWei(parseInt(this.amount),'ether')
      let currentUser = web3.eth.accounts[0]
      let response;

      try {
        response = await this.instance.addCommitment(
          this.description,
          deadlineDate,
          etherAmount,
          recipient,
          currentUser,
          referee,
          {from: currentUser, gas: 200000}
          )
        console.log(response)
        alert('success:')
      }catch(err) {
        alert("error")
        console.log(err)
      }

    },
    async convertUSDtoEther() {

    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
  display: block;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>