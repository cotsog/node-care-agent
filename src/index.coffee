usage = require 'usage'
pid = process.pid
io = null
interval = 1000

heapdiffer = require './modules/heapdiffer'
heapdumper = require './modules/heapdumper'
cpuprofiler = require './modules/cpuprofiler'
npm = require './modules/npm'

module.exports = (options) ->
  io = require('socket.io')(options.listenTo)
  interval = options.options.interval

  io.on 'connection', (socket) ->

    auth = socket.handshake.query

    _handleSocket(socket)

    if auth.appKey isnt options.appKey or auth.appSecret isnt options.appSecret
      socket.close()

  usageRunner()
  return io

usageRunner = ->
  count = io.eio.clientsCount
  if count
    usage.lookup pid, (err, result) ->
      io.emit 'stats', result
  setTimeout ->
    usageRunner()
  , interval

_handleSocket = (socket) ->
  socket.on 'PING', ->
    socket.emit 'PONG'

  heapdiffer(socket)
  heapdumper(socket)
  cpuprofiler(socket)
  npm(socket)