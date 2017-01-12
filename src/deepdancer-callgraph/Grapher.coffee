lodash = require 'lodash'

class Grapher

  constructor: ->
    @_container = undefined
    @_aliasesMap = {}
    @_labelsMap = {}
    @_alreadyProcessed = []


  load: (container, ignore = []) =>
    @_container = container
    @_ignore = ignore
    @_aliasesMap = {}
    @_labelsMap = {}

    @_alreadyProcessed = []

    @_loadAliasMap()


  getGraph: =>
    ret = 'digraph {\n'
    ret += @_getDirectoriesDeclarations()
    ret += @_getConnectionsDeclaration()
    ret += '\n}'

    ret


  _getDirectoriesDeclarations: =>
    directories = lodash.values(lodash.pick(@_aliasesMap, (value) ->
      value.indexOf('/') != -1
    )).sort()

    clusters = {}

    for value in directories
      elements =  value.split('/')
      value = elements.pop()
      cluster = elements.join('/')

      if @_shouldIgnore(value)
        continue

      if !@_container.has(value)
        continue

      if !(cluster of clusters)
        clusters[cluster] = []

      clusters[cluster].push(value)

    ret = ''
    for name, clusterElements of clusters
      if clusterElements.length <= 1
        continue
      ret += '    subgraph "cluster_' + name + '" { \n'
      ret += '        "' + clusterElements.join('", "') + '"'
      ret += '\n    }\n\n'

    ret


  _getConnectionsDeclaration: =>
    ret = ''
    for _ ,definition of @_container._definitions
      if definition.type in ['alias', 'value']
        continue
      source = definition.key


      if source of @_labelsMap
        source = @_labelsMap[source]

      if @_shouldIgnore(source)
        continue

      targets = @_getTargetsFor(definition)

      for _, target of targets
        if @_shouldIgnore(target)
          continue
        ret += '    "' + source + '" -> "' + target + '"\n'

      ret += '\n'

    ret


  _getTargetsFor: (definition) =>
    targets = []

    definitionDependencies = definition.dependencies

    for dependency in definitionDependencies
      if dependency of @_labelsMap
        targets.push(@_labelsMap[dependency])
      else
        targets.push(dependency)

    targets


  _loadAliasMap: =>
    for _, definition of @_container._definitions
      if definition.type == 'alias'
        @_aliasesMap[definition.key] = definition.value
    @_labelsMap = lodash.invert(@_aliasesMap)


  _shouldIgnore: (what) =>
    for toIgnore in @_ignore
      if typeof toIgnore == "string"
        if toIgnore == what
          return true
      else
        if toIgnore.test(what)
          return true
    return false



module.exports = Grapher