import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CourseCard } from '../../components/course-card/course-card';
import { HighlightDirective } from '../../directives/highlight.directive';
import { EnrollmentService } from '../../services/enrollment.service';
import { Store } from '@ngrx/store';
import { ActivatedRoute, Router } from '@angular/router';
import { Observable, combineLatest, take } from 'rxjs';
import { map } from 'rxjs/operators';
import { Course } from '../../models/course.model';
import * as CourseActions from '../../store/course.actions';
import { selectAllCourses, selectCoursesLoading, selectCoursesError } from '../../store/course.selectors';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-course-list',
  standalone: true,
  imports: [CommonModule, CourseCard, HighlightDirective, FormsModule],
  templateUrl: './course-list.html',
  styleUrl: './course-list.css',
})
export class CourseList implements OnInit {
  searchTerm = '';
  courses$: Observable<Course[]>;
  loading$: Observable<boolean>;
  error$: Observable<string | null>;
  filteredCourses$: Observable<Course[]>;

  constructor(
    public enrollmentService: EnrollmentService,
    private store: Store,
    private route: ActivatedRoute,
    private router: Router,
    private cdr: ChangeDetectorRef
  ) {
    this.courses$ = this.store.select(selectAllCourses);
    this.loading$ = this.store.select(selectCoursesLoading);
    this.error$ = this.store.select(selectCoursesError);

    // Dynamically filter courses based on URL query parameter search term
    this.filteredCourses$ = combineLatest([this.courses$, this.route.queryParamMap]).pipe(
      map(([courses, queryParams]) => {
        const search = queryParams.get('search') || '';
        this.searchTerm = search;
        if (!search) return courses;
        return courses.filter(c => 
          c.name.toLowerCase().includes(search.toLowerCase()) || 
          c.code.toLowerCase().includes(search.toLowerCase())
        );
      })
    );
  }

  ngOnInit(): void {
    // Dispatch NgRx loadCourses action on initialization
    this.store.dispatch(CourseActions.loadCourses());
  }

  /*
   * Why trackBy improves performance:
   * By default, when an array changes, Angular discards and re-renders all DOM elements representing that list.
   * By using trackBy, Angular can track each element by its unique identifier (e.g. course.id).
   * This allows Angular to only re-render components that have actually changed or been added/removed,
   * leading to better performance and avoiding unnecessary DOM manipulation.
   */
  trackByCourseId(index: number, course: Course): number {
    return course.id;
  }

  viewCourseDetails(courseId: number): void {
    this.router.navigate(['/courses', courseId]);
  }

  onSearchChange(): void {
    this.router.navigate(['/courses'], {
      queryParams: { search: this.searchTerm || null },
      queryParamsHandling: 'merge'
    });
  }

  addMockCourse(): void {
    this.courses$.pipe(take(1), map(courses => {
      const nextId = courses.length > 0 ? Math.max(...courses.map(c => c.id)) + 1 : 101;
      const grades = ['passed', 'failed', 'pending'];
      const creditsOptions = [1, 2, 3, 4, null];
      const randomGrade = grades[Math.floor(Math.random() * grades.length)] as any;
      const randomCredits = creditsOptions[Math.floor(Math.random() * creditsOptions.length)];

      return {
        id: nextId,
        name: `Mock Elective Course ${nextId}`,
        code: `EL-${nextId}`,
        credits: randomCredits,
        gradeStatus: randomGrade
      };
    })).subscribe(mockCourse => {
      this.store.dispatch(CourseActions.addCourse({ course: mockCourse }));
    });
  }
}
