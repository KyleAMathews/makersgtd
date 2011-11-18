express = require('express')
mongoose = require('mongoose')

app = express.createServer()

# Setup Express middleware.
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static __dirname + '/brunch'

# Setup a MongoDb connection and schema.
mongoose.connect('mongodb://localhost/simple_gtd')
Schema = mongoose.Schema

# statSchema = new Schema (
#     numAttendees: Number
#     date: type: Date, default: new Date()
#   )

# groupSchema = new Schema (
#     id: Number
#     name: String
#     leader: String
#     leaderNumber: String
#     stats: [statSchema]
#   )

# Group = mongoose.model 'group', groupSchema


app.listen(3000)
