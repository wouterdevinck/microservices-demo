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

  private apiUri = "http://localhost:4200/api/v1/tasks";

  public tasks: TaskModel[]

  constructor(@Inject(HttpClient) private http: HttpClient) {}

  ngOnInit() {
    this.http.get<TaskModel[]>(this.apiUri).subscribe(data => this.tasks = data)
  }

  eventHandler(event) {
    console.log(event, event.keyCode, event.keyIdentifier);
  }

}