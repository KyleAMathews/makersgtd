express = require('express')
mongoose = require('mongoose')

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
)

projectSchema = new Schema (
  name: String
)

tagSchema = new Schema (
  name: String
)

mongoose.model 'action', actionSchema
mongoose.model 'project', projectSchema
mongoose.model 'tag', tagSchema


# REST endpoint for Actions
app.get '/actions', (req, res) ->
  console.log 'getting actions'
  Action = mongoose.model 'action'
  Action.find (err, actions) ->
    unless err or not actions?
      # For some reason, we can't set an id attribute directly on the result object.
      # So we create a copy.
      newModels = []
      for action in actions
        m =
          name: action.name
          id: action._id
        newModels.push m

      res.json newModels

app.post '/actions', (req, res) ->
  console.log 'saving new action'
  Action = mongoose.model 'action'
  action = new Action(
    name: req.body.name
  )
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
      action.save()

app.del '/actions/:id', (req, res) ->
  console.log 'deleting an action'
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action?
      action.remove()
      action.save()

# REST endpoint for Projects
app.get '/projects', (req, res) ->
  Project = mongoose.model 'project'
  Project.find (err, projects) ->
    unless err or not projects?
      # For some reason, we can't set an id attribute directly on the result object.
      # So we create a copy.
      newModels = []
      for project in projects
        m =
          name: project.name
          id: action._id
        newModels.push m

      res.json newModels

app.post '/projects', (req, res) ->
  console.log 'saving new project'
  Project = mongoose.model 'project'
  project = new Project(
    name: req.body.name
  )
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
      project.save()

app.del '/projects/:id', (req, res) ->
  console.log 'deleting an project'
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project?
      project.remove()
      project.save()

# REST endpoint for Tags
app.get '/tags', (req, res) ->
  Tag = mongoose.model 'tag'
  Tag.find (err, tags) ->
    unless err or not tags?
      # For some reason, we can't set an id attribute directly on the result object.
      # So we create a copy.
      newModels = []
      for tag in tags
        m =
          name: tag.name
          id: tag._id
        newModels.push m

      res.json newModels

app.post '/tags', (req, res) ->
  console.log 'saving new tag'
  Tag = mongoose.model 'tag'
  tag = new Tag(
    name: req.body.name
  )
  tag.save (err) ->
    if err then console.log err
    res.json id: tag._id

app.put '/tags/:id', (req, res) ->
  console.log 'updating an tag'
  Tag = mongoose.model 'tag'
  Tag.findById req.params.id, (err, tag) ->
    unless err or not tag?
      for k,v of req.body
        if k is 'id' then continue
        tag[k] = v
      tag.save()

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
