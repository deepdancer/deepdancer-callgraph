module.exports = (grunt) ->
  grunt.initConfig

    watch:
      coffeelint:
        files: ['src/**/*.coffee', 'Gruntfile.coffee']
        tasks: ['coffeelint']

    coffeelint:
      app: ['src/**/*.coffee', 'Gruntfile.coffee']
      options:
        configFile: 'coffeelint.json'

    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: 'coffee-script/register'
          bail: true
        src: ['test/**/*.coffee']

    shell:
      coffee:
        command: 'node_modules/.bin/coffee --output lib src'

      publish:
        command: 'cp package.json lib/deepdancer-darkmagic; ' +
          'rm -rf lib/deepdancer-darkmagic/testUtilities; ' +
          'cp README.md lib/deepdancer-darkmagic; ' +
          '(cd lib/deepdancer-darkmagic; npm publish);'


  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-shell'