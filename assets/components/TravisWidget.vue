<template>
  <div class="travis">
    <h2>Travis</h2>

    <div v-for="repo in data" :class="['media-object', repo.state == 'passed' ? 'success' : 'alert' ]">
        <div class="media-object-section">
            <div class="thumbnail">
                <img :src="repo.author.avatar_url">
            </div>
        </div>
        <div class="media-object-section main-section">
            <h5>{{ repo.slug }}</h5>
            <p>{{ repo.author.name }}</p>
        </div>
    </div>

  </div>
</template>

<script>
export default {
  props: ['data']
}
</script>
