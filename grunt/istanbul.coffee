module.exports =
  env:
    coverage:
      APP_DIR_FOR_CODE_COVERAGE: '../test/coverage/instrument/build/'
  instrument:
    files: 'build/**/*.js'
    options:
      lazy: true
      basePath: 'test/coverage/instrument/'
  mochaTest:
    options:
      reporter: 'spec'
    src: 'test/dist/**/*.js'
  storeCoverage:
    options:
      dir: 'test/coverage/reports'
  makeReport:
    src: 'test/coverage/reports/**/*.json'
    options:
      type: 'lcov'
      dir: 'test/coverage/reports'
      print: 'detail'