<script>
  import appConfig from '@js/breakbench.config';

  import Layout from '@js/layouts/index';
  import FormGroup from '@js/components/form-group';

  export default {
    name: 'register',
    page: {
      title: 'Register',
      meta: [
        {
          name: 'description',
          content: `Join ${appConfig.title}`,
        },
      ],
    },
    components: {
      Layout,
      FormGroup,
    },
    data() {
      return {
        registerState: {},
        model: {
          username: '',
          firstname: '',
          lastname: '',
          email: '',
          password: '',
        }
      };
    },
  }
</script>

<template>
  <layout>
    <v-container class="register-page">
      <v-container class="register-form">
        <h1 class="text-center">Join Breakbench</h1>
        <div>
          <vue-form
            :state="registerState"
            @submit.prevent="onSubmit"
          >
            <form-group>
              <validate>
                <v-input
                  v-model="model.username"
                  name="username"
                  placeholder="Username"
                />
              </validate>
            </form-group>
          </vue-form>
        </div>
      </v-container>
    </v-container>
  </layout>
</template>
