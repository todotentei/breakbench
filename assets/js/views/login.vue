<script>
  import appConfig from '@js/breakbench.config';
  import session from '@js/api/session';

  import Layout from '@js/layouts/index';
  import FormGroup from '@js/components/form-group';

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
    components: {
      Layout,
      FormGroup,
    },
    data() {
      return {
        model: {
          username_or_email: '',
          password: '',
        }
      };
    },
    computed: {
      flash() {
        return this.$store.state.flash;
      },
    },
    methods: {
      onSubmit() {
        session.login(this.model)
          .then(data => {
            const toPath = { name: 'home' };

            this.$store.dispatch('flash/success', data.message);
            this.$router.push(toPath);
          }, err => {
            this.$store.dispatch('flash/danger', err.message);
          })
      },
    },
  }
</script>

<template>
  <layout>
    <v-container class="login-page">
      <v-container class="login-page__box">
        <h2 class="text-center">Log into Breakbench</h2>
        <div class="margin-top-40">
          <v-flash
            v-if="flash.message"
            class="login-page__flash"
            :class="flash.type"
          >
            {{ flash.message }}
          </v-flash>
          <form @submit.prevent="onSubmit">
            <form-group>
              <label class="text-bold">Username or email address</label>
              <v-input
                v-model="model.username_or_email"
                name="username_or_email"
              />
            </form-group>
            <form-group>
              <label class="text-bold">Password</label>
              <v-input
                v-model="model.password"
                name="password"
              />
            </form-group>
            <v-button class="button-primary">Log in</v-button>
          </form>
        </div>
      </v-container>
    </v-container>
  </layout>
</template>
