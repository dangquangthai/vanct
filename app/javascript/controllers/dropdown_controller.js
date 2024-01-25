import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ['dropdown']

  connect() {
    useClickOutside(this)
  }

  onClick() {
    show(this.dropdownTarget)
  }

  clickOutside() {
    hide(this.dropdownTarget)
  }
}
