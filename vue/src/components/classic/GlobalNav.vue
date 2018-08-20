<template>
  <nav class="global-nav">
    <template v-if="globalNav">
      <ul class="primary-nav">
        <li v-for="item in globalNav.primary" v-bind:class="['nav-item', item.active ? 'nav-active' : '']">
          <LegacyIcon :link="item.link" :label="item.label" :icon="item.icon"></LegacyIcon>
        </li>
      </ul>
      <ul class="secondary-nav">
        <li v-for="item in globalNav.secondary" class="nav-item">
          <LegacyIcon :link="item.link" :label="item.label" :icon="item.icon" :active="item.active"></LegacyIcon>
        </li>
      </ul>
    </template>
  </nav>
</template>

<script>
import { mapGetters } from 'vuex';
import LegacyIcon from '@/components/classic/LegacyIcon';

export default {
  name: 'global-nav',
  components: {
    LegacyIcon,
  },
  computed: {
    ...mapGetters([
      'globalNav',
    ]),
    showNav() {
      return this.globalNav && !this.isDev;
    },
  },
};
</script>

<style lang="scss">

/* below styles are copied post-processed from elysium rails app, non-ideal but limited to this global nav component */

/* line 70, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-label {
  color: white;
  font-weight: 600;
  pointer-events: none;
  font-size: 0.8125em;
  line-height: 1.875em;
  padding: 3px 12px 1px;
  position: absolute;
  top: 1.875em;
  left: 60px;
  transition: all .2s ease;
  background-color: rgba(96, 112, 144, 0.95);
  opacity: 0;
  z-index: 4;
  -webkit-transform: translateX(-5px);
  border-radius: 3px;
  white-space: nowrap;
}
/* line 88, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-label:before {
  content: "";
  position: absolute;
  top: 0;
  left: -4px;
  border-top: 4px solid transparent;
  border-bottom: 4px solid transparent;
  border-right: 4px solid rgba(96, 112, 144, 0.95);
  margin-top: -4px;
  top: 50%;
}
/* line 102, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-active {
  pointer-events: none;
}

/* line 108, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-active .nav-icon, .nav-active-clickable .nav-icon {
  opacity: 1;
  background-color: #b3d1ff;
}
/* line 113, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-active:after, .nav-active-clickable:after {
  border-top: 4px solid transparent;
  border-bottom: 4px solid transparent;
  border-right: 4px solid #f9fafb;
  margin-top: -4px;
  content: "";
  position: absolute;
  right: 0;
  top: 50%;
}

/* line 39, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/icons/_mask_sprites.css.scss */
.icon-catalog {
  -webkit-mask-position: 0 -275px;
  height: 36px;
  width: 36px;
}

/* line 39, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/icons/_mask_sprites.css.scss */
.icon-cutlery {
  -webkit-mask-position: 0 -363px;
  height: 36px;
  width: 36px;
}

/* line 39, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/icons/_mask_sprites.css.scss */
.icon-imp {
  -webkit-mask-position: 0 -879px;
  height: 36px;
  width: 36px;
}

/* line 39, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/icons/_mask_sprites.css.scss */
.icon-ip {
  -webkit-mask-position: 0 -915px;
  height: 36px;
  width: 36px;
}

/* line 39, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/icons/_mask_sprites.css.scss */
.icon-logout {
  -webkit-mask-position: 0 -977px;
  height: 36px;
  width: 36px;
}

/* line 39, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/icons/_mask_sprites.css.scss */
.icon-pricing {
  -webkit-mask-position: 0 -1062px;
  height: 36px;
  width: 36px;
}


/* line 15, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/icons/icons.css.scss */
.nav-icon {
  -webkit-mask-image: url(/assets/icons-s8575d2af02-02ace7a3ac8dbd7538582ece302f09c97cf7f864d50558575c321ad877a5636e.png);
  -webkit-mask-repeat: no-repeat;
  background-color: #666;
  display: inline-block;
}

/* line 8, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.global-nav {
  display: flex;
  justify-content: space-between;
}

.global-nav {
  width: 70px;
  margin: 0;
  background-color: #2d3443;
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  flex-direction: column;
  font-family: "ProximaNova", "HelveticaNeue", Helvetica, Arial, sans-serif;
  z-index: 999;
  box-shadow: -1px 0 0 black;
}
/* line 22, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.global-nav ul:last-child {
  margin-bottom: 0;
}

/* line 27, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-item {
  position: relative;
  width: 100%;
  cursor: pointer;
  display: block;
  padding: 1.375em 0;
  -webkit-transition: background .2s ease;
}
/* line 35, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.05);
}
/* line 38, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-item:hover .nav-icon {
  background-color: #b3d1ff;
}
/* line 42, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-item:hover .nav-label {
  opacity: 1;
  -webkit-transform: translateX(0px);
}
/* line 50, /Volumes/Work/dev/elysium/rails/app/assets/stylesheets/modules/global_nav.css.scss */
.nav-item a {
  display: block;
  line-height: 0.75em;
  transition: all .2s ease;
  align-self: flex-start;
}

.nav-item:hover .nav-icon {
  background-color: #b3d1ff;
}

.nav-icon {
  background-color: #52667a;
  -webkit-transition: background .2s ease;
  width: 36px;
  height: 36px;
  margin: 0 auto;
  display: block;
}

.nav-active .nav-icon, .nav-active-clickable .nav-icon {
  opacity: 1;
  background-color: #b3d1ff;
}
</style>

