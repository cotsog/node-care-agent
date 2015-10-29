module.exports = (path) ->
  return require(('../coverage/instrument/build/') + path)