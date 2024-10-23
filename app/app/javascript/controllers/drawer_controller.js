import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  toggle(e) {
    const detailQuery = `#${e.currentTarget.dataset.card} .detail`
    const openBtnQuery = `#${e.currentTarget.dataset.card} .detail-open-btn`
    this.element.querySelector(detailQuery).classList.toggle('d-none')
    this.element.querySelector(openBtnQuery).classList.toggle('d-none')
  }
}
