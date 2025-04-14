import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['header', 'row']
  static values = {
    name: { type: String, default: "search-results" }
  }

  connect() {
    window.test = this
  }

  downloadFile() {
    let csvContent = `${this.#headerContent()}\n${this.#bodyContent()}`
    let encodedUri = encodeURI(csvContent)
    let link = document.createElement('a')

    link.display = "none"
    link.setAttribute("target", "_blank")
    link.setAttribute("href", "data:text/csv;charset=utf-8," + encodeURIComponent(csvContent))
    link.setAttribute("download", `${this.nameValue}-${Date.now()}.csv`)
    this.element.appendChild(link)
    link.click()
  }

  #headerContent() {
    return [...this.headerTarget.querySelectorAll("span")].map(th => {
      return '"' + this.#sanitizeData(th.innerText) + '"'
    })
  }

  #bodyContent() {
    return this.rowTargets.map(row => {
      return [...row.querySelectorAll(".result")].map(td => {
        return '"' + this.#sanitizeData(td.children[0]?.href || td.innerText) + '"'
      }).join(",")
    }).join("\n")
  }

  #sanitizeData(text) {
    return text.replace(/(\r\n|\n|\r)/gm, '').replace(/(\s\s)/gm, ' ').replace(/"/g, '""')
  }
}
