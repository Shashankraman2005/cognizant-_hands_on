import { Component, Input, Output, EventEmitter, OnChanges, SimpleChanges, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CreditLabelPipe } from '../../pipes/credit-label.pipe';
import { EnrollmentService } from '../../services/enrollment.service';
import { Course } from '../../models/course.model';

@Component({
  selector: 'app-course-card',
  standalone: true,
  imports: [CommonModule, CreditLabelPipe],
  templateUrl: './course-card.html',
  styleUrl: './course-card.css',
})
export class CourseCard implements OnChanges {
  @Input() course!: Course;
  @Input() isEnrolled = false;
  @Output() enrollRequested = new EventEmitter<number>();
  @Output() viewDetailsRequested = new EventEmitter<number>();

  isExpanded = false;

  constructor(
    public enrollmentService: EnrollmentService,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['course']) {
      console.log('Course input changed for ID ' + (this.course ? this.course.id : 'unknown') + ':', {
        previousValue: changes['course'].previousValue,
        currentValue: changes['course'].currentValue
      });
    }
  }

  /*
   * Why getters keep templates clean:
   * Instead of bloating the template with complex conditional expression logic, e.g. [ngClass]="{'card-enrolled': isEnrolled, 'card-full': course.credits >= 4}",
   * we delegate the evaluation to a TypeScript getter. This makes the HTML easier to read, keeps styling logic
   * encapsulated inside the component, and supports easier testing/debugging.
   */
  get cardClasses() {
    const enrolled = this.course ? this.enrollmentService.isEnrolled(this.course.id) : this.isEnrolled;
    return {
      'card-enrolled': enrolled,
      'card-full': this.course && this.course.credits !== null && this.course.credits >= 4,
      'expanded': this.isExpanded
    };
  }

  getBorderColor(): string {
    if (!this.course) return 'var(--text-muted)';
    switch (this.course.gradeStatus) {
      case 'passed': return 'var(--success-color)';
      case 'failed': return 'var(--error-color)';
      case 'pending': return 'var(--warning-color)';
      default: return 'var(--text-muted)';
    }
  }

  toggleDetails(): void {
    this.isExpanded = !this.isExpanded;
    this.cdr.markForCheck();
  }

  onEnrollToggle(): void {
    if (!this.course) return;
    if (this.enrollmentService.isEnrolled(this.course.id)) {
      this.enrollmentService.unenroll(this.course.id);
    } else {
      this.enrollmentService.enroll(this.course.id);
    }
    this.enrollRequested.emit(this.course.id);
    this.cdr.markForCheck();
  }

  onViewDetailsClick(): void {
    if (this.course) {
      this.viewDetailsRequested.emit(this.course.id);
    }
  }
}
