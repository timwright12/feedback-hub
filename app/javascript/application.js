import "@hotwired/turbo-rails"
import "chartkick/chart.js"
import "flatpickr"
import "tailwindcss-stimulus-components"
import "./controllers/application"
import "./components/index"

document.addEventListener('turbo:loaded', function() {
  document.dispatchEvent(new Event('DOMContentLoaded'))
})