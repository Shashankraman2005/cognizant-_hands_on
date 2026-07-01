import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { CoursesLayout } from './pages/courses-layout/courses-layout';
import { CourseList } from './pages/course-list/course-list';
import { CourseDetail } from './pages/course-detail/course-detail';
import { StudentProfile } from './pages/student-profile/student-profile';
import { NotFound } from './pages/not-found/not-found';
import { authGuard } from './guards/auth.guard';
import { unsavedChangesGuard } from './guards/unsaved-changes.guard';

export const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: Home },
  { 
    path: 'courses', 
    component: CoursesLayout,
    children: [
      { path: '', component: CourseList },
      { path: ':id', component: CourseDetail }
    ]
  },
  { 
    path: 'enroll', 
    loadComponent: () => import('./pages/enrollment-form/enrollment-form').then(m => m.EnrollmentForm), 
    canActivate: [authGuard] 
  },
  { 
    path: 'enroll-reactive', 
    loadComponent: () => import('./pages/reactive-enrollment-form/reactive-enrollment-form').then(m => m.ReactiveEnrollmentForm), 
    canActivate: [authGuard],
    canDeactivate: [unsavedChangesGuard]
  },
  { path: 'profile', component: StudentProfile, canActivate: [authGuard] },
  { path: '**', component: NotFound }
];

