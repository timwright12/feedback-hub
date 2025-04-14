import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ['current', 'notCurrent']
  static values = {
    path: String
  }

  connect() {
    this.element.classList.remove(...this.currentClasses)
    if (this.pathValue == document.location.pathname) {
      this.element.classList.remove(...this.notCurrentClasses)
      this.element.classList.add(...this.currentClasses)
    }
  }
}
