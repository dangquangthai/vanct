import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(this.refresh.bind(this), 1000 * 60);
  }

  refresh() {
    turboFetch('/');
  }

  showTable(event) {
    turboFetch(`/dashboard/show?table_no=${event.currentTarget.dataset.tableNo}`);
  }
}
