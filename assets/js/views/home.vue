<script>
  import appConfig from '@js/breakbench.config';

  export default {
    name: 'home',
    page: {
      title: 'Home',
      meta: [
        {
          name: 'description',
          content: appConfig.description,
        },
      ],
    },
  }
</script>

<template>
  <h1>Home Page</h1>
</template>
