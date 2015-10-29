io = require 'socket.io-client'
socket = null

module.exports = (port, appKey, appSecret) ->
  socket = io('http://127.0.0.1:' + port + '/', { query: { appKey: appKey, appSecret: appSecret } })
  return socket