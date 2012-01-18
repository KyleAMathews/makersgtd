express = require('express')
mongoose = require('mongoose')
util = require('util')
_und = require('underscore')
moment = require('moment')

app = express.createServer()

# Setup Express middleware.
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static __dirname + '/brunch'

# Setup MongoDB connection.
mongoose.connect('mongodb://localhost/simpleGTD')

# Setup MongoDB schemas.
Schema = mongoose.Schema

actionSchema = new Schema (
  name: String
  description: String
  done: Boolean
  deleted: { type: Boolean, default: false }
  order: Number
  completed: Date
  created: Date
  changed: Date
  project_links: []
  tag_links: []
)

projectSchema = new Schema (
  name: String
  outcome_vision: String
  description: String
  done: Boolean
  deleted: { type: Boolean, default: false }
  completed: Date
  created: Date
  changed: Date
  tag_links: []
  action_links: []
)

tagSchema = new Schema (
  name: String
  description: String
  deleted: { type: Boolean, default: false }
  created: Date
  changed: Date
  action_links: []
  project_links: []
)

mongoose.model 'action', actionSchema
mongoose.model 'project', projectSchema
mongoose.model 'tag', tagSchema

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


# REST endpoint for Actions
app.get '/actions', (req, res) ->
  console.log 'getting actions'
  if req.query.ids?
    queryMultiple 'action', req.query.ids, (models) ->
      res.json models

  else
    Action = mongoose.model 'action'
    date = moment().subtract('hours', 12)
    query = Action.find()
    query
      # Only get completed actions from past 12 hours.
      .or([{ 'done': false }, {'completed': { $gte : date.native()}}])
      .notEqualTo('deleted', true)
      .run (err, actions) ->
        unless err or not actions?
          newModels = []
          for action in actions
            action.setValue('id', action.getValue('_id'))

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
    Project = mongoose.model 'project'
    date = moment().subtract('hours', 12)
    query = Project.find()
    query
      # Only get completed actions from past 12 hours.
      .or([{ 'done': false }, {'completed': { $gte : date.native()}}])
      .notEqualTo('deleted', true)
      .run (err, projects) ->
        unless err or not projects?
          for project in projects
            project.setValue('id', project.getValue('_id'))

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
app.get '/tags', (req, res) ->
  console.log 'getting tags'
  Tag = mongoose.model 'tag'
  query = Tag.find()
  query
    .notEqualTo('deleted', true)
    .run (err, tags) ->
      unless err or not tags?
        for tag in tags
          tag.setValue('id', tag.getValue('_id'))

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

# Listen on port 3000
app.listen(3000)
console.log "Listening on port 3000"
