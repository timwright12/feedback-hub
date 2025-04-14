import Flatpickr from "stimulus-flatpickr"

export default class extends Flatpickr {
  static targets = ['start', 'end']

  static values = {
    submitForm: Boolean
  }

  change(selectedDates, dateStr, instance) {
    let dates = dateStr.split(' to ')

    if (this.hasStartTarget && this.hasEndTarget) {
      this.startTarget.value = dates[0]
      this.endTarget.value = dates[1] || ''
    }
    if (this.config.mode == 'range') {
      dates.length == 2 && this.submitFormValue && this.#submitForm()
    } else {
      this.submitFormValue && this.#submitForm()
    }
  }

  #submitForm() {
    let form = (this.element instanceof HTMLFormElement ? this.element : this.element.closest('form'))
    form.requestSubmit()
  }
}