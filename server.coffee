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
  completed: Date
  created: Date
  changed: Date
  tag_links: []
  action_links: []
)

tagSchema = new Schema (
  name: String
  description: String
  created: Date
  changed: Date
  action_links: []
  project_links: []
)

mongoose.model 'action', actionSchema
mongoose.model 'project', projectSchema
mongoose.model 'tag', tagSchema


# REST endpoint for Actions
app.get '/actions', (req, res) ->
  console.log 'getting actions'
  Action = mongoose.model 'action'
  query = Action.find()
  date = moment().subtract('hours', 12)
  query
    # Only get completed actions from past 12 hours.
    .or([{ 'done': false }, {'completed': { $gte : date.native()}}])
    .run (err, actions) ->
      unless err or not actions?
        newModels = []
        for action in actions
          action.setValue('id', action.getValue('_id'))

        res.json actions

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
  Project = mongoose.model 'project'
  Project.find (err, projects) ->
    unless err or not projects?
      for project in projects
        project.setValue('id', project.getValue('_id'))

      res.json projects

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
  Tag.find (err, tags) ->
    unless err or not tags?
      for tag in tags
        tag.setValue('id', tag.getValue('_id'))

      res.json tags

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
