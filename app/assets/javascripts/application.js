//= require rails-ujs
//= require turbolinks
//  require better-dom
//  require better-dateinput-polyfill/dist/better-dateinput-polyfill.min.js
//= require bootstrap
//= require_tree ./elements
//= require_tree ./extra

document.addEventListener("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip()
})
