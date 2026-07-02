import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError, of, forkJoin } from 'rxjs';
import { catchError, map, tap, retry, mergeMap } from 'rxjs/operators';
import { Course } from '../models/course.model';

@Injectable({
  providedIn: 'root'
})
export class CourseService {
  private apiUrl = 'http://localhost:3000/courses';

  private defaultList: Course[] = [
    { id: 101, name: 'Introduction to Angular', code: 'CS-101', credits: 3, gradeStatus: 'passed' },
    { id: 102, name: 'Web UI & UX Design', code: 'CS-102', credits: 4, gradeStatus: 'failed' },
    { id: 103, name: 'Database Management Systems', code: 'CS-103', credits: null, gradeStatus: 'passed' },
    { id: 104, name: 'Advanced JavaScript & ES6+', code: 'CS-104', credits: 1, gradeStatus: 'pending' },
    { id: 105, name: 'Software Engineering Principles', code: 'CS-105', credits: 3, gradeStatus: 'pending' }
  ];

  constructor(private http: HttpClient) {}

  // GET all courses
  getCourses(): Observable<Course[]> {
    return this.http.get<Course[]>(this.apiUrl).pipe(
      tap(courses => console.log(`Side effect (tap): Loaded ${courses.length} courses`)),
      map(courses => {
        // Chains a map operator to filter courses (filter out dummy courses with 0 credits if any)
        return courses.filter(c => c.credits === null || c.credits > 0);
      }),
      retry(2), // Retries 2 times before failing
      catchError(this.handleError)
    );
  }

  // GET course by ID
  getCourseById(id: number): Observable<Course> {
    return this.http.get<Course>(`${this.apiUrl}/${id}`).pipe(
      tap(course => console.log(`Side effect (tap): Loaded course details for ID ${id}`)),
      retry(2),
      catchError(this.handleError)
    );
  }

  // POST create course
  createCourse(course: Course): Observable<Course> {
    return this.http.post<Course>(this.apiUrl, course).pipe(
      tap(newCourse => console.log('Created course:', newCourse)),
      catchError(this.handleError)
    );
  }

  // PUT update course
  updateCourse(course: Course): Observable<Course> {
    return this.http.put<Course>(`${this.apiUrl}/${course.id}`, course).pipe(
      tap(updated => console.log('Updated course:', updated)),
      catchError(this.handleError)
    );
  }

  // DELETE course
  deleteCourse(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`).pipe(
      tap(() => console.log(`Deleted course ID ${id}`)),
      catchError(this.handleError)
    );
  }

  // Seeding reset: Deletes all, then posts defaultList
  resetCourses(): Observable<Course[]> {
    return this.http.get<Course[]>(this.apiUrl).pipe(
      mergeMap(courses => {
        const deleteCalls = courses.map(c => this.http.delete(`${this.apiUrl}/${c.id}`));
        return (deleteCalls.length > 0 ? forkJoin(deleteCalls) : of([])).pipe(
          mergeMap(() => {
            const postCalls = this.defaultList.map(c => this.http.post<Course>(this.apiUrl, c));
            return forkJoin(postCalls);
          })
        );
      }),
      catchError(this.handleError)
    );
  }

  // Error handler
  private handleError(error: HttpErrorResponse): Observable<never> {
    let errorMsg = 'An unknown error occurred!';
    if (error.error instanceof ErrorEvent) {
      // Client-side error
      errorMsg = `Error: ${error.error.message}`;
    } else {
      // Server-side error
      errorMsg = `Error Code: ${error.status}\nMessage: ${error.message}`;
    }
    console.error(errorMsg);
    return throwError(() => new Error(errorMsg));
  }
}
