import { Component, ViewEncapsulation, OnInit, Inject } from '@angular/core'
import { HttpClient } from '@angular/common/http'
import { TaskModel } from './taskmodel'

@Component({
  selector: 'app-root',
  //templateUrl: './app.component.html',
  //styleUrls: [ './styles.css' ],
  template: ' \
  <div class="container"> \
  \
    <div class="py-5 text-center"> \
      <i class="material-icons logo">done_all</i> \
      <h2>Task list app</h2> \
    </div> \
    \
    <ul class="list-group"> \
      <li class="list-group-item list-group-item-action"  \
        *ngFor="let task of tasks" (click)="check(task._id)"> \
        <div class="custom-control custom-checkbox"> \
          <input type="checkbox" class="custom-control-input"  \
            id="chk{{ task._id }}" [checked]="task.done" \
            (change)="check(task._id, $event)" disabled> \
          <label class="custom-control-label" for="chk{{ task._id }}"  \
            [ngClass]="{\'done\': task.done}"> \
            {{ task.description }} \
          </label> \
          <i class="material-icons delete" (click)="delete(task._id)">delete</i> \
        </div> \
      </li>   \
      <li class="list-group-item"> \
        <input type="text" class="form-control" placeholder="Create new task..."  \
          (keypress)="keypress($event)" [(ngModel)]="newTask"> \
      </li> \
    </ul> \
    \
    <footer class="my-5 text-muted text-center text-small"> \
      <p class="mb-1">&copy; 2018 Wouter Devinck</p> \
      <ul class="list-inline"> \
        <li class="list-inline-item"><a href="https://github.com/wouterdevinck/microservices-demo">Source code</a></li> \
        <li class="list-inline-item">-</li> \
        <li class="list-inline-item"><a href="https://www.apache.org/licenses/LICENSE-2.0">License</a></li> \
      </ul> \
    </footer> \
    \
  </div>  \
    ',
    styles: ['  \
    .logo {   \
      font-size: 72px;   \
      color: darkblue;   \
    }  \
    .container {  \
      max-width: 800px;  \
    }  \
    .done {  \
      text-decoration: line-through;  \
    }  \
    .custom-control-label {  \
      margin-left: 8px;  \
      padding-top: 1px;  \
    }  \
    .custom-control-input:disabled~.custom-control-label {  \
      color: black;  \
    }  \
    .delete {  \
      float: right;  \
      font-size: 1.3em;  \
      padding-top: 4px;  \
      color: lightgrey;  \
    }  \
    .delete:hover {  \
      color: red;  \
      cursor: pointer;  \
    }  \
    .text-small {  \
      font-size: x-small;  \
    }  \
    '],
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