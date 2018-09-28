<script>
  const permitted = [
    'checkbox',
    'radio'
  ];

  export default {
    inheritAttrs: false,
    props: {
      label: String,
      type: {
        type: String,
        default: 'checkbox',
        validator(value) {
          return permitted.indexOf(value) !== -1
        },
      },
    }
  }
</script>

<template>
  <div class="form-check">
    <input
      :type="type"
      v-bind="$attrs"
    />
    <label>{{ label }}</label>
  </div>
</template>
