<script>
  import kebabCase from 'lodash/kebabCase'

  export default {
    props: {
      state: {
        state: String,
        default: 'primary',
      },
    },
    computed: {
      stateToClass() {
        return kebabCase('form-feedback-' + this.state);
      },
    },
  }
</script>

<template>
  <div
    class='form-feedback'
    :class="stateToClass"
  >
    <slot />
  </div>
</template>
