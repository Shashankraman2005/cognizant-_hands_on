import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CourseService } from '../../services/course.service';
import { EnrollmentService } from '../../services/enrollment.service';
import { Course } from '../../models/course.model';

@Component({
  selector: 'app-course-summary',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './course-summary.html',
  styleUrl: './course-summary.css'
})
export class CourseSummary implements OnInit {
  allCourses: Course[] = [];

  constructor(
    public courseService: CourseService,
    public enrollmentService: EnrollmentService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.courseService.getCourses().subscribe(courses => {
      this.allCourses = courses;
      this.cdr.markForCheck();
    });
  }

  getEnrolledCoursesList(): Course[] {
    const enrolledIds = this.enrollmentService.getEnrolledCourses();
    return this.allCourses.filter(c => enrolledIds.includes(c.id));
  }

  getTotalCredits(): number {
    return this.getEnrolledCoursesList().reduce((sum, c) => sum + (c.credits || 0), 0);
  }

  getPassedCount(): number {
    return this.getEnrolledCoursesList().filter(c => c.gradeStatus === 'passed').length;
  }

  getFailedCount(): number {
    return this.getEnrolledCoursesList().filter(c => c.gradeStatus === 'failed').length;
  }

  getPendingCount(): number {
    return this.getEnrolledCoursesList().filter(c => c.gradeStatus === 'pending').length;
  }
}
