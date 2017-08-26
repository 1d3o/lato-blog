var BlogPosts = (function () {

  function _initializeAutosave () {
    var formInput = $('.posts__form-autosave')

    if (formInput.length > 0) {
      var form = $(formInput).parent()
      setInterval(function () {
        if ($(formInput).val('false')) {
          $(formInput).val('true')
          $(form).attr('data-remote', true)
          $.rails.handleRemote($(form))
          $(formInput).val('false')
          $(form).attr('data-remote', false)
        }
      }, 10000)
    }
  }

  function _initializeCategoriesAutosave () {
    var form = $('.posts__edit-categories').find('form')
    $(form).find('input').change(function () {
      $(form).submit()
    })
  }

  function _initializePublicationDatetimeAutosave () {
    var form = $('.posts__edit-publication-datetime').find('form')
    $(form).find('input').change(function () {
      $(form).submit()
    })
  }

  function _initializeStatusSwitchAutosave () {
    var form = $('.posts__edit-status').find('form')
    $(form).find('select').change(function () {
      $(form).submit()
    })
  }

  function _initializeSeoDescriptionAutosave () {
    var form = $('.posts__edit-seo-description').find('form')
    $(form).find('textarea').change(function () {
      $(form).submit()
    })
  }

  // Init:

  function init () {
    _initializeAutosave()
    _initializeCategoriesAutosave()
    _initializePublicationDatetimeAutosave()
    _initializeStatusSwitchAutosave()
    _initializeSeoDescriptionAutosave()
  }

  return {
    init: init
  }

})()