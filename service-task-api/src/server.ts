import * as express from "express"
import * as mongoose from "mongoose"
import * as bodyParser from "body-parser"
import { TaskController } from "./taskcontroller"

const baseUrl = '/api/v1/'
const dbUrl = process.env.DB_URL
const enableCors = process.env.ENABLE_CORS

if (dbUrl === undefined) {
  throw new Error('DB_URL not defined in environment')
}

const app = express()
app.use(bodyParser.json())

if (enableCors === "true") {
  console.log("[WARNING] CORS was enabled");
  app.use(function(req, res, next) {
      res.header("Access-Control-Allow-Origin", "http://localhost:4300");
      res.header("Access-Control-Allow-Methods", "GET, DELETE, POST");
      res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
      next();
  })
}

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
      app.get(baseUrl + 'tasks/:id/', controller.Get)
      app.delete(baseUrl + 'tasks/:id/', controller.Delete)
      app.post(baseUrl + 'tasks/:id/', controller.Update)

    }
  })

})