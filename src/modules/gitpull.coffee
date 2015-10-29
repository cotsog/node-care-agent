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
  # get the branch
  getBranch()

getBranch = ->

  # if the branch isnt already set
  if !branch
    # get the branch out of the local git repository
    getBranch = spawn 'git', ['status'], cwd: dir
    getBranch.stdout.on 'data', (data) ->
      data = data.toString('utf-8')
      line = data.split('\n')[0]
      branch = line.split('On branch ')[1]
      # compare commits with the branch
      compareCommits()
  else
    # compare commits
    compareCommits()

# compares the local and remote commit 'id'
compareCommits = ->
  localCommit = ''

  # get the local commit by branch
  local = spawn 'git', ['rev-parse', branch], cwd: dir

  local.stdout.on 'data', (data) ->
    data = data.toString('utf-8')
    commit = data.split('\n')[0]
    localCommit = commit

    # get remote origin url of that branch
    url = spawn 'git', ['config', '--get', 'remote.origin.url'], cwd: dir
    url.stdout.on 'data', (data) ->
      data = data.toString('utf-8')
      originUrl = data.split('\n')[0]

      # get remote commit by url
      remote = spawn 'git', ['ls-remote', originUrl, branch]

      remote.stdout.on 'data', (data) ->
        data = data.toString('utf-8')
        commit = data.split('\n')[0].split('\t')[0]

        # if the local and remote commit are not the same
        if commit isnt localCommit
          # report as out of sync
          io.emit('module:git:out-of-sync')
        else
          # report as synced
          io.emit('module:git:synced')

        # do it again in 10 seconds!
        setTimeout ->
          compareCommits()
        , 10000