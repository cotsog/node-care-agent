spawn = require('child_process').spawn
path = require 'path'
findup = require 'findup-sync'
io = null
branch = null

dir = findup('.git').split('/')
dir.pop()
dir = dir.join('/')

module.exports = (remoteIO) ->
  io = remoteIO
  runner()

runner = ->

  if !branch
    getBranch = spawn 'git', ['status'], cwd: dir
    getBranch.stdout.on 'data', (data) ->
      data = data.toString('utf-8')
      line = data.split('\n')[0]
      branch = line.split('On branch ')[1]

  localCommit = ''
  local = spawn 'git', ['rev-parse', branch], cwd: dir

  local.stdout.on 'data', (data) ->
    data = data.toString('utf-8')
    commit = data.split('\n')[0]
    localCommit = commit

  url = spawn 'git', ['config', '--get', 'remote.origin.url'], cwd: dir
  url.stdout.on 'data', (data) ->
    data = data.toString('utf-8')
    originUrl = data.split('\n')[0]

    remote = spawn 'git', ['ls-remote', originUrl, branch]

    remote.stdout.on 'data', (data) ->
      data = data.toString('utf-8')
      commit = data.split('\n')[0].split('\t')[0]

      if commit isnt localCommit
        console.log 'OUT OF SYNC'
        io.emit 'module:git:out-of-sync'
      else
        io.emit 'module:git:synced'


  setTimeout ->
    runner()
  , 10000