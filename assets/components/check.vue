<template>
  <section>
    <header>
      <h1>{{ check.name }}</h1>
    </header>

    <chart
      :labels="chartLabels"
      :response-times="responseTimes">
    </chart>
  </section>
</template>

<script>
import Chart from './chart.vue';
import Moment from 'moment';

export default {
  name: 'check',
  props: ['check'],

  components: {
    chart: Chart
  },

  computed: {
    chartLabels() {
      return this.check.metrics.map(({ time }) => {
        let moment = Moment.unix(time);

        return moment.fromNow();
      });
    },

    responseTimes() {
      return this.check.metrics.map(({ value }) => value);
    }
  }
};
</script>

<style scoped lang="scss">
@import '~styles/variables';

h1 {
  margin: 0 0 0.4em 0;
  font-size: 0.8em;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  color: #ddd;
  font-weight: bold;
}
</style>
