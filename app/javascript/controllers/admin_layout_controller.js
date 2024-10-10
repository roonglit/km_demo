import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="admin-layout"
export default class extends Controller {
  static targets = ['aside', 'navIcon', 'navItemContent', 'wrapper']
  connect() {
    this.asideStatus = false
    this.applyAside()
  }

  toggle() {
    this.asideStatus = !this.asideStatus
    this.applyAside()
  }

  applyAside() {
    if (this.asideStatus) {
      // show
      this.asideTarget.classList.remove('md:w-[6.225em]')
      this.asideTarget.classList.remove('max-md:-left-[20rem]')
      this.navIconTarget.classList.add('me-3')
      this.navItemContentTargets.forEach((navItemContent) => {
        navItemContent.classList.remove('hidden')
      })
      this.wrapperTarget.classList.remove('md:pl-[6.225rem]')
    } else {
      // hide
      this.asideTarget.classList.add('md:w-[6.225em]')
      this.asideTarget.classList.add('max-md:-left-[20rem]')
      this.navIconTarget.classList.remove('me-3')
      this.navItemContentTargets.forEach((navItemContent) => {
        navItemContent.classList.add('hidden')
      })
      this.wrapperTarget.classList.add('md:pl-[6.225rem]')
    }
  }
}
