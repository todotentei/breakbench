import Vue from 'vue';
import VueRouter from 'vue-router';
import VueMeta from 'vue-meta'
// Adds a loading bar at the top during page loads
import NProgress from 'nprogress/nprogress';
import store from '@state/store';
import routes from './routes';

Vue.use(VueRouter);
Vue.use(VueMeta, {
  // The component option name that vue-meta looks for meta info on.
  keyName: 'page',
});

const router = new VueRouter({
  routes,
  // Use the HTML5 history API (i.e., normal-looking routes)
  // instead of routes with hashes (e.g., example.com/#/about).
  // This may require some server configuration in production:
  // https://router.vuejs.org/en/essentials/history-mode.html#example-server-configurations
  mode: 'history',
  // Simulate native-like scroll behaviour when navigating to a new
  // route and using back/forward buttons.
  scrollBehaviour(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else {
      return { x: 0, y: 0 };
    }
  },
});

// // Before each route evaluates...
// router.beforeEach((routeTo, routeFrom, next) => {
//   // If this isn't an initial page load...
//   if (routeFrom.name) {
//     // Start the route progress bar.
//     NProgress.start();
//   }
// });
//
// // When each route is finished evaluating...
// router.afterEach((routeTo, routeFrom) => {
//   // Complete the animation of the route progress bar.
//   NProgress.done();
// });

export default router;
