import VueApollo from 'vue-apollo';
import ApolloClient from 'apollo-boost';

const defaultClient = new ApolloClient();

const apolloProvider = new VueApollo({
  defaultClient
});

export default apolloProvider;
