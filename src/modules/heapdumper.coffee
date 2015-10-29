fs = require 'fs'
heapdump = require 'heapdump-nosignal'

module.exports = (socket) ->
  socket.on 'module:heapdump:request', ->

    # get a jit heap snapshot and write it to the disk
    heapdump.writeSnapshot (err, filename) ->
      if !err and filename
        # read the heap snapshot from disk
        fs.readFile filename, (err, result) ->
          # delete the heap snapshot from disk
          fs.unlink(filename)

          # send the result of the heap snapshot to the browser
          socket.emit 'module:heapdump:response', result
      ###
        istanbul ignore next
      ###
      if err and filename
        fs.unlink(filename)