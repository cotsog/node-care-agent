npm = require 'npm'
findup = require 'findup-sync'
pkg = require(findup('package.json'))

dependencies = pkg.dependencies
devDependencies = pkg.devDependencies

module.exports = (socket) ->

  socket.on 'module:npm:packages', ->
    npm.load loglevel: 'silent', (err) ->
      npm.commands.outdated (err, data) ->

        outdated = normalize(data)

        socket.emit 'module:npm:packages',
          dependencies: pkg.dependencies
          devDependencies: pkg.devDependencies
          outdated: outdated


normalize = (arr) ->
  json = {}
  for item in arr
    json[item[1]] =
      current: item[2]
      wanted: item[3]
      latest: item[4]
      pkgjson: item[5]
  return json