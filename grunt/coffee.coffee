module.exports =
  coffee:
    module:
      options:
        bare: true
      expand: true
      cwd: 'src/'
      src: ['**/*.coffee']
      dest: 'build/'
      ext: '.js'
    test:
      options:
        bare: true
      expand: true
      cwd: 'test/src/'
      src: ['**/*.coffee']
      dest: 'test/dist/'
      ext: '.js'