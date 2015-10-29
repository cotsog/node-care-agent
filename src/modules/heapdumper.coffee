fs = require 'fs'
heapdump = require 'heapdump-nosignal'

module.exports = (socket) ->
  socket.on 'module:heapdump:request', ->

    heapdump.writeSnapshot (err, filename) ->
      if !err and filename
        fs.readFile filename, (err, result) ->
          fs.unlink(filename)
          socket.emit 'module:heapdump:response', result
      ###
        istanbul ignore next
      ###
      if err and filename
        fs.unlink(filename)