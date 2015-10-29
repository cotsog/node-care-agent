Git = require 'nodegit'
findup = require 'findup-sync'

dir = findup('.git').split('/')
dir.pop()
dir = dir.join('/')

module.exports = (socket) ->

  socket.on 'module:git:status', ->

    Git.Repository.open dir
    .then (getStatus)
    .then (list) ->
      socket.emit 'module:git:status', list

getStatus = (repository) ->
  return repository.getStatus().then(processStatuses)

processStatuses = (statuses) ->
  results = []
  statuses.forEach (file) ->
    results.push file.path() + ' ' + statusToText(file)
  return results

statusToText = (status) ->
  words = []
  if status.isNew() then words.push('NEW')
  if status.isModified() then words.push('MODIFIED')
  if status.isTypechange() then words.push('TYPECHANGE')
  if status.isRenamed() then words.push('RENAMED')
  if status.isIgnored() then words.push('IGNORED')

  return words.join(' ')