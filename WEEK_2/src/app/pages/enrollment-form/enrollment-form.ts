import { Component, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, NgForm } from '@angular/forms';

@Component({
  selector: 'app-enrollment-form',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './enrollment-form.html',
  styleUrl: './enrollment-form.css'
})
export class EnrollmentForm {
  studentName = '';
  studentEmail = '';
  courseId: number | null = null;
  preferredSemester = 'Odd';
  agreeToTerms = false;
  submitted = false;

  constructor(private cdr: ChangeDetectorRef) {}

  onSubmit(form: NgForm): void {
    console.log('Template-Driven Form Submitted!');
    console.log('Form Values:', form.value);
    console.log('Is Form Valid:', form.valid);
    
    if (form.valid) {
      this.submitted = true;
    }
    this.cdr.markForCheck();
  }

  resetForm(form: NgForm): void {
    form.resetForm({
      preferredSemester: 'Odd',
      agreeToTerms: false
    });
    this.submitted = false;
    this.cdr.markForCheck();
  }
}
