<template>
<div class="check-grid">
  <check
    v-for="check in checks"
    :key="check.id"
    :check="check"
    class="check">
  </check>
</div>
</template>

<script>
import _ from 'lodash';
import { Socket } from 'phoenix';
import Check from './components/check.vue';

export default {
  name: 'application',

  components: {
    check: Check
  },

  data() {
    return {
      error: null,
      channel: null,
      checks: []
    }
  },

  methods: {
    setChecks(checks) {
      this.checks = checks;
    },

    updateCheck(check) {
      const idx = this.checks.findIndex(({ id }) => id === check.id);

      if (idx !== -1) {
        this.$set(this.checks, idx, check);
      }
    }
  },

  beforeMount() {
    const socket = new Socket("/socket");
    const channel = socket.channel("metrics:updates");

    this.channel = channel;

    socket.connect();
    channel.join()
      .receive("error", ({ reason }) => {
        if (typeof reason === 'string') {
          this.data.error = reason;
        } else {
          this.data.error = reason.toString();
        }
      });

    channel.on("all", ({ checks }) => this.setChecks(checks));
    channel.on("update", this.updateCheck.bind(this));
  }
};
</script>

<style lang="scss">
@import '~styles/variables';
@import '~bulma';

body {
  width: 100vw;
  min-height: 100vh;
  background: $background;
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
}

.check-grid {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
}

.check {
  width: calc(100% / 6);
  padding: 0.2em 0.8em;
}
</style>
