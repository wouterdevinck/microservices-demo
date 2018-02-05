import { Component, ViewEncapsulation, OnInit, Inject} from '@angular/core'
import { HttpClient } from '@angular/common/http'
import { TaskModel } from './taskmodel'

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: [ './styles.css' ],
  encapsulation: ViewEncapsulation.None
})
export class AppComponent implements OnInit {

  private apiUri = "http://localhost:4200/api/v1/tasks/";

  public tasks: TaskModel[]
  public newTask: String

  constructor(@Inject(HttpClient) private http: HttpClient) {}

  ngOnInit() {
    this.http.get<TaskModel[]>(this.apiUri).subscribe(tasks => this.tasks = tasks)
  }

  keypress(event: KeyboardEvent) {
    if (event.key == "Enter") { 
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
    this.http.delete(this.apiUri + id).subscribe(_ => {
      let i = this.tasks.findIndex((v, _, __) => {
        return v._id === id
      })
      this.tasks.splice(i, 1)
    })
  }

}