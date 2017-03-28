<template>
  <div class="pingdom-widget">
    <h2>Pingdom</h2>

    <div v-for="site in data" v-bind:class="[site.status == 'up' ? 'success' : 'alert', 'callout']">
        {{ site.hostname }}
        <span v-bind:class="['label', site.lastresponsetime <= 500 ? 'success' : 'alert']">
            {{ site.lastresponsetime }}ms
        </span>
    </div>

  </div>
</template>

<script>
export default {
  
  props: ['data']

}
</script>
