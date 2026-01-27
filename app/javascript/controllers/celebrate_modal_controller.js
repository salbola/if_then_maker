import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="celebrate-modal"
export default class extends Controller {
  close() {
    this.element.remove()
  }
}
