package com.library;

import com.library.model.Book;
import com.library.service.BookService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

@SpringBootApplication
public class LibraryManagementApplication {

    public static void main(String[] args) {
        System.out.println("================================================================================");
        System.out.println("            LIBRARY MANAGEMENT APPLICATION - EXERCISES 1 TO 9                  ");
        System.out.println("================================================================================");

        // Step 1: Execute Standalone Spring Core XML / Annotation / AOP Verification (Exercises 1 - 8)
        runSpringCoreExercises();

        // Step 2: Start Spring Boot Application for REST Endpoints (Exercise 9)
        System.out.println("\n[Exercise 9] Starting Spring Boot Server...");
        SpringApplication.run(LibraryManagementApplication.class, args);
    }

    private static void runSpringCoreExercises() {
        System.out.println("\n--- [Exercises 1, 2, 5, 6, 7, 8] Loading Spring XML Context (applicationContext.xml) ---");
        try (ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml")) {
            
            // Retrieve BookService bean
            BookService bookService = context.getBean("bookService", BookService.class);
            System.out.println("\n--- [Exercise 2 & 7] Testing Dependency Injection ---");
            System.out.println("BookService loaded successfully. Repository injected: " + (bookService.getBookRepository() != null));

            // Execute service method to trigger AOP Logging (Exercise 3 & 8)
            System.out.println("\n--- [Exercise 3 & 8] Testing Spring AOP Logging Aspect ---");
            List<Book> books = bookService.getAllBooks();
            System.out.println("Retrieved " + books.size() + " books from BookService:");
            books.forEach(b -> System.out.println("   -> " + b));

            // Test adding a book
            System.out.println("\n--- Testing Add Book via BookService ---");
            Book newBook = new Book("Design Patterns", "Erich Gamma et al.", "9780201633610", 54.99);
            bookService.addBook(newBook);

            System.out.println("\n--- Verification of Exercises 1-8 Complete! ---");
        } catch (Exception e) {
            System.err.println("Error during Spring Core exercise verification: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Bean
    public CommandLineRunner initDatabase(BookService bookService) {
        return args -> {
            System.out.println("\n[Spring Boot Runner] Spring Boot initialized. Available REST Endpoints:");
            System.out.println("   GET    http://localhost:8080/api/books");
            System.out.println("   GET    http://localhost:8080/api/books/{id}");
            System.out.println("   POST   http://localhost:8080/api/books");
            System.out.println("   PUT    http://localhost:8080/api/books/{id}");
            System.out.println("   DELETE http://localhost:8080/api/books/{id}");
            System.out.println("   H2 Console: http://localhost:8080/h2-console");
        };
    }
}
