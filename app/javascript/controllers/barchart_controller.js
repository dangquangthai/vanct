import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ['myChart', 'wrapper'];

  connect() {
    const chartData = JSON.parse(this.element.dataset.chartData);
    const maxWidth = 1000;
    const count = chartData.labels.length;
    
    if (count < 10) {
      this.myChartTarget.removeAttribute('width');
      this.myChartTarget.removeAttribute('height');
    } else {
      this.myChartTarget.width = count * 50;
    }

    new Chart(this.canvasContext, {
      type: 'bar',
      data: chartData,
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        },
        plugins: {
          legend: {
            display: false
          }
        }
      }
    });
  }

  get canvasContext() {
    return this.myChartTarget.getContext('2d');
  }
}
