<!--component to render lists of key/value pairs, including nested list values-->

<template>
  <v-card style="margin: 10px; border-radius: 5px;">
    <!-- credit: https://pixabay.com/en/mesh-background-triangles-green-1409121/-->
    <v-card-media class="white--text u-align-right card-header"
                  height="100px"
                  src="/vue/static/mesh-1409121_1280.png"
    >
      <v-container fill-height fluid>
        <v-layout fill-height>
          <v-flex xs12 align-end flexbox>
            <span class="display-1"><slot name="header"></slot></span>
          </v-flex>
        </v-layout>
      </v-container>
    </v-card-media>


    <v-card-title primary-title>
      <!--<h3 class="headline mb-0">Headline</h3>-->
      <!--<div>description...</div>-->
      <slot></slot>
    </v-card-title>
  </v-card>
</template>

<script>

export default {
  name: 'CardWithHeader',
};
</script>

<style lang="scss" scoped>
  .card-header {
    background-color: #4c624a;
  }

</style>


