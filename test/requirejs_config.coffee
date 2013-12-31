# requirejs
_ = require "underscore"
_(global).extend
  $: require "jquery"
  jQuery: require "jquery"
  window:
    jQuery: require "jquery"
  _: require "underscore"
  Backbone: require "backbone"
  documentElement: {}
  requirejs: require "requirejs"
  localStorage: require "localStorage"

Backbone.$ = jQuery

requirejs.config
  baseUrl: "./dist/lib"
  paths:
    "com/backbone/backbone-localstorage": "com/backbone.localStorage/js/backbone.localStorage",
