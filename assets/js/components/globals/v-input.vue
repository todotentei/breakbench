<script>
  export default {
    props: {
      classname: String,
      type: {
        type: String,
        default: 'text',
      },
      value: {
        type: [String, Number],
        default: '',
      },
    },
    computed: {
      listeners() {
        return {
          ...this.$listeners,
          input: (event) => this.$emit('input', event.target.value),
        };
      },
    }
  }
</script>

<template>
  <input
    class="form-control"
    :type="type"
    :value="value"
    :class="classname"
    v-on="listeners"
  />
</template>
