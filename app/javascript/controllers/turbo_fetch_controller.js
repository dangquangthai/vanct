import { Controller } from "@hotwired/stimulus"

//data-url="/load-data-url"
//data-auto-load="true"
//data-method="GET|POST|PATCH|PUT|DELETE"
//data-payload="JSON.stringify({...})"
export default class extends Controller {
  initialize() {
    this.fetch = this.fetch.bind(this);
    this.removeClickEvent = this.removeClickEvent.bind(this);
    this.addClickEvent = this.addClickEvent.bind(this);
  }

  connect() {
    this.payload = this.element.dataset.payload;
    this.method = this.element.dataset.method || 'GET';
    this.url = this.element.dataset.url;
    this.autoLoad = !!this.element.dataset.autoLoad;

    if (this.autoLoad) {
      this.fetch();
    }

    this.addClickEvent();
  }

  disconnect() {
    this.removeClickEvent();
  }

  removeClickEvent() {
    addClass(this.element, 'cursor-progress');
    this.element.removeEventListener('click', this.fetch);
  }

  addClickEvent() {
    removeClass(this.element, 'cursor-progress');
    this.element.addEventListener('click', this.fetch);
  }

  fetch() {
    this.removeClickEvent();
    turboFetch(this.url, {
      method: this.method, 
      payload: this.payload,
      callback: this.addClickEvent
    });
  }
}
