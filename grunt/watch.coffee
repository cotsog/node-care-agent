module.exports =
  watch:
    grunt:
      files: ['Gruntfile.coffee']
    module:
      files: ['src/**/*.coffee']
      tasks: ['clean:module', 'coffee:module', 'clean:test', 'coffee:test', 'clean:coverage', 'env:coverage', 'instrument', 'mochaTest', 'storeCoverage', 'makeReport']
    test:
      files: ['test/src/**/*.coffee']
      tasks: ['clean:test', 'coffee:test', 'clean:coverage', 'env:coverage', 'instrument', 'mochaTest', 'storeCoverage', 'makeReport']
