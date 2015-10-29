requireHelper = require './require_helper'
nca = requireHelper 'index.js'
assert = require 'assert'
http = require 'http'

port = 8081

server = http.createServer()
client = null
socket = null

appKey = '12903refjdsoufj9238j1wdad'
appSecret = '9jda9sijd0929j39q3jed'

nca({
  appKey: appKey
  appSecret: appSecret
  listenTo: server or port
  options:
    interval: 0
})

describe 'node.care Agent', ->

  describe 'general start and connection routines', ->

    it 'binds a websocket-server to an http server', (done) ->
      server.listen port, ->
        done()

    it 'fails if the app- Key or Secret are wrong', ->
      failClient = require('./client')(port, appKey, appSecret + 'a')
      assert.equal failClient.disconnected, true

    it 'triggers on a new connection',  ->

      # create a valid client
      client = require('./client')(port, appKey, appSecret)
      assert.equal client.connected, true

  describe 'communication between host and client', ->

    it 'answers a ping request from a websocket client', (done) ->

      # if the client receives a PONG
      client.on 'PONG', ->
        done()

      # client sends PING
      client.emit 'PING'

    it 'sends its usage statistics', (done) ->
      client.once 'stats', (stats) ->
        done()

  describe 'module requests', ->

    describe 'heapdiff', ->

      it 'starts a heapdiff', (done) ->

        @timeout(5000)

        # if the agent responds with a started-status
        client.on 'module:heapdiff:started', ->
          done()

        # send heapdiff start request
        client.emit 'module:heapdiff:start'

      it 'fails to start a heapdiff, because there is already a started one', (done) ->

        # if the agent responds with a start-failed-status
        client.on 'module:heapdiff:start-failed', ->
          done()

        # sends another heapdiff start request
        client.emit 'module:heapdiff:start'

      it 'stops a running heapdiff and returns the heapdiff', (done) ->

        @timeout(5000)

        # if the agent responds with a stopped-status
        client.on 'module:heapdiff:stopped', (result) ->
          assert.deepEqual Object.keys(result), ['before', 'after', 'change']
          done()

        # sends a heapdiff stop request
        client.emit 'module:heapdiff:stop'

      it 'fails to stop a not-running heapdiff, because it was already stopped', (done) ->

        # if the agent responds with a stop-failed-status
        client.on 'module:heapdiff:stop-failed', ->
          done()

        # sends another heapdiff stop request
        client.emit 'module:heapdiff:stop'

    describe 'heapdump', ->

      it 'gets a heapdump', (done) ->

          @timeout(5000)

          # receive a heapdump response
          client.on 'module:heapdump:response', (buffer) ->
            if buffer.length > 1
              done()

          # send heapdump start request
          client.emit 'module:heapdump:request'

    describe 'profiler', ->

      it 'starts a profiler', (done) ->

        @timeout(5000)

        # if the agent responds with a started-status
        client.on 'module:profiler:started', ->
          done()

        # send profiler start request
        client.emit 'module:profiler:start'

      it 'fails to start a profiler, because there is already a started one', (done) ->

        # if the agent responds with a start-failed-status
        client.on 'module:profiler:start-failed', ->
          done()

        # sends another profiler start request
        client.emit 'module:profiler:start'

      it 'stops a running profiler and returns the profile', (done) ->

        @timeout(5000)

        # if the agent responds with a stopped-status
        client.on 'module:profiler:stopped', (result) ->
          assert.deepEqual Object.keys(result), ['typeId', 'uid', 'title', 'head', 'startTime', 'endTime', 'samples', 'timestamps']
          done()

        # sends a profiler stop request
        client.emit 'module:profiler:stop'


      it 'fails to stop a not-running profiler, because it was already stopped', (done) ->

        # if the agent responds with a stop-failed-status
        client.on 'module:profiler:stop-failed', ->
          done()

        # sends another profiler stop request
        client.emit 'module:profiler:stop'

    describe 'npm modules installed', ->

      it 'responds with the list of modules used', (done) ->

        @timeout(10000)

        # if the agent responds with updates
        client.on 'module:npm:packages', (result) ->
          console.log result
          assert.deepEqual Object.keys(result), ['dependencies', 'devDependencies', 'outdated']
          done()

        # sends a request for a list of modules which needs an update
        client.emit 'module:npm:packages'

getValidJSON = (str, chars) ->

  try
    test = JSON.stringify str.substr(0, chars)
    return true

  catch error
    return false
