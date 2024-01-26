import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (!this.overlay) {
      const overlay = document.createElement('div');
      overlay.id = 'turbo-modal-overlay';
      addClass(overlay, 'bg-black opacity-20 inset-0 h-screen w-screen fixed flex items-center justify-center z-10');
      this.turboModal.insertAdjacentElement('beforebegin', overlay);
    }
      
    addClass(this.turboModal, 'inset-0 h-screen w-screen fixed flex items-center justify-center z-20');
  }

  disconnect() {
    if (this.overlay) {
      this.overlay.remove();
    }
  }

  close() {
    if (this.overlay) {
      this.overlay.remove();
    }

    removeClass(this.turboModal, 'inset-0 h-screen w-screen fixed flex items-center justify-center z-20');
    this.element.remove();
  }

  get overlay() {
    return document.querySelector('#turbo-modal-overlay');
  }

  get turboModal() {
    return document.querySelector('#turbo-modal');
  }
}
