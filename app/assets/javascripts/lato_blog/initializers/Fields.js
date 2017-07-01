var BlogFieldsInitializer = (function () {

  function initializeRelayNewButton () {
    $('.fields-relay__menu-add').click(function (e) {
      // save current status with form submit
      _relaySubmitUpdateBeforeAction()
      // open - close menu
      var parent = $(this).parent()
      var menu = $(parent).find('.fields-relay__menu')
      $(menu).toggleClass('fields-relay__menu--active')
      e.preventDefault()
    })
  }

  function initializeRelayDestroy () {
    $('.js-sortable__main-container').each(function (i, el) {
      $(el).find('.js-sortable__element').each(function (index, element) {
        var fieldId = $(element).find('.fields__container').data('field-id')
        var destroyButton = $('.js-related-field__destroy.is-first')
        var href = destroyButton.attr('href')
        var newHref = href + '?id=' + fieldId
        var cloneButton = destroyButton.clone(true)
        $(cloneButton).removeClass('is-first').attr('href', newHref)
        $(element).find('.c-sortable__handle').after(cloneButton)
        // listen onclick to save current status
        $(cloneButton).click(function () {
          _relaySubmitUpdateBeforeAction()
        })
      })
    })
  }

  function _relaySubmitUpdateBeforeAction () {
    var formInput = $('.posts__form-autosave')
    var form = $(formInput).parent()
    if ($(formInput).val('false')) {
      $(formInput).val('true')
      $(form).attr('data-remote', true)
      $(form).submit()
      $(formInput).val('false')
      $(form).attr('data-remote', false)
    }
  }

  // Init:

  function init () {
    initializeRelayNewButton()
    initializeRelayDestroy()
  }

  return {
    init: init
  }

})()