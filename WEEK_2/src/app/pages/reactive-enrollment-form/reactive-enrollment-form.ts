import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormsModule, FormBuilder, FormGroup, FormArray, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-reactive-enrollment-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, FormsModule],
  templateUrl: './reactive-enrollment-form.html',
  styleUrl: './reactive-enrollment-form.css'
})
export class ReactiveEnrollmentForm implements OnInit {
  enrollForm!: FormGroup;
  submitted = false;
  isCheckingEmail = false;

  constructor(
    private fb: FormBuilder,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.enrollForm = this.fb.group({
      studentName: ['', [Validators.required, Validators.minLength(3)]],
      studentEmail: ['', {
        validators: [Validators.required, Validators.email],
        asyncValidators: [this.simulateEmailCheck.bind(this)],
        updateOn: 'change'
      }],
      courseId: ['', [Validators.required, this.noCourseCode]],
      preferredSemester: ['Odd', Validators.required],
      agreeToTerms: [false, Validators.requiredTrue],
      additionalCourses: this.fb.array([])
    });
  }

  /*
   * Why this FormArray getter is better than template casting:
   * 1. Type Safety: It returns a strongly-typed FormArray instead of standard AbstractControl.
   * 2. Readability: It keeps template clean: *ngFor="let ctrl of additionalCourses.controls" instead of casting syntax.
   * 3. DRY: Avoids duplicating casting expressions throughout the code.
   */
  get additionalCourses(): FormArray {
    return this.enrollForm.get('additionalCourses') as FormArray;
  }

  addCourse(): void {
    this.additionalCourses.push(this.fb.control('', Validators.required));
    this.cdr.markForCheck();
  }

  removeCourse(index: number): void {
    this.additionalCourses.removeAt(index);
    this.cdr.markForCheck();
  }

  onSubmit(): void {
    console.log('Reactive Form Submitted!');
    
    /*
     * Difference between value and getRawValue() in Reactive Forms:
     * - enrollForm.value returns only the values of the ENABLED controls in the group.
     *   If any control is disabled (e.g. courseId is disabled dynamically), its key-value pair will be omitted.
     * - enrollForm.getRawValue() returns the values of ALL controls in the group, regardless of their enabled or disabled state.
     */
    console.log('form.value:', this.enrollForm.value);
    console.log('form.getRawValue():', this.enrollForm.getRawValue());

    if (this.enrollForm.valid) {
      this.submitted = true;
    }
    this.cdr.markForCheck();
  }

  resetForm(): void {
    this.enrollForm.reset({
      studentName: '',
      studentEmail: '',
      courseId: '',
      preferredSemester: 'Odd',
      agreeToTerms: false
    });
    this.additionalCourses.clear();
    this.submitted = false;
    this.cdr.markForCheck();
  }

  // Custom Synchronous Validator
  noCourseCode(control: AbstractControl): ValidationErrors | null {
    const val = String(control.value || '').trim();
    if (val.toUpperCase().startsWith('XX')) {
      return { noCourseCode: true };
    }
    return null;
  }

  // Custom Asynchronous Validator
  simulateEmailCheck(control: AbstractControl): Promise<ValidationErrors | null> {
    return new Promise((resolve) => {
      const email = String(control.value || '');
      if (!email) {
        resolve(null);
        return;
      }

      this.isCheckingEmail = true;
      this.cdr.markForCheck();

      setTimeout(() => {
        this.isCheckingEmail = false;
        if (email.toLowerCase().includes('test@')) {
          resolve({ emailTaken: true });
        } else {
          resolve(null);
        }
        this.cdr.markForCheck();
      }, 800);
    });
  }
}
