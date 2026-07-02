import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CourseService } from '../../services/course.service';
import { EnrollmentService } from '../../services/enrollment.service';
import { CourseSummary } from '../../components/course-summary/course-summary';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, FormsModule, CourseSummary],
  templateUrl: './home.html',
  styleUrl: './home.css'
})
export class Home implements OnInit, OnDestroy {
  portalName = 'Student Course Portal';
  isPortalActive = true;
  message = '';
  searchTerm = '';

  constructor(
    public courseService: CourseService,
    public enrollmentService: EnrollmentService,
    private cdr: ChangeDetectorRef
  ) {}

  /*
   * DIFFERENCE BETWEEN BINDINGS:
   * - [property] (Property Binding):
   *   One-way data binding from the component class to the DOM.
   *   For example, [disabled]="!isPortalActive" binds the disabled property of the button to the component's state.
   *   If isPortalActive changes in the code, the DOM will update, but updates in the DOM do not flow back to the component.
   *
   * - [(ngModel)] (Two-Way Binding):
   *   Two-way data binding between the component and the DOM (usually input elements).
   *   It is a combination of property binding and event binding: [ngModel]="searchTerm" (ngModelChange)="searchTerm = $event".
   *   Any change in the input field updates the component property, and any programmatic change to the property updates the input field.
   */

  coursesCount = 0;

  ngOnInit(): void {
    console.log('HomeComponent initialised — courses loaded');
    this.courseService.getCourses().subscribe({
      next: (courses) => {
        this.coursesCount = courses.length;
        this.cdr.markForCheck();
      },
      error: (err) => console.error('Failed to load courses count in home', err)
    });
  }

  ngOnDestroy(): void {
    console.log('HomeComponent destroyed');
  }

  onEnrollClick(): void {
    this.message = 'Enrollment opened!';
    this.cdr.markForCheck();
  }
}