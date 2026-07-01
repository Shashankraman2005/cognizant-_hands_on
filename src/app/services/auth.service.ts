import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  // Hardcoded to true for mock login session representation
  isLoggedIn = true;
}
