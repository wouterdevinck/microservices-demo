import { Component, ViewEncapsulation, OnInit, Inject } from '@angular/core'
import { HttpClient } from '@angular/common/http'
import { TaskModel } from './taskmodel'

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: [ './styles.css' ],
  encapsulation: ViewEncapsulation.None
})
export class AppComponent implements OnInit {

  private apiUri = (document.location.href.indexOf("localhost") >= 0 ? 
    "http://localhost:4200" : "") + "/api/v1/tasks/"

  public tasks: TaskModel[]
  public newTask: String

  constructor(@Inject(HttpClient) private http: HttpClient) {}

  ngOnInit() {
    this.http.get<TaskModel[]>(this.apiUri).subscribe(tasks => this.tasks = tasks)
  }

  keypress(event: KeyboardEvent) {
    if (event.key == "Enter") { 
      console.log("[INFO] Create new task")
      let task = new TaskModel() 
      task.done = false
      task.description = this.newTask
      this.newTask= ""
      this.http.put<TaskModel>(this.apiUri, task).subscribe(t => {
        task._id = t._id
        this.tasks.push(task)
      })
    }
  }

  delete(id: String) {
    console.log("[INFO] Delete task " + id)
    let i = this.tasks.findIndex((v, _, __) => v._id === id)
    this.tasks.splice(i, 1)
    this.http.delete(this.apiUri + id).subscribe()
  }

  check(id: String) {
    console.log("[INFO] Check/uncheck task " + id)
    let task = this.tasks.find((v, _, __) => v._id === id)
    if (!task) return
    task.done = !task.done
    this.http.post(this.apiUri + id, task).subscribe()
  }

}