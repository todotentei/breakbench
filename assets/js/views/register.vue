<script>
  import appConfig from '@js/breakbench.config';
  import gql from 'graphql-tag';
  import debounce from 'lodash/debounce';

  import Layout from '@js/layouts/index';
  import FormGroup from '@js/components/form-group';
  import FormControl from '@js/components/form-control';
  import FormCheck from '@js/components/form-check';
  import FormFeedback from '@js/components/form-feedback';

  const validations = {
    username: {
      required: true,
      regex: /^[A-Za-z0-9_]*$/,
      length: [4, 16],
    },
    fullname: {
      required: true,
    },
    email: {
      required: true,
      email: true,
    },
    password: {
      required: true,
      min: 8,
    },
  };

  const customDictionary = {
    en: {
      custom: {
        username: {
          regex: 'Username be composed only with letters, numbers, and underscore',
          length: 'Username must be between 4 to 16 characters',
        },
        password: {
          min: 'Password must be 8 characters or more',
        },
      },
    },
  };

  export default {
    name: 'register',
    page: {
      title: 'Join',
      meta: [
        {
          name: 'description',
          content: `Join ${appConfig.title}`,
        },
      ],
    },
    apollo: {
      $skip: true,
      hasUsername: {
        debounce: 300,
        query: gql`
          query ($username: String!) {
            hasUser(username: $username)
          }
        `,
        variables() {
          return {
            username: this.user.username
          };
        },
        skip() {
          return this.errors.any() || !this.user.username;
        },
        update: (data) => data,
        result({ data, loading }) {
          if (!loading && data.hasUser) {
            this.errors.add({
              field: 'username',
              msg: 'Username is already taken'
            });
          }
        },
        error(error) {
          console.error(error);
        }
      }
    },
    created() {
      this.$validator.localize(customDictionary);
    },
    components: {
      Layout,
      FormGroup,
      FormControl,
      FormCheck,
      FormFeedback,
    },
    data() {
      return {
        validations,
        user: {
          username: '',
          fullname: '',
          email: '',
          password: '',
        }
      };
    },
    methods: {
      handleSubmit() {
        this.$validator.validateAll()
          .then((valid) => {
            if (valid) {
              user.register(this.model)
                .then(data => {
                  console.log(data);
                }, err => {
                  this.$store.dispatch('flash/danger', err.message);
                });
            }
          });
      },
    },
  }
</script>

<template>
  <layout>
    <v-container class="register-page">
      <v-container class="register-form">
        <h1 class="text-center">Join Breakbench</h1>
        <div>
          <form @submit.prevent="handleSubmit">
            <form-group>
              <form-control
                type="text"
                name="username"
                data-vv-name="username"
                v-model="user.username"
                v-validate="validations.username"
                placeholder="Username"
                v-bind:state="{danger: errors.has('username')}"
                v-on:input="$emit('input', $event)"
              />
              <form-feedback state="danger">
                {{ errors.first('username') }}
              </form-feedback>
            </form-group>
            <form-group>
              <form-control
                type="text"
                name="fullname"
                v-model="user.fullname"
                v-validate="validations.fullname"
                placeholder="Full name"
                v-bind:state="{danger: errors.has('fullname')}"
              />
              <form-feedback state="danger">
                {{ errors.first('fullname') }}
              </form-feedback>
            </form-group>
            <form-group>
              <form-control
                type="email"
                name="email"
                v-model="user.email"
                v-validate="validations.email"
                placeholder="Email address"
                v-bind:state="{danger: errors.has('email')}"
              />
              <form-feedback state="danger">
                {{ errors.first('email') }}
              </form-feedback>
            </form-group>
            <form-group>
              <form-control
                type="password"
                name="password"
                v-model="user.password"
                v-validate="validations.password"
                placeholder="Password"
                v-bind:state="{danger: errors.has('password')}"
              />
              <form-feedback state="danger">
                {{ errors.first('password') }}
              </form-feedback>
            </form-group>
            <form-group>
              <form-check
                label="I am 18 years or older and I agree to the terms and conditions"
                type="checkbox"
              />
            </form-group>
            <v-button class="button-primary">Log in</v-button>
          </form>
        </div>
      </v-container>
    </v-container>
  </layout>
</template>
