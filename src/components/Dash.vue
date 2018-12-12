<template>
  <div class="Dash">
    Hello  {{msg}}
     <form>
       <div class="form-group row">
        <label for="description" class="col-sm-2 col-form-label">Description</label>
        <div class="col-sm-4">
          <!-- <input class="form-control" id="description" placeholder="Description"> -->
          <textarea name="description" class="form-control" v-model="description" style="height:160px"/><br/>          
        </div>
       </div>
      <div class="form-group row">
        <label for="amount" class="col-sm-2 col-form-label">Amount ($USD)</label>
        <div class="col-sm-4">
          <input class="form-control" v-model="amount" id="amount" placeholder="1.00">
        </div>
      </div>
      <div class="form-group row">
        <label for="deadline" class="col-sm-2 col-form-label">Deadline</label>
        <div class="col-sm-4">
          <input class="form-control" id="deadline" v-model="deadline" placeholder="">
        </div>
      </div>
      <div class="form-group row">
        <div class="col-sm-4">
          <button @click.prevent="addCommitment" type="submit" class="btn btn-primary">Submit</button>
        </div>
      </div>
     </form>
     <div v-if="errorMessage != ''" class="alert alert-light processing" role="alert">
      {{errorMessage}}
    </div>
    
  </div>
</template>


<script>
// Datetime picker
//https://www.npmjs.com/package/vue-bootstrap-datetimepicker
//https://jsfiddle.net/ankurk91/01407frf/
import axios from 'axios';
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
      //formError: false,
      errorMessage: '',
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
  created: async function() {
    
    // initialize the contract
    var commitContract = contract(CommitmentsContract)
    commitContract.setProvider(window.web3.currentProvider)
    window.web3.eth.defaultAccount = window.web3.eth.accounts[0]

    // get an instance of the contract
    try{
      let returnInstance = commitContract.deployed()
      this.instance = returnInstance
      console.log("Commit contract initialized")
    }catch(e) {
      alert("error getting contract. Did you do 'truffle migrate'?")
    }

  },
  methods: {
    async addCommitment () {
      if (this.description === '') {
        this.errorMessage = "description cannot be empty"
        return
      }
      let amt = parseFloat(this.amount)
      //console.log("amt:" + amt)
      if (isNaN(amt) || amt <= 0) {
        this.errorMessage = 'enter a valid amount, greater than zero'
        return
      }
      //console.log("amount is success")
      // TODO: Date must be at least a day in advance
      if ( isNaN(Date.parse(this.deadline)) || this.deadline <= new Date()) {
        this.errorMessage = 'deadline must be greater than now'
        return
      }
      
      // validate if the user has enough eth
      try{
        let canbuy = await this.convertUSDtoEther(amt)
        if(!canbuy) {
          this.errorMessage = 'not enough funds'
          return
        }
      }catch(err) {
        this.errorMessage = "Could not fetch price"
        return
        console.log("coincap: " + err)
      }
      this.errorMessage = ''

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
    async convertUSDtoEther(amount) {
      const url = "https://api.coinmarketcap.com/v1/ticker/ethereum/"
      try {
        let response = await axios.get(url)
        let ethPrice = response.data[0].price_usd
        let ethAmount = (amount / ethPrice).toFixed(2)
        console.log("ethAmt: " + ethAmount)
        let ethBalance = web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]),"ether").toString()
        console.log("ethBalance: " + ethBalance)
        if(parseFloat(ethBalance) > parseFloat(ethAmount)) {
          return true
        }else{
          return false
        }
        
      }catch(err) {
        console.log("error fetching eth price: " + err)
        throw err
      }

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