usage = require 'usage'
pid = process.pid
io = null
interval = 1000

heapdiffer = require './modules/heapdiffer'
heapdumper = require './modules/heapdumper'
cpuprofiler = require './modules/cpuprofiler'
npm = require './modules/npm'
gitPullRunner = require './modules/gitpull'
details = require './modules/details'
git = require './modules/git'

module.exports = (options) ->
  io = require('socket.io')(options.listenTo)
  interval = options.options.interval
  ###
    istanbul ignore next
  ###
  if interval < 1000
    interval = 1000

  io.on 'connection', (socket) ->

    auth = socket.handshake.query

    _handleSocket(socket)

    if auth.appKey isnt options.appKey or auth.appSecret isnt options.appSecret
      socket.close()

  usageRunner()
  gitPullRunner(io)
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
  details(socket)
  git(socket)