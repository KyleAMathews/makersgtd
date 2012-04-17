express = require('express')
RedisStore = require('connect-redis')(express)
util = require('util')
_ = require('underscore')
moment = require('moment')
mongoose = require('mongoose')
passport = require 'passport'
require('./mongoose_schemas')

app = express.createServer()

# Return index.jade if html is requested, otherwise return JSON or static files.
htmlOrNot =
  handle: (req, res, next) ->
    # Let request through if the person is requesting from /login
    # and isn't authenticated.
    if req.url is '/login' or (req.url isnt '/' and req.headers.referer?.slice(-5) is 'login')
      unless req.isAuthenticated()
        return next()
      # If the person is already authenticated redirect them back home.
      else
        return res.redirect '/'

    # Requests to /logout should be let through.
    if _.include ['/logout'], req.url
      return next()

    # If the person is requestion html and they are authenticated, return full monty.
    if req.headers.accept? and req.headers.accept.indexOf('text/html') isnt -1
      unless req.isAuthenticated() then return res.redirect '/login'
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
      getAllModels('action', req.user, (actions) -> counter.add( actions_json: actions ))
      getAllModels('project', req.user, (projects) -> counter.add( projects_json: projects ))
      getAllContexts req.user, (contexts) -> counter.add( contexts_json: contexts )

    # Every request by this point should be authenticated.
    else if not req.isAuthenticated()
      res.json 'Not authenticated', 403
    # Only requests at this point should be browsers requesting JSON.
    else
      next()

# Setup Express middleware.
app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.cookieParser()
  app.use express.responseTime()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.session({ store: new RedisStore, secret: 'Make Stuff', cookie: { maxAge: 1209600000 }}) # two weeks
  app.use passport.initialize()
  app.use passport.session()
  app.use htmlOrNot
  app.use app.router
  app.use express.static __dirname + '/public'


queryMultiple = (type, ids, user, callback) ->
  ModelObj = mongoose.model type
  query = ModelObj.find()
  query
    .where('_id').in(ids)
    .notEqualTo('deleted', true)
    .where('_user', user._id)
    .run (err, models) ->
      unless err or not models?
        newModels = []
        for model in models
          model.setValue('id', model.getValue('_id'))
        callback(models)

getAllModels = (type, user, callback) ->
  modelType = mongoose.model type
  date = moment().subtract('hours', 12)
  query = modelType.find()
  query
    # Only get completed actions from past 12 hours.
    .or([{ 'done': false }, {'completed': { $gte : date.native()}}])
    .notEqualTo('deleted', true)
    .where('_user', user._id)
    .run (err, models) ->
      unless err or not models?
        newModels = []
        for model in models
          model.setValue('id', model.getValue('_id'))
        callback(models)

app.get '/login', (req, res) ->
  json =
    contexts_json: {}
    projects_json: {}
    actions_json: {}
    errorMessages: []
  messages = req.flash()
  if messages.error?
    json.errorMessages = messages.error
  res.render 'login', json

app.post '/login', passport.authenticate('local',
  {
    successRedirect: '/'
    failureRedirect: '/login'
    failureFlash: true
  })

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/login'

app.get '/', (req, res) ->
  res.render 'index'

# REST endpoint for Actions
app.get '/actions', (req, res) ->
  if req.query.ids?
    queryMultiple 'action', req.query.ids, req.user, (models) ->
      res.json models

  else
    getAllModels 'action', req.user, (actions) ->
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
  action._user = req.user._id.toString()
  action.save (err) ->
    unless err
      res.json id: action._id, created: action.created

app.put '/actions/:id', (req, res) ->
  console.log 'updating an action'
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action? or action._user.toString() isnt req.user._id.toString()
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
    unless err or not action? or action._user.toString() isnt req.user._id.toString()
      action.remove()
      action.save()

# REST endpoint for Projects
app.get '/projects', (req, res) ->
  console.log 'getting projects'
  if req.query.ids?
    queryMultiple 'project', req.query.ids, req.user, (models) ->
      res.json models

  else
    getAllModels 'project', req.user, (projects) ->
      res.json projects

app.get '/projects/:id', (req, res) ->
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project? or project._user.toString() isnt req.user._id.toString()
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
  project._user = req.user._id.toString()
  project.save (err) ->
    unless err
      res.json id: project._id, created: project.created

app.put '/projects/:id', (req, res) ->
  console.log 'updating an project'
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project? or project._user.toString() isnt req.user._id.toString()
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
    unless err or not project? or project._user.toString() isnt req.user._id.toString()
      project.remove()
      project.save()

# REST endpoint for Contexts
getAllContexts = (user, callback) ->
  Context = mongoose.model 'context'
  query = Context.find()
  query
    .notEqualTo('deleted', true)
    .where('_user', user._id)
    .run (err, contexts) ->
      unless err or not contexts?
        for context in contexts
          context.setValue('id', context.getValue('_id'))
        callback(contexts)

app.get '/contexts', (req, res) ->
  console.log 'getting contexts'
  if req.query.ids?
    queryMultiple 'context', req.query.ids, req.user, (contexts) ->
      res.json contexts
  else
    getAllContexts req.user, (contexts) ->
      res.json contexts

app.get '/contexts/:id', (req, res) ->
  Context = mongoose.model 'context'
  Context.findById req.params.id, (err, context) ->
    unless err or not context? or context._user.toString() isnt req.user._id.toString()
      console.log 'Getting context: ' + context.name
      res.json context
    else
      res.json { error: 'Couldn\'t load context' }

app.post '/contexts', (req, res) ->
  console.log 'saving new context'
  Context = mongoose.model 'context'
  context = new Context()
  for k,v of req.body
    context[k] = v
  context.created = new Date()
  context.changed = new Date()
  context._user = req.user._id.toString()
  context.save (err) ->
    unless err
      res.json id: context._id, created: context.created

app.put '/contexts/:id', (req, res) ->
  console.log 'updating an context'
  Context = mongoose.model 'context'
  Context.findById req.params.id, (err, context) ->
    unless err or not context? or context._user.toString() isnt req.user._id.toString()
      for k,v of req.body
        if k is 'id' then continue
        context[k] = v
      context.changed = new Date()
      context.save()
      res.json {
        saved: true
        changed: context.changed
      }

app.del '/context/:id', (req, res) ->
  console.log 'deleting an context'
  Context = mongoose.model 'context'
  Context.findById req.params.id, (err, context) ->
    unless err or not context? or context._user.toString() isnt req.user._id.toString()
      context.remove()
      context.save()

# Listen on port 3000 or a passed-in port
args = process.argv.splice(2)
if args[0]? then port = parseInt(args[0], 10) else port = 3000
app.listen(port)
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
