import { Request, Response } from "express"
import { Task } from "./taskmodel"

export class TaskController {

  public GetAll = async (req: Request, res: Response) => {
    res.contentType('application/json')
    try {
      let all = await Task.find().exec()
      res.send(all)
    } catch (ex) {
      res.status(500).send()
    }
  }

  public Get = async (req: Request, res: Response) => {
    res.contentType('application/json')
    try {
      let id = req.params.id
      let task = await Task.findById(id).exec()
      res.send(task)
    } catch (ex) {
      res.status(500).send()
    }
  }
  
  public Create = async (req: Request, res: Response) => {
    res.contentType('application/json')
    try {
      let task = await Task.create(req.body)
      task.save()
      res.send(task)
    } catch (ex) {
      res.status(500).send()
    }
  }
  
  public Delete = async (req: Request, res: Response) => {
    res.contentType('application/json')
    try {
      let id = req.params.id
      await Task.findByIdAndRemove(id).exec()
      res.send()
    } catch (ex) {
      res.status(500).send()
    }
  }
  
  public Update = async (req: Request, res: Response) => {
    res.contentType('application/json')
    try {
      let id = req.params.id
      if(await Task.findByIdAndUpdate(id, req.body).exec()) {
        res.send()
      } else {
        res.status(404).send()
      }
    } catch (ex) {
      res.status(500).send()
    }
  }

}