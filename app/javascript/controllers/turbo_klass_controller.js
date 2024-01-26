import { Controller } from "@hotwired/stimulus"

// data-controller="turbo-klass"
// data-selector="html query selector"
// data-action="add|update|remove" //default is update
// data-klass="class to be update or insert or remove"
export default class extends Controller {
  connect() {
    const klass = this.element.dataset.klass;
    const action = this.element.dataset.action;

    document.querySelectorAll(this.element.dataset.selector)
            .forEach(target => this.handle(target, klass, action))

    this.element.remove();
  }

  handle(target, klass, action) {
    switch(action) {
      case 'add':
        addClass(target, klass);
        break;
      case 'remove':
        removeClass(target, klass);
        break;
      default:
        removeClass(target, target.classList.toString());
        addClass(target, klass);
        break;
    }
  } 
}
