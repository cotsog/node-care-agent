module.exports =
  uglify:
    module:
      files: [
        expand: true
        cwd: 'build/'
        src: '**/*.js'
        dest: 'dist/'
      ]