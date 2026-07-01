import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-not-found',
  standalone: true,
  imports: [RouterLink],
  template: `
    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 60vh; text-align: center;">
      <h1 style="font-size: 5rem; margin-bottom: 10px; background: var(--accent-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">404</h1>
      <p style="font-size: 1.2rem; color: var(--text-secondary); margin-bottom: 25px;">The page you are looking for does not exist.</p>
      <a routerLink="/home" style="padding: 10px 20px; background: var(--accent-gradient); color: white; border-radius: 6px; text-decoration: none; font-weight: bold; box-shadow: var(--shadow-glow);">Go to Dashboard</a>
    </div>
  `
})
export class NotFound {}
