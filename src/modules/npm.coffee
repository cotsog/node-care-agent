_ = require 'underscore'
npm = require 'npm'
install = require 'spawn-npm-install'
findup = require 'findup-sync'
pkgPath = findup('package.json')

dir = findup('.git').split('/')
dir.pop()
dir = dir.join('/')

module.exports = (socket) ->

  socket.on 'module:npm:packages', getPackages.bind(socket)
  socket.on 'module:npm:install', installModule.bind(socket)
  socket.on 'module:npm:uninstall', uninstallModule.bind(socket)
  socket.on 'module:npm:install-all', installAllModules.bind(socket)
  socket.on 'module:npm:update-all', updatedAllModules.bind(socket)

normalize = (arr) ->
  json = {}
  for item in arr
    json[item[1]] =
      current: item[2]
      wanted: item[3]
      latest: item[4]
      pkgjson: item[5]
  return json

updatedAllModules = ->
  socket = @
  npm.load { loglevel: 'silent', prefix: dir }, (err, npm) ->
    npm.commands.update (err) ->
      socket.emit 'module:npm:updated-all'

installAllModules = ->
  socket = @
  npm.load { loglevel: 'silent', prefix: dir }, (err, npm) ->
    npm.commands.install (err) ->
      socket.emit 'module:npm:installed-all'

uninstallModule = (moduleName) ->
  socket = @
  install.uninstall moduleName, { save: true }, (err) ->
    socket.emit 'module:npm:uninstalled', moduleName

installModule = (moduleName) ->
  socket = @
  install moduleName, { save: true }, (err) ->
    socket.emit 'module:npm:installed', moduleName

getPackages = ->
  socket = @
  pkg = require(pkgPath)

  dependencies = pkg.dependencies
  devDependencies = pkg.devDependencies

  npm.load { loglevel: 'silent', prefix: dir }, (err, npm) ->
    npm.commands.outdated json: true, (err, data) ->

      outdated = normalize(data)

      # update all dependencies with its wanted and latest version if not updated
      for moduleName, version of dependencies
        out = outdated[moduleName] or {}
        dependencies[moduleName] =
          version: version
          current: out.current
          wanted: out.wanted
          latest: out.latest

      # update all devDependencies with its wanted and latest version if not updated
      for moduleName, version of devDependencies
        out = outdated[moduleName] or {}
        devDependencies[moduleName] =
          version: version
          current: out.current
          wanted: out.wanted
          latest: out.latest

      socket.emit 'module:npm:packages',
        dependencies: dependencies
        devDependencies: devDependencies