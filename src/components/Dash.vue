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
        <span class="col-sm-1"> {{this.convertUSDtoEther(this.amount).toFixed(3)}} ETH </span>
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
    <br/><br/>
    <!-- Table Listing Here -->
    <table class="table table-bordred table-striped product-table col-sm-10">
      <tr>
        <th>Description</th> 
        <th>Stakes</th>
        <th>Recipient</th> 
        <th>Status</th> 
        <th>Delete</th>
      </tr>
      <tr v-for="(description,index) in descriptions" :key="description.id">
        <td>{{ convertAscii(descriptions[index]) }}</td>
        <td>{{ stakes[index] }}</td>
        <td>{{ recipients[index] }}</td>
        <td>{{ statusDescriptions[statuses[index]] }}</td>
        <td><b-button @click="deleteItem(index)" size="sm" variant="primary">Delete</b-button></td>
      </tr>
    </table>
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
import ucontract from 'truffle-contract'
import UsersContract from '@contracts/Users.json'

//import Users from '@/js/users'

export default {
  name: 'Dash',
  data () {
    return {
      msg: 'Hello',
      description: '',
      amount: '',
      deadline: '',
      instance: null,
      currentEthPrice:null,
      //formError: false,
      descriptions:[],
      stakes:[],
      statuses:[],
      recipients:[],
      errorMessage: '',
      statusDescriptions:["Proposed", "Active", "Finished", "Pending", "Verified"],
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
      let returnInstance = await commitContract.deployed()
      this.instance = returnInstance
      console.log("Commit contract initialized")
      //console.log(this.instance.getCommitmentList)
      this.getEthPrice()
      this.getCommitmentList()

    }catch(e) {
      alert("error getting contract. Did you do 'truffle migrate'?")
    }

    try {
      // get a list of application users
      //const user = await Users.init()
      //let data = await user.findAll()
      var userContract = ucontract(UsersContract)
      userContract.setProvider(window.web3.currentProvider)
      let userInstance = await userContract.deployed()
      
      //await userInstance.create(web3.utils('steve'),{from: web3.eth.accounts[1], gas: 2000000})
      
      const data = await userInstance.getUsers()
      
      let addresses = String(data[0]).split(',')
      let names = String(data[1]).split(',')
      console.log("addresses:" + addresses)
      let mappedNames = names.map(function(elem,idx,array) {
        return web3.toAscii(elem);
      });

      
      console.log("names:" + mappedNames)
       
    } catch (err) {
      console.log("error getting users:" + err)
    }
    // Listen for events
    // https://web3js.readthedocs.io/en/1.0/web3-eth-contract.html#id36
    // https://ethereum.stackexchange.com/questions/35997/how-to-listen-to-events-using-web3-v1-0
    // https://github.com/morrislaptop/vue-web3/blob/master/src/index.js

  },
  methods: {
    convertAscii (bytes32Address) {
      return window.web3.toAscii(bytes32Address)
    },
    convertToEther(wei) {
      return web3.fromWei(wei,"ether")
    },
    
    async getCommitmentList () {
      
      let data = await this.instance.getAllCommitments()
      this.descriptions = String(data[0]).split(',')
      this.stakes = String(data[1]).split(',')
      this.recipients = String(data[2]).split(',')
      this.statuses = String(data[3]).split(',')
      
      console.log(this.descriptions)
      console.log(this.stakes)
      //console.log(this.indexes)
      
    },
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
          {from: currentUser, gas: 2000000}
          )
        console.log(response)
        alert('success:')
      }catch(err) {
        alert("error")
        console.log(err)
      }

    },
    async getEthPrice() {
      const url = "https://api.coinmarketcap.com/v1/ticker/ethereum/"
      try {
        let response = await axios.get(url)
        this.currentEthPrice = response.data[0].price_usd
      }catch(err) {
        this.currentEthPrice = null
      }
    },
    convertUSDtoEther(dollarAmt) {
      return (dollarAmt/this.currentEthPrice)
    },
    async validateEthAmount(amount) {
      let ethAmount = convertUSDtoEther(amount)
      let ethBalance = web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]),"ether").toString()
      console.log("ethBalance: " + ethBalance)
      if(parseFloat(ethBalance) > parseFloat(ethAmount)) {
        return true
      }else{
        return false
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