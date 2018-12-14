<template>
  <section id='signup'>
    <h1>Sign up</h1>
    <div class="form">
      <div class="entry">
        <button @click="signup" name="signup">Sign up</button>
        <input name="pseudo" v-model="form.pseudo">
        <label for="pseudo">Pseudo</label>
      </div>
    </div>
  </section>
</template>

<script>
  import Users from '@/js/users'

  export default {
    name: 'signup',
    data () {
      return {
        form: {
          pseudo: undefined
        }
      }
    },
    created: async function () {
      window.web3.eth.defaultAccount = window.web3.eth.accounts[0]
      let instance = await Users.init()
      console.log("users contract initialized")
      
      if(await Users.exists(web3.eth.defaultAccount)) {
        this.$router.push('/dash')
      }
      
    },
    
    
    methods: {
      signup: function () {
        let self = this
        if (typeof this.form.pseudo !== 'undefined' && this.form.pseudo !== '') {
          
          Users.create(this.form.pseudo).then(tx => {
            console.log(tx)
            self.$router.push('/dash')
          }).catch(err => {
            alert(err)
            console.log(err)
          })
        }
      }
    }
  }
</script>

<style lang="scss" scoped>

  #signup {
    text-align: center;
    
    .form {
      display: flex;
      flex-direction: column;
      margin: auto;
      
      .entry {
        display: flex;
        flex-direction: row-reverse;
        justify-content: center;
        
        label {
          margin-right: 20px
        }
        
        button {
          margin-left: 20px
        }  
        
      }
        
    }
    
  }

</style>
