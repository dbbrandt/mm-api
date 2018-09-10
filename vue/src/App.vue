<template>
  <div id="app">
    <v-app>
      <v-content>
        <div class="vue-app-content">
          <div class="nav">
            <a href="/">Memory Maestro</a> /
            <template v-if="$route.name !== homeRoute">
              <router-link to="/goals">{{homeRoute}}</router-link> /
            </template>
            {{$route.name}}
          </div>
          <div class="nav-right">
            <template v-if='isPowerUser'>
              <a href="/admin" target="_blank">Admin</a> |
            </template>
            <span v-if="user" :title="user.roles">{{user.name}}</span>
          </div>
          <br style="clear: both">
          <img src="./assets/Precidix_Logo__300x300.png" class="application-logo">
          <!--https://www.dreamstime.com/stock-illustration-ganesha-elephant-handyman-tools-drawing-sketch-style-illustration-holding-viewed-front-set-isolated-white-background-image75792184-->
          <router-view></router-view>
        </div>
      </v-content>
    </v-app>
  </div>
</template>
<script>
import GlobalNav from '@/components/classic/GlobalNav';
import { mapGetters } from 'vuex';

export default {
  name: 'app',
  components: {
    GlobalNav,
  },
  computed: {
    ...mapGetters(['user', 'isPowerUser']),
    isDev() {
      return process.env.NODE_ENV === 'development';
    },
  },
  data() {
    return {
      homeRoute: 'Goals',
    };
  },
  mounted() {
    this.$store.dispatch('refreshBootstrap');
  },
};
</script>

<style lang="scss">

@import "~@/scss/global";

#app {
  @include font-standard();
  text-align: center;
}

.nav {
  float: left;
  margin-left: 5px;
  text-align: left;
  display: block;
}

.nav-right {
  float: right;
  margin-right: 5px;
  text-align: left;
  display: block;
}

@media only screen
and (min-device-width : 375px)
and (max-device-width : 812px)
and (-webkit-device-pixel-ratio : 3) {
  .nav-right {
    float: left;
    margin-right: 5px;
    text-align: left;
    display: block;
  }
}

.application-logo {
  position: absolute;
  bottom: 5px;
  right: 0px;
  opacity: 0.3;
  height: 100px;
}

.vue-app-content {
  margin-left: 70px;
  padding-left: 5px;
}
</style>
