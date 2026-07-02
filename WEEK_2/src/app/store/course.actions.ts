import { createAction, props } from '@ngrx/store';
import { Course } from '../models/course.model';

export const loadCourses = createAction('[Course List] Load Courses');
export const loadCoursesSuccess = createAction(
  '[Course List] Load Courses Success',
  props<{ courses: Course[] }>()
);
export const loadCoursesFailure = createAction(
  '[Course List] Load Courses Failure',
  props<{ error: string }>()
);

export const addCourse = createAction(
  '[Course List] Add Course',
  props<{ course: Course }>()
);
export const addCourseSuccess = createAction(
  '[Course List] Add Course Success',
  props<{ course: Course }>()
);
export const addCourseFailure = createAction(
  '[Course List] Add Course Failure',
  props<{ error: string }>()
);
