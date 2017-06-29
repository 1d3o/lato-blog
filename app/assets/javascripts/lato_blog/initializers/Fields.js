var BlogFieldsInitializer = (function () {

  function initializeRelayNewButton () {
    $('.fields-relay__menu-add').click(function (e) {
      var parent = $(this).parent()
      var menu = $(parent).find('.fields-relay__menu')
      $(menu).toggleClass('fields-relay__menu--active')
      e.preventDefault()
    })
  }

  // Init:

  function init () {
    initializeRelayNewButton()
  }

  return {
    init: init
  }

})()