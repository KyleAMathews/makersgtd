express = require('express')
util = require('util')
_ = require('underscore')
moment = require('moment')
mongoose = require('mongoose')
require('./mongoose_schemas')

app = express.createServer()

# Return index.jade if html is requested, otherwise return JSON or static files.
htmlOrNot =
  handle: (req, res, next) ->
    if req.headers.accept? and req.headers.accept.indexOf('text/html') isnt -1
      console.log 'loading models'
      successCounter = ->
        counter = 0
        json = {}
        return {
          add: (data) ->
            counter += 1
            for k,v of data
              console.log k
              json[k] = v
            if counter is 3
              res.render 'index', json
        }
      counter = successCounter()
      getAllModels('action', (actions) -> counter.add( actions_json: actions ))
      getAllModels('project', (projects) -> counter.add( projects_json: projects ))
      getAllTags (tags) -> counter.add( tags_json: tags )
    else
      next()

# Setup Express middleware.
app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.responseTime()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use htmlOrNot
  app.use app.router
  app.use express.static __dirname + '/public'


queryMultiple = (type, ids, callback) ->
  ModelObj = mongoose.model type
  query = ModelObj.find()
  query
    .where('_id').in(ids)
    .notEqualTo('deleted', true)
    .run (err, models) ->
      unless err or not models?
        newModels = []
        for model in models
          model.setValue('id', model.getValue('_id'))
        callback(models)

getAllModels = (type, callback) ->
  modelType = mongoose.model type
  date = moment().subtract('hours', 12)
  query = modelType.find()
  query
    # Only get completed actions from past 12 hours.
    .or([{ 'done': false }, {'completed': { $gte : date.native()}}])
    .notEqualTo('deleted', true)
    .run (err, models) ->
      unless err or not models?
        newModels = []
        for model in models
          model.setValue('id', model.getValue('_id'))
        callback(models)

app.get '/', (req, res) ->
  #console.log req.headers
  res.render 'index'

# REST endpoint for Actions
app.get '/actions', (req, res) ->
  if req.query.ids?
    queryMultiple 'action', req.query.ids, (models) ->
      res.json models

  else
    getAllModels 'action', (actions) ->
      res.json actions

app.get '/actions/:id', (req, res) ->
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action?
      console.log 'Getting action: ' + action.name
      res.json action
    else
      res.json { error: 'Couldn\'t load action' }

app.post '/actions', (req, res) ->
  console.log 'saving new action'
  Action = mongoose.model 'action'
  action = new Action()
  for k,v of req.body
    action[k] = v
  action.created = new Date()
  action.changed = new Date()
  action.save (err) ->
    unless err
      res.json id: action._id

app.put '/actions/:id', (req, res) ->
  console.log 'updating an action'
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action?
      for k,v of req.body
        if k is 'id' then continue
        action[k] = v
      action.changed = new Date()
      action.save()
      res.json {
        saved: true
        changed: action.changed
      }

app.del '/actions/:id', (req, res) ->
  console.log 'deleting an action'
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action?
      action.remove()
      action.save()

# REST endpoint for Projects
app.get '/projects', (req, res) ->
  console.log 'getting projects'
  if req.query.ids?
    queryMultiple 'project', req.query.ids, (models) ->
      res.json models

  else
    getAllModels 'project', (projects) ->
      res.json projects

app.get '/projects/:id', (req, res) ->
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project?
      console.log 'Getting project: ' + project.name
      res.json project
    else
      res.json { error: 'Couldn\'t load project' }

app.post '/projects', (req, res) ->
  console.log 'saving new project'
  Project = mongoose.model 'project'
  project = new Project()
  for k,v of req.body
    project[k] = v
  project.created = new Date()
  project.changed = new Date()
  project.save (err) ->
    unless err
      res.json id: project._id

app.put '/projects/:id', (req, res) ->
  console.log 'updating an project'
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project?
      for k,v of req.body
        if k is 'id' then continue
        project[k] = v
      project.changed = new Date()
      project.save()
      res.json {
        saved: true
        changed: project.changed
      }

app.del '/projects/:id', (req, res) ->
  console.log 'deleting an project'
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project?
      project.remove()
      project.save()

# REST endpoint for Tags
getAllTags = (callback) ->
  Tag = mongoose.model 'tag'
  query = Tag.find()
  query
    .notEqualTo('deleted', true)
    .run (err, tags) ->
      unless err or not tags?
        for tag in tags
          tag.setValue('id', tag.getValue('_id'))
        callback(tags)

app.get '/tags', (req, res) ->
  console.log 'getting tags'
  if req.query.ids?
    queryMultiple 'tag', req.query.ids, (tags) ->
      res.json tags
  else
    getAllTags (tags) ->
      res.json tags

app.get '/tags/:id', (req, res) ->
  Tag = mongoose.model 'tag'
  Tag.findById req.params.id, (err, tag) ->
    unless err or not tag?
      console.log 'Getting tag: ' + tag.name
      res.json tag
    else
      res.json { error: 'Couldn\'t load tag' }

app.post '/tags', (req, res) ->
  console.log 'saving new tag'
  Tag = mongoose.model 'tag'
  tag = new Tag()
  for k,v of req.body
    tag[k] = v
  tag.created = new Date()
  tag.changed = new Date()
  tag.save (err) ->
    unless err
      res.json id: tag._id

app.put '/tags/:id', (req, res) ->
  console.log 'updating an tag'
  Tag = mongoose.model 'tag'
  Tag.findById req.params.id, (err, tag) ->
    unless err or not tag?
      for k,v of req.body
        if k is 'id' then continue
        tag[k] = v
      tag.changed = new Date()
      tag.save()
      res.json {
        saved: true
        changed: tag.changed
      }

app.del '/tag/:id', (req, res) ->
  console.log 'deleting an tag'
  Tag = mongoose.model 'tag'
  Tag.findById req.params.id, (err, tag) ->
    unless err or not tag?
      tag.remove()
      tag.save()

# Listen on port 3000 or a passed-in port
args = process.argv.splice(2)
if args[0]? then port = parseInt(args[0], 10) else port = 3000
app.listen(port)
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
