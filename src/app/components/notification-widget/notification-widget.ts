import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NotificationService } from '../../services/notification.service';

@Component({
  selector: 'app-notification-widget',
  standalone: true,
  imports: [CommonModule],
  providers: [NotificationService], // Scoped component-level provider
  template: `
    <div class="notifications-box">
      <h4>Local Component Notifications</h4>
      <ul>
        <li *ngFor="let note of notifications">{{ note }}</li>
      </ul>
      <p class="di-explanation">
        <strong>DI Scope Note:</strong> This component uses a scoped instance of <code>NotificationService</code> via <code>providers: [NotificationService]</code>. This ensures that this component instance operates on its own dedicated state, isolated from other widgets or root-level singleton injections.
      </p>
    </div>
  `,
  styles: [`
    .notifications-box {
      background: rgba(255, 255, 255, 0.02);
      border: 1px solid var(--border-color);
      border-radius: var(--radius-md);
      padding: 20px;
      margin-top: 30px;
    }
    .notifications-box h4 {
      font-size: 1rem;
      font-weight: 700;
      color: var(--text-primary);
      margin-bottom: 12px;
    }
    .notifications-box ul {
      padding-left: 20px;
      margin: 0 0 15px 0;
      color: var(--text-secondary);
      font-size: 0.9rem;
    }
    .notifications-box li {
      margin-bottom: 6px;
    }
    .di-explanation {
      font-size: 0.78rem;
      color: var(--text-muted);
      border-top: 1px solid var(--border-color);
      padding-top: 12px;
      margin: 0;
      line-height: 1.4;
    }
  `]
})
export class NotificationWidget implements OnInit {
  notifications: string[] = [];

  constructor(private notificationService: NotificationService) {}

  ngOnInit(): void {
    this.notifications = this.notificationService.getNotifications();
  }
}
