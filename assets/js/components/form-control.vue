<script>
  import kebabCase from 'lodash/kebabCase';

  export default {
    props: {
      state: [Object, String],
      value: String,
    },
    computed: {
      stateToClass() {
        const _state = this.defineState(this.state);
        return kebabCase('form-control-' + _state);
      },
    },
    methods: {
      defineState(state) {
        switch (typeof state) {
          case 'object':
            const keys = Object.keys(state);
            return keys.filter((k) => state[k]);
          default:
            return state;
        }
      },
    },
  }
</script>

<template>
  <input
    class="form-control"
    v-bind:class="stateToClass"
    v-bind:value="value"
    v-on:input="$emit('input', $event.target.value)"
  />
</template>
