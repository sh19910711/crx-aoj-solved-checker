# requirejs
global.requirejs = require "requirejs"
require "./requirejs_config"

# should
require "should"

# nock
global.nock = require "nock"
nock.disableNetConnect()

global.fs = require "fs"
