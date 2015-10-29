module.exports = (socket) ->

  socket.on 'module:process:restart', ->
    socket.emit 'module:process:restarting'
    process.kill(process.pid, 'SIGUSR2')