import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.location = this.element.dataset.url;

    if (window.location.hash) { window.location.reload(true) }
  }
}
