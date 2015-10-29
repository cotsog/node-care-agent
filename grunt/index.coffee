extend = require './extend'

# plugins
{ istanbul, clean, coffee, uglify, watch } = require './plugins'

gruntConfig = extend {}, istanbul, clean, coffee, uglify, watch

module.exports = (grunt, iced = false) ->

  mapping =
    instrument: 'grunt-istanbul'

  if iced
    mapping.coffee = 'grunt-iced-coffee'

  require('jit-grunt')(grunt, mapping)
  return gruntConfig