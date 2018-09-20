<script>
  import appConfig from '@js/breakbench.config';

  export default {
    name: 'breakbench',
    page: () => ({
      titleTemplate: (title) => {
        title = typeof title === 'function'
          ? title(this.$store)
          : title;

        return title
          ? `${title} | ${appConfig.title}`
          : appConfig.title;
      },
      htmlAttrs: {
        lang: 'en',
      },
      __dangerouslyDisableSanitizers: [
        'script'
      ],
    }),
  }
</script>

<template>
  <div id="app">
    <!--
    Even when routes use the same component, treat them
    as distinct and create the component again.
    -->
    <router-view :key='$route.fullPath' />
  </div>
</template>
