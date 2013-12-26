requirejs.config
  baseUrl: "/lib"
  paths:
    "jquery":       "com/jquery/js/jquery"
    "underscore":   "com/underscore/js/underscore"
    "backbone":     "com/backbone/js/backbone"
    "moment": "com/momentjs/js/moment"
    "com/backbone/backbone-localstorage": "com/backbone.localStorage/js/backbone.localStorage",
    "com/jquery/jquery-ui": "com/jquery-ui/js/jquery-ui"
    "com/sprintf": "com/sprintf/js/sprintf"
  shim:
    "underscore":
      exports: "_"
    "backbone":
      exports: "Backbone"
      deps: [
        "underscore"
        "jquery"
      ]
    "com/jquery/jquery-ui":
      deps: ["jquery"]
      exports: "jQuery.ui"
    "com/sprintf":
      exports: "sprintf"

