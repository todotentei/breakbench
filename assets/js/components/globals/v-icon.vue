<script>
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
  import { library } from '@fortawesome/fontawesome-svg-core';

  // https://fontawesome.com/icons
  library.add();

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
      customIconClass() {
        return 'icon-custom-' + this.name;
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
