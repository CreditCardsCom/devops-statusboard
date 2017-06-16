<template>
  <div>
    MEH!!!
  </div>
</template>

<script>
import { Socket } from 'phoenix';

export default {
  name: 'application',

  data() {
    return {};
  },

  mounted() {
    const socket = new Socket("/socket");
    const channel = socket.channel("metrics:lobby");

    socket.connect();
    channel.join();
  }
};
</script>

<style scoped lang="scss">
@import '~styles/variables';

div {
  background: blue;
}
</style>
