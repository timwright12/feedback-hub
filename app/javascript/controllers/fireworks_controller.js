import {Controller} from "@hotwired/stimulus"
import confetti from "canvas-confetti"

export default class extends Controller {

  static targets = ['row']
  static values = {
    duration: {type: Number, default: 3000}
  }

  createShow() {
    if (this.canvas == undefined) this._createCanvas()

    let canvas = this.canvas
    this.confetti = confetti.create(canvas, {resize: true})

    // Start the show
    this._startShow()

    // Stop the show
    setInterval(this._stopShow.bind(this), this.durationValue)
  }

  _startShow() {
    this.show = setInterval(this._firework.bind(this), 250)
  }

  _stopShow() {
    clearInterval(this.show)
  }

  _firework() {
    let duration = 15 * 1000
    let animationEnd = Date.now() + duration
    let defaults = {startVelocity: 30, spread: 360, ticks: 60, zIndex: 0}

    var timeLeft = animationEnd - Date.now()

    var particleCount = 50 * (timeLeft / duration)
    // since particles fall down, start a bit higher than random
    this.confetti(Object.assign({}, defaults, {
      particleCount,
      origin: {x: this._randomInRange(0.1, 0.3), y: Math.random() - 0.2}
    }))

    this.confetti(Object.assign({}, defaults, {
      particleCount,
      origin: {x: this._randomInRange(0.7, 0.9), y: Math.random() - 0.2}
    }))
  }

  _randomInRange(min, max) {
    return Math.random() * (max - min) + min
  }

  _createCanvas() {
    document.body.insertAdjacentHTML('beforeend', '<canvas id="confetti" class="fixed inset-0 w-full h-full pointer-events-none z-50"></canvas>')
  }

  get canvas() {
    return document.querySelector("#confetti")
  }
}
