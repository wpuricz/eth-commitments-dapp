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

export default {
  name: 'Dash',
  data () {
    return {
      msg: 'Hello',
      description: '',
      amount: '',
      deadline: ''
    }
  },
  methods: {
    addCommitment () {
      if (this.description === '') {
        alert('error')
        return
      }
      if (this.amount < 1) {
        alert('error')
        return
      }
      if (this.deadline <= new Date()) {
        alert('error')
        return
      }
      alert('hello')
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