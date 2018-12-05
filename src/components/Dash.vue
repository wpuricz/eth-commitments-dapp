<template>
  <div class="Dash">
    Hello  {{msg}}

  </div>
</template>


<script>

export default {
  name: 'Dash',
  data () {
    return {
      msg: 'Hello'
    }
  },
  methods: {

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