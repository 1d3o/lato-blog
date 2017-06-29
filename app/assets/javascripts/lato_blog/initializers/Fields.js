var BlogFieldsInitializer = (function () {

  function initializeRelayNewButton () {
    $('.fields-relay__menu-add').click(function (e) {
      var parent = $(this).parent()
      var menu = $(parent).find('.fields-relay__menu')
      $(menu).toggleClass('fields-relay__menu--active')
      e.preventDefault()
    })
  }

  function appendDestroy() {
    $('.js-sortable__main-container').each(function(i, el) {
      $(el).find('.js-sortable__element').each(function(index, element) {
        var fieldId = $(element).find('.fields__container').data('field-id')
        var destroyButton = $('.js-related-field__destroy.is-first')
        var href = destroyButton.attr('href')
        var newHref = href + '?id=' + fieldId
        var cloneButton = destroyButton.clone(true)
        $(cloneButton).removeClass('is-first').attr('href', newHref)

        $(element).find('.c-sortable__handle').after(cloneButton)
      })
    })
  }

  // Init:

  function init () {
    initializeRelayNewButton()
    appendDestroy()
  }

  return {
    init: init
  }

})()