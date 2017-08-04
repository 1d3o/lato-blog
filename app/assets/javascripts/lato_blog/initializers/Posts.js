var BlogPostsInitializer = (function () {

  function initializeAutosave () {
    var formInput = $('.posts__form-autosave')

    if (formInput) {
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

  function initializeCategoriesAutosave () {
    var form = $('.posts__edit-categories').find('form')
    $(form).find('input').change(function () {
      $(form).submit()
    })
  }

  function initializePublicationDatetimeAutosave () {
    var form = $('.posts__edit-publication-datetime').find('form')
    $(form).find('input').change(function () {
      $(form).submit()
    })
  }

  function initializeStatusSwitchAutosave () {
    var form = $('.posts__edit-status').find('form')
    $(form).find('select').change(function () {
      $(form).submit()
    })
  }

  function initializeSeoDescriptionAutosave () {
    var form = $('.posts__edit-seo-description').find('form')
    $(form).find('textarea').change(function () {
      $(form).submit()
    })
  }

  // Init:

  function init () {
    initializeAutosave()
    initializeCategoriesAutosave()
    initializePublicationDatetimeAutosave()
    initializeStatusSwitchAutosave()
    initializeSeoDescriptionAutosave()
  }

  return {
    init: init
  }

})()