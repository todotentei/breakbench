<script>
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
  import { library } from '@fortawesome/fontawesome-svg-core';
  import camelCase from 'lodash/camelCase';

  // https://fontawesome.com/icons
  library.add(
    require('@fortawesome/free-solid-svg-icons/faSync').definition,
  );

  export default {
    components: {
      FontAwesomeIcon,
    },
    props: {
      source: {
        type: String,
        default: 'font-awesome',
      },
      name: {
        type: String,
        required: true,
      },
    },
    computed: {
      // Gets a CSS module class, e.g., iconCustomLogo
      customIconClass() {
        return this.$style[camelCase('icon-custom-' + this.name)]
      },
    },
  }
</script>

<template>
  <FontAwesomeIcon
    v-if="source === 'font-awesome'"
    :icon="name"
    v-bind="$attrs"
  />
  <span
    v-else-if="source === 'custom'"
    :class="customIconClass"
  />
</template>
