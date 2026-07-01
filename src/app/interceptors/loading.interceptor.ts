import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { LoadingService } from '../services/loading.service';
import { finalize } from 'rxjs';

export const loadingInterceptor: HttpInterceptorFn = (req, next) => {
  const loadingService = inject(LoadingService);
  // Show spinner during active request
  loadingService.show();
  return next(req).pipe(
    finalize(() => {
      // Hide spinner once request finishes or fails
      loadingService.hide();
    })
  );
};
