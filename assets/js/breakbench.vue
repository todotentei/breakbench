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
          ? `${title} - ${appConfig.title}`
          : appConfig.title;
      },
      htmlAttrs: {
        lang: 'en',
      },
      __dangerouslyDisableSanitizers: [
        'script'
      ],
    }),
    watch: {
      $route(to, from) {
        // Clear flash on location change
        this.$store.dispatch('flash/clear');
      },
    },
  }
</script>

<template>
  <div id="vue-app">
    <!--
    Even when routes use the same component, treat them
    as distinct and create the component again.
    -->
    <router-view :key='$route.fullPath' />
  </div>
</template>
