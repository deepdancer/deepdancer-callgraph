Grapher = require 'deepdancer-callgraph/Grapher'

module.exports = (container, ignore) ->
  grapher = new Grapher()
  grapher.load(container, ignore)
  grapher.getGraph()

