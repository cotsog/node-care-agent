Git = require 'nodegit'
findup = require 'findup-sync'
dir = findup('.git').split('/')
dir.pop()
dir = dir.join('/')

module.exports = (socket) ->

  socket.on 'module:details:request', ->
    details = {}

    # fetch living local commit
    Git.Repository.open dir
    .then (repository) ->
      repository.getHeadCommit()
      .then (commit) ->

        obj =
          id: commit.id().toString().substring(0, 10)
          author: commit.author().toString().split(' ')[0]
          date: commit.date().toString()
          message: commit.message().split('Signed-off-by')[0]

        # add commit to details
        details.git = obj

        # add process dir to details
        details.process =
          dir: dir

        # add pkg json of the process to details
        details.pkg = require(dir+'/package.json')

        # send details to browser
        socket.emit 'module:details:response', details