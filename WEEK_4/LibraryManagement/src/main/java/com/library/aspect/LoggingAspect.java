package com.library.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Aspect
@Component("loggingAspect")
public class LoggingAspect {

    // Pointcut for all methods in service package
    @Pointcut("execution(* com.library.service.*.*(..))")
    public void serviceMethods() {
    }

    // Exercise 8: Before Advice
    @Before("serviceMethods()")
    public void logBefore(JoinPoint joinPoint) {
        System.out.println("[AOP BEFORE] Executing method: " + joinPoint.getSignature().toShortString());
    }

    // Exercise 8: After Advice
    @After("serviceMethods()")
    public void logAfter(JoinPoint joinPoint) {
        System.out.println("[AOP AFTER] Completed method: " + joinPoint.getSignature().toShortString());
    }

    // Exercise 3 & 8: Around Advice for execution time logging
    @Around("serviceMethods()")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        
        Object result = joinPoint.proceed();
        
        long endTime = System.currentTimeMillis();
        long executionTime = endTime - startTime;
        
        System.out.println("[AOP TIMER] Method " + joinPoint.getSignature().toShortString() 
                + " executed in " + executionTime + " ms.");
        
        return result;
    }
}
