_ = require 'underscore'

module.exports = (root, objs...) ->
  for obj in objs
    _.extend root, obj
  return root