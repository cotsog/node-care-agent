heapdiffing = false
hd = false

memwatch = require 'memwatch-next'

module.exports = (socket) ->

  socket.on 'module:heapdiff:start', ->
    if not heapdiffing
      heapdiffing = true
      socket.emit 'module:heapdiff:started'

      # create 1 heap snapshot
      hd = new memwatch.HeapDiff()
    else
      socket.emit 'module:heapdiff:start-failed'


  socket.on 'module:heapdiff:stop', ->
    if heapdiffing
      heapdiffing = false
      # create a 2nd heapsnapshot and get the difference
      diff = hd.end()
      socket.emit 'module:heapdiff:stopped', diff
    else
      socket.emit 'module:heapdiff:stop-failed'