import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { CourseService } from './course.service';

@Injectable({
  providedIn: 'root'
})
export class EnrollmentService {
  // Cache enrolled courses list in memory for instantaneous view state updates
  private enrolledCoursesList: number[] = [101, 104, 105];

  constructor(
    private http: HttpClient,
    private courseService: CourseService
  ) {}

  enroll(courseId: number): void {
    if (!this.isEnrolled(courseId)) {
      this.enrolledCoursesList.push(courseId);
    }
  }

  unenroll(courseId: number): void {
    this.enrolledCoursesList = this.enrolledCoursesList.filter(id => id !== courseId);
  }

  isEnrolled(courseId: number): boolean {
    return this.enrolledCoursesList.includes(courseId);
  }

  getEnrolledCourses(): number[] {
    return this.enrolledCoursesList;
  }

  // Fetch enrolled students for a course
  getStudentsByCourse(courseId: number): Observable<any[]> {
    return this.http.get<any[]>('http://localhost:3000/students');
  }
}
