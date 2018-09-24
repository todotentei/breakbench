<script>
  import Header from '@js/layouts/header';

  export default {
    components: {
      Header,
    },
  };
</script>

<template>
  <div>
    <Header />
    <slot />
  </div>
</template>
