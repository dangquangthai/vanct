import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    makeSortable(this.element)
  }
}
