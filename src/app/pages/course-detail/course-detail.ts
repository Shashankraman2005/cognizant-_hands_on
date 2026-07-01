import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterModule, Router } from '@angular/router';
import { CourseService } from '../../services/course.service';
import { EnrollmentService } from '../../services/enrollment.service';
import { Course } from '../../models/course.model';
import { switchMap } from 'rxjs/operators';
import { CreditLabelPipe } from '../../pipes/credit-label.pipe';

@Component({
  selector: 'app-course-detail',
  standalone: true,
  imports: [CommonModule, RouterModule, CreditLabelPipe],
  templateUrl: './course-detail.html',
  styleUrl: './course-detail.css'
})
export class CourseDetail implements OnInit {
  course: Course | null = null;
  enrolledStudents: any[] = [];
  errorMessage = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private courseService: CourseService,
    private enrollmentService: EnrollmentService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    // Read parameter id via ActivatedRoute and switchMap to load details and students
    /*
     * Why switchMap is preferred here:
     * When the course id changes rapidly, switchMap automatically cancels the previous HTTP call for enrolled students 
     * and switches to the new course id's HTTP request. This prevents race conditions where an older, slow request 
     * completes after a newer request, overwriting the page's data.
     */
    this.route.paramMap.pipe(
      switchMap(params => {
        const id = Number(params.get('id'));
        return this.courseService.getCourseById(id).pipe(
          switchMap(course => {
            this.course = course;
            return this.enrollmentService.getStudentsByCourse(id);
          })
        );
      })
    ).subscribe({
      next: (students) => {
        this.enrolledStudents = students;
        this.cdr.markForCheck();
      },
      error: (err) => {
        this.errorMessage = 'Failed to load course details.';
        console.error(err);
        this.cdr.markForCheck();
      }
    });
  }

  goBack(): void {
    this.router.navigate(['/courses']);
  }
}
