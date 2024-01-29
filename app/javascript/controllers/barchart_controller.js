import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ['myChart', 'wrapper'];

  connect() {
    const chartData = JSON.parse(this.element.dataset.chartData);

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
