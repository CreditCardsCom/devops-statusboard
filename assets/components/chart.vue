<script>
import ChartJS from 'vue-chartjs';

export default {
  extends: ChartJS.Line,
  name: 'chart',
  props: ['labels', 'responseTimes'],

  data() {
    return {
      latencyBackgroundColor: '#063b5b'
    };
  },

  mounted() {
    const data = this.responseTimes;

    this.renderChart({
      labels: this.labels,
      datasets: [
        {
          data,
          label: 'Average Response Time',
          backgroundColor: this.latencyBackgroundColor
        }
      ]
    },
    {
      legend: false,
      responsive: true,
      maintainAspectRatio: true,
      responsiveAnimationDuration: 0,

      animation: {
        duration: 100
      },

      elements: {
        point: {
          radius: 2
        }
      },

      scales: {
        xAxes: [
          {
            ticks: {
              fontSize: 10
            }
          }
        ]
      }
    });
  }
};
</script>
