import {Controller} from "@hotwired/stimulus"
import {enter, leave, toggle} from "../libraries/el-transition"

export default class extends Controller {
  static targets = ['listener']

  enter() {
    this.listenerTargets.forEach((element) => {
      enter(element, null)
    })
  }

  leave() {
    this.listenerTargets.forEach((element) => {
      leave(element, null)
    })
  }

  toggle() {
    this.listenerTargets.forEach((element) => {
      toggle(element, null)
    })
  }
}