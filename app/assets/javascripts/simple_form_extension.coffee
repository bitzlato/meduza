$.simpleForm =
  # Bind a callback to run when a DOM or sub-DOM is ready to be initialized
  # Allows abstracting the following cases :
  #   - Document is ready with $(document).ready()
  #   - Document is ready with Turbolinks 'page:change' or 'turbolinks:load'
  #   - A sub-DOM is dynamically added and needs all the plugins to be
  #     initialized, ex: for nested forms
  #
  onDomReady: (callback) ->
    $(document).on 'initialize.simpleform', (e, $fragment) ->
      callback($fragment)

# Trigger all the registered callbacks and run them on the target element
$.fn.simpleForm = ->
  @each (i, fragment) ->
    $(document).trigger('initialize.simpleform', [$(fragment)])

# Classic document ready binding
# Does not run when Turbolinks is present and supported by the browser
#
$(document).ready ->
  $('body').simpleForm() unless window.Turbolinks && window.Turbolinks.supported

# Turbolinks document ready binding with compatibility for turbolinks-classic
# and rails 5 turbolinks events
#
$(document).on 'page:change turbolinks:load', ->
  $('body').simpleForm()
