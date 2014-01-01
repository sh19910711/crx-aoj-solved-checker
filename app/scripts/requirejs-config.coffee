#
# The MIT License (MIT)
# 
# Copyright (c) 2012-2014 Hiroyuki Sano
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
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

