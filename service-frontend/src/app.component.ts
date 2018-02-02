import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  styles: [`
    
  `],
  template: `
    <h1>Angular</h1>
    <p>{{ message }}</p>
  `
})
export class AppComponent {
  message = 'Hello world.';
}