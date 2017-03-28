<template>
  <div class="status-page">
    <h2>Status Page</h2>

    <div v-for="component in data" v-bind:class="[component.status == 'operational' ? 'success' : 'alert', 'callout']">
        <h5>{{ component.name }}</h5>
    </div>

  </div>
</template>

<script>
export default {
  props: ['data']
}
</script>
