import * as express from "express"
import * as mongoose from "mongoose"
import * as bodyParser from "body-parser"
import { TaskController } from "./taskcontroller"

let mongo = 'mongodb://127.0.0.1/tasks'
let base = '/api/v1/'

const app = express()
app.use(bodyParser.json())

app.listen(4200, () => {
  console.log('[INFO] Web server listening on port 4200...')

  mongoose.connect(mongo, (err) => {
    if (err) {
      console.log('[ERROR]' + err.message)
      console.log('[ERROR]' + err)
    } else {
      console.log('[INFO] Connected to MongoDB')
      
      let controller = new TaskController()
      app.get(base + 'tasks', controller.GetAll)
      app.put(base + 'tasks', controller.Create)

    }
  })

})