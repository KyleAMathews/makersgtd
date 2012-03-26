mongoose = require('mongoose')
# Setup MongoDB connection.
mongoose.connect('mongodb://localhost/simpleGTD')

# Setup MongoDB schemas.
Schema = mongoose.Schema

actionSchema = new Schema (
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

projectSchema = new Schema (
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

tagSchema = new Schema (
  name: String
  description: String
  deleted: { type: Boolean, default: false, index: true }
  created: Date
  changed: { type: Date, index: true }
  color_palette: Number
  action_links: []
  project_links: []
)

userSchema = new Schema (
  name: String
  email: String
)

mongoose.model 'action', actionSchema
mongoose.model 'project', projectSchema
mongoose.model 'tag', tagSchema
mongoose.model 'user', userSchema
