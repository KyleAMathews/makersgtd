mongoose = require('mongoose')
bcrypt = require 'bcrypt'
# Setup MongoDB connection.
mongoose.connect('mongodb://localhost/simpleGTD')

# Setup MongoDB schemas.
Schema = mongoose.Schema

ActionSchema = new Schema (
  name: String
  description: String
  done: { type: Boolean, index: true }
  deleted: { type: Boolean, default: false, index: true }
  order: Number
  completed: { type:Date, index: true }
  created: Date
  changed: { type: Date, index: true }
  project_links: []
  tag_links: []
)

ProjectSchema = new Schema (
  name: String
  outcome_vision: String
  description: String
  done: { type: Boolean, index: true }
  deleted: { type: Boolean, default: false, index: true }
  completed: { type:Date, index: true }
  created: Date
  changed: { type: Date, index: true }
  tag_links: []
  action_links: []
)

TagSchema = new Schema (
  name: String
  description: String
  deleted: { type: Boolean, default: false, index: true }
  created: Date
  changed: { type: Date, index: true }
  color_palette: Number
  action_links: []
  project_links: []
)

toLower = (v) ->
  return v.toLowerCase()

UserSchema = new Schema (
  name: String
  email: { type: String, unique: true, set: toLower }
  password: String
)

UserSchema.methods.setPassword = (password, done) ->
  console.log 'inside setPassword'
  bcrypt.genSalt 10, (err, salt) =>
    bcrypt.hash password, salt, (err, hash) =>
      console.log 'hash ', hash
      @password = hash
      done()

UserSchema.methods.verifyPassword = (password, callback) ->
  console.log password
  console.log @
  bcrypt.compare(password, @password, callback);

UserSchema.statics.authenticate = (email, password, callback) ->
  email = toLower(email)
  @findOne { email: email }, (err, user) ->
    if err then return callback err
    if not user then return callback null, false
    user.verifyPassword password, (err, passwordCorrect) ->
      if err then return callback err
      if not passwordCorrect then return callback null, false
      # Successful authentication!
      callback null, user

mongoose.model 'action', ActionSchema
mongoose.model 'project', ProjectSchema
mongoose.model 'tag', TagSchema
mongoose.model 'user', UserSchema
