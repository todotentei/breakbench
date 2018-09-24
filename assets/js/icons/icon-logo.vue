<script>
  import IconMixin from '@js/mixins/icon';

  export default {
    mixins: [IconMixin],
  };
</script>

<template>
  <svg
    class="icon icon-logo"
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 25.4 31.13"
    :width="defaultWidth"
    :height="defaultHeight"
  >
    <title>Logo</title>
    <polygon
      class="icon-logo__top"
      points="0 0 25.41 22 25.41 0 0 0"
    />
    <path
      class="icon-logo__bottom"
      d="M8.4,23.85,0,31.13H25.4V23.85L8.4,9.13Z"
    />
  </svg>
</template>
