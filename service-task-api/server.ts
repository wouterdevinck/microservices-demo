import * as express from "express"
import { Request, Response } from "express"

const app = express()

app.get("/", (req: Request, res: Response) => {
  res.send("hello");
})

app.listen(4200, () => {
  console.log('[INFO] Web server listening on port 4200...')
})