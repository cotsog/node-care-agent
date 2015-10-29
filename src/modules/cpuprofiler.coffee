fs = require 'fs'
profiler = require 'v8-profiler'
profiling = false

module.exports = (socket) ->

  socket.on 'module:profiler:start', ->
    if not profiling
      profiling = true
      profiler.startProfiling('', true)
      socket.emit 'module:profiler:started'

    else
      socket.emit 'module:profiler:start-failed'


  socket.on 'module:profiler:stop', ->
    if profiling
      profiling = false
      result = profiler.stopProfiling('')
      #fs.writeFileSync './profile.cpuprofile', JSON.stringify result, null, 2
      profiler.deleteAllProfiles()
      socket.emit 'module:profiler:stopped', result
    else
      socket.emit 'module:profiler:stop-failed'