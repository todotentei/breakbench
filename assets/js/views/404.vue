<script>
  export default {
    name: '404',
    page: {
      title: '404',
      meta: [
        {
          name: 'description',
          content: '404',
        },
      ],
    },
    props: {
      resource: {
        type: String,
        default: '',
      },
    },
  }
</script>

<template>
  <h1>
    404
    <span v-if="resource">
      {{ resource }}
    </span>
    Not Found
  </h1>
</template>
