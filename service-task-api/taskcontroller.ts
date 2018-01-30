import { Request, Response } from "express"
import { Task } from "./taskmodel"

export class TaskController {

  public GetAll = async (req: Request, res: Response) => {
    res.contentType('application/json')
    let all = await Task.find().exec()
    res.send(all)
  }
  
  public Create = async (req: Request, res: Response) => {
    res.contentType('application/json')
    //console.log(req.body)
    let task = await Task.create(req.body)
    task.save()
    res.send(task)
  }

}