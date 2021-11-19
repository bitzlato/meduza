class RowElement extends HTMLTableRowElement {
  connectedCallback() {
    this.addEventListener('click', this.onClick)
    this.style='cursor: pointer'
  }

  onClick(e) {
    const $target = $(e.target)
    if ( $target.closest('a').length > 0 ||
         $target.is('.btn') ||
         $target.is('input') ||
         $target.is('select') ||
         $target.is('.best_in_place') ||
         $target.closest('.project-actions').length > 0 )
    {
      return
    }

    e.preventDefault()

    if (this.dataset.hrefTarget) {
      window.open(this.dataset.href, this.dataset.hrefTarget)
    } else {
      window.location = this.dataset.href
    }
  }
}
customElements.define('dapi-tr', RowElement, {extends: 'tr'});
