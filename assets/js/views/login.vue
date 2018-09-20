<script>
  import appConfig from '@js/breakbench.config';

  export default {
    name: 'login',
    page: () => ({
      title: 'Login',
      meta: [
        {
          name: 'description',
          content: `Log into ${appConfig.title}`
        },
      ],
    }),
  }
</script>

<template>
  <h1>Login Page</h1>
</template>
