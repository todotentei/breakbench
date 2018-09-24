<script>
  export default {
    props: {
      size: {
        type: String,
        default: 'regular',
      },
    },
    data() {
      return {
        defaultSizes: {
          small: '24px',
          regular: '32px',
          large: '48px',
        },
      };
    },
    computed: {
      defaultSize() {
        const { defaultSizes, size } = this;
        return defaultSizes[size];
      },
      defaultWidth() {
        const { width } = this.$attrs;
        return width || this.defaultSize;
      },
      defaultHeight() {
        const { height } = this.$attrs;
        return height || this.defaultSize;
      },
    },
  };
</script>
