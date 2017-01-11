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

    shell:
      coffee:
        command: 'node_modules/.bin/coffee --output lib src'

      publish:
        command: 'cp package.json lib/deepdancer-callgraph; ' +
          'cp README.md lib/deepdancer-callgraph; ' +
          '(cd lib/deepdancer-callgraph; npm publish);'


  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-shell'