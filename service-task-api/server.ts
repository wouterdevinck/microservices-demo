import * as express from "express"
import * as mongoose from "mongoose"
import * as bodyParser from "body-parser"
import { TaskController } from "./taskcontroller"

const baseUrl = '/api/v1/'
const dbUrl = process.env.DB_URL

if (dbUrl === undefined) {
  throw new Error('DB_URL not defined in environment')
}

const app = express()
app.use(bodyParser.json())

app.listen(4200, () => {
  console.log('[INFO] Web server listening on port 4200...')

  mongoose.connect(dbUrl, (err) => {
    if (err) {
      console.log('[ERROR]' + err.message)
      console.log('[ERROR]' + err)
    } else {
      console.log('[INFO] Connected to MongoDB')
      
      let controller = new TaskController()
      app.get(baseUrl + 'tasks', controller.GetAll)
      app.put(baseUrl + 'tasks', controller.Create)

    }
  })

})