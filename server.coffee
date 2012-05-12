express = require('express')
RedisStore = require('connect-redis')(express)
util = require('util')
_ = require('underscore')
moment = require('moment')
mongoose = require('mongoose')
passport = require 'passport'
StatsD = require('node-statsd').StatsD
c = new StatsD('ec2-50-19-206-59.compute-1.amazonaws.com',8125)
logger_statsd = require "connect-logger-statsd"
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

    # Requests to /logout or /admin should be let through.
    if _.include ['/logout', '/admin'], req.url
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
              # Load user data off request object.
              user_json = _.pick req.user, 'email', 'name', '_id'
              user_json.id = user_json._id
              delete user_json._id
              json.user_json = user_json

              res.render 'index', json
              c.increment('page.index')
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
  app.use logger_statsd({
    host: "ec2-50-19-206-59.compute-1.amazonaws.com",
    port: 8125,
    prefix: "express."
  })
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
  start = Date.now()
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
      c.timing('mongodb.' + type + '.queryMultiple', Date.now() - start)
      c.increment('mongodb.' + type + '.queryMultiple')

getAllModels = (type, user, callback) ->
  start = Date.now()
  modelType = mongoose.model type
  date = moment().subtract('hours', 12)
  query = modelType.find()
  query
    # Only get completed actions from past 12 hours.
    .or([{ 'done': false }, {'completed': { $gte : date.toDate()}}])
    .notEqualTo('deleted', true)
    .where('_user', user._id)
    .run (err, models) ->
      unless err or not models?
        newModels = []
        for model in models
          model.setValue('id', model.getValue('_id'))
        callback(models)
        c.timing('mongodb.' + type + ".getAllModels", Date.now() - start)
        c.increment('mongodb.' + type + '.getAllModels')

app.get '/login', (req, res) ->
  json =
    contexts_json: {}
    projects_json: {}
    actions_json: {}
    user_json: {}
    errorMessages: []
  messages = req.flash()
  if messages.error?
    json.errorMessages = messages.error
  res.render 'login', json
  c.increment('page.login')

app.post '/login', passport.authenticate('local',
  {
    successRedirect: '/'
    failureRedirect: '/login'
    failureFlash: true
  })

app.get '/admin', (req, res) ->
  if req.user._id.toString() isnt '4f83a4a6c91a7bb959000001'
    res.send "Access denied", 403

  json =
    contexts_json: {}
    projects_json: {}
    actions_json: {}
    user_json: {}
    errorMessages: []

  # Load every user.
  User = mongoose.model 'user'
  User.find {}, ['name', 'email', '_id'], (err, users) ->
    clean = []
    for user in users
      clean.push _.pick(user, 'name', 'email', '_id')
    json.users = clean
    res.render 'admin', json
    c.increment('page.admin')

app.post '/admin', (req, res) ->
  console.log req.body
  if req.body.name is "" or req.body.email is "" then res.redirect '/admin'

  User = mongoose.model 'user'
  user = new User()
  user.name = req.body.name
  user.email = req.body.email
  user.created = new Date()
  user.changed = new Date()
  user.setPassword 'password', ->
    user.save (err) ->
      console.log 'new user was created'
      res.redirect '/admin'
      # Send person an email w/ info about what's happening here + their login info
      # Send from my email address + w/ mailgun.
      #
      # write the email
      # create class for sending the email -- or I guess borrow my old one.
      # hook up mixpanel actually as well.

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/login'

  c.increment('page.logout')
  c.increment('user.logout')

app.get '/', (req, res) ->
  res.render 'index'

  c.increment('page.index')

# REST endpoint for Actions
app.get '/actions', (req, res) ->
  if req.query.ids?
    queryMultiple 'action', req.query.ids, req.user, (models) ->
      res.json models

  else
    getAllModels 'action', req.user, (actions) ->
      res.json actions

app.get '/actions/:id', (req, res) ->
  start = Date.now()
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action?
      console.log 'Getting action: ' + action.name
      res.json action
    else
      res.json { error: 'Couldn\'t load action' }
    c.timing('mongodb.action.get', Date.now() - start)
    c.increment('mongodb.action.get')

app.post '/actions', (req, res) ->
  start = Date.now()
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
      c.timing('mongodb.action.post', Date.now() - start)
      c.increment('mongodb.action.post')

app.put '/actions/:id', (req, res) ->
  start = Date.now()
  console.log 'updating an action'
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action? or action._user.toString() isnt req.user._id.toString()
      for k,v of req.body
        if k is 'id' then continue
        action[k] = v
      action.changed = new Date()
      action.save (err) ->
        res.json {
          saved: true
          changed: action.changed
        }
        c.timing('mongodb.action.put', Date.now() - start)
        c.increment('mongodb.action.put')

app.del '/actions/:id', (req, res) ->
  start = Date.now()
  console.log 'deleting an action'
  Action = mongoose.model 'action'
  Action.findById req.params.id, (err, action) ->
    unless err or not action? or action._user.toString() isnt req.user._id.toString()
      action.remove()
      action.save (err) ->
        c.timing('mongodb.action.delete', Date.now() - start)
        c.increment('mongodb.action.delete')

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
  start = Date.now()
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project? or project._user.toString() isnt req.user._id.toString()
      console.log 'Getting project: ' + project.name
      res.json project
    else
      res.json { error: 'Couldn\'t load project' }
    c.timing('mongodb.project.get', Date.now() - start)
    c.increment('mongodb.project.get')

app.post '/projects', (req, res) ->
  start = Date.now()
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
      c.timing('mongodb.project.post', Date.now() - start)
      c.increment('mongodb.project.post')

app.put '/projects/:id', (req, res) ->
  start = Date.now()
  console.log 'updating an project'
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project? or project._user.toString() isnt req.user._id.toString()
      for k,v of req.body
        if k is 'id' then continue
        project[k] = v
      project.changed = new Date()
      project.save (err) ->
        res.json {
          saved: true
          changed: project.changed
        }
        c.timing('mongodb.project.put', Date.now() - start)
        c.increment('mongodb.project.put')

app.del '/projects/:id', (req, res) ->
  start = Date.now()
  console.log 'deleting an project'
  Project = mongoose.model 'project'
  Project.findById req.params.id, (err, project) ->
    unless err or not project? or project._user.toString() isnt req.user._id.toString()
      project.remove()
      project.save (err) ->
        res.json 'project deleted'
        c.timing('mongodb.project.delete', Date.now() - start)
        c.increment('mongodb.project.delete')

# REST endpoint for Contexts
getAllContexts = (user, callback) ->
  start = Date.now()
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
        c.timing('mongodb.context.getAllModels', Date.now() - start)

app.get '/contexts', (req, res) ->
  console.log 'getting contexts'
  if req.query.ids?
    queryMultiple 'context', req.query.ids, req.user, (contexts) ->
      res.json contexts
  else
    getAllContexts req.user, (contexts) ->
      res.json contexts

app.get '/contexts/:id', (req, res) ->
  start = Date.now()
  Context = mongoose.model 'context'
  Context.findById req.params.id, (err, context) ->
    unless err or not context? or context._user.toString() isnt req.user._id.toString()
      console.log 'Getting context: ' + context.name
      res.json context
    else
      res.json { error: 'Couldn\'t load context' }
      c.timing('mongodb.context.get', Date.now() - start)
      c.increment('mongodb.context.get')

app.post '/contexts', (req, res) ->
  start = Date.now()
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
      c.timing('mongodb.context.post', Date.now() - start)
      c.increment('mongodb.context.post')

app.put '/contexts/:id', (req, res) ->
  start = Date.now()
  console.log 'updating an context'
  Context = mongoose.model 'context'
  Context.findById req.params.id, (err, context) ->
    unless err or not context? or context._user.toString() isnt req.user._id.toString()
      for k,v of req.body
        if k is 'id' then continue
        context[k] = v
      context.changed = new Date()
      context.save (err) ->
        res.json {
          saved: true
          changed: context.changed
        }
        c.timing('mongodb.context.put', Date.now() - start)
        c.increment('mongodb.context.put')

app.del '/context/:id', (req, res) ->
  start = Date.now()
  console.log 'deleting an context'
  Context = mongoose.model 'context'
  Context.findById req.params.id, (err, context) ->
    unless err or not context? or context._user.toString() isnt req.user._id.toString()
      context.remove()
      context.save (err) ->
        res.json 'context deleted'
        c.timing('mongodb.context.del', Date.now() - start)
        c.increment('mongodb.context.del')

app.put '/users/:id', (req, res) ->
  start = Date.now()
  # Check the model to be saved is the same as the
  # logged in user.
  if req.params.id isnt req.user._id.toString()
    res.json 'Forbidden', 403
    return
  User = mongoose.model 'user'
  User.findById req.params.id, (err, user) ->
    unless err or not user?
      for k,v of req.body
        if k is 'id' then continue
        if k is 'password' then continue
        user[k] = v
      user.changed = new Date()

      # Callback
      saveUser = (user) ->
        user.save (err) ->
          user_json = _.pick user, 'email', 'name'
          res.json {
            changed: user.changed
          }
          c.timing('mongodb.user.put', Date.now() - start)
          c.increment('mongodb.user.put')

      # If a password was sent, save it.
      if req.body.password?
        user.setPassword req.body.password, ->
          saveUser(user)
      else
        saveUser(user)


# Listen on port 3000 or a passed-in port
args = process.argv.splice(2)
if args[0]? then port = parseInt(args[0], 10) else port = 3000
app.listen(port)
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
