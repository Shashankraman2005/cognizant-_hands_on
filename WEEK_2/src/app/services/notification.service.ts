import { Injectable } from '@angular/core';

@Injectable()
export class NotificationService {
  private notifications: string[] = [
    'Welcome to the profile dashboard!',
    'Verify your enrolled courses catalog.'
  ];

  getNotifications(): string[] {
    return this.notifications;
  }

  addNotification(message: string): void {
    this.notifications.push(message);
  }
}
