var BlogPostsInitializer = (function () {

  function initializeAutosave () {
    var formInput = $('.posts__form-autosave')

    if (formInput) {
      var form = $(formInput).parent()
      setInterval(function () {
        if ($(formInput).val('false')) {
          $(formInput).val('true')
          $(form).attr('data-remote', true)
          $(form).submit()
          $(formInput).val('false')
          $(form).attr('data-remote', false)
        }
      }, 10000)
    }
  }

  // Init:

  function init () {
    initializeAutosave()
  }

  return {
    init: init
  }

})()