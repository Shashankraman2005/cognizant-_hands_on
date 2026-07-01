import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EnrollmentService } from '../../services/enrollment.service';
import { CourseService } from '../../services/course.service';
import { Course } from '../../models/course.model';
import { NotificationWidget } from '../../components/notification-widget/notification-widget';

@Component({
  selector: 'app-student-profile',
  standalone: true,
  imports: [CommonModule, NotificationWidget],
  templateUrl: './student-profile.html',
  styleUrl: './student-profile.css',
})
export class StudentProfile implements OnInit {
  enrolledCourses: Course[] = [];
  errorMessage = '';

  constructor(
    public enrollmentService: EnrollmentService,
    private courseService: CourseService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.courseService.getCourses().subscribe({
      next: (allCourses) => {
        const enrolledIds = this.enrollmentService.getEnrolledCourses();
        this.enrolledCourses = allCourses.filter(c => enrolledIds.includes(c.id));
        this.cdr.markForCheck();
      },
      error: (err) => {
        this.errorMessage = 'Failed to load enrolled courses catalog.';
        console.error(err);
        this.cdr.markForCheck();
      }
    });
  }
}
