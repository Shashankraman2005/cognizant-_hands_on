package com.library;

import com.library.model.Book;
import com.library.repository.BookRepository;
import com.library.service.BookService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class LibraryManagementTests {

    @Autowired
    private BookService bookService;

    @Autowired
    private BookRepository bookRepository;

    @Test
    @DisplayName("Exercise 1 & 2 & 5: Basic Spring Application & XML Context Dependency Injection")
    void testXmlConfigurationAndDI() {
        try (ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml")) {
            BookService xmlBookService = context.getBean("bookService", BookService.class);
            assertNotNull(xmlBookService, "BookService bean should be initialized from applicationContext.xml");
            assertNotNull(xmlBookService.getBookRepository(), "BookRepository should be injected into BookService");
            
            List<Book> books = xmlBookService.getAllBooks();
            assertFalse(books.isEmpty(), "Book list should not be empty");
        }
    }

    @Test
    @DisplayName("Exercise 6 & 7: Annotation-based Configuration, Service/Repository annotations, Constructor & Setter Injection")
    void testAnnotationConfigurationAndDI() {
        assertNotNull(bookService, "BookService should be autowired by Spring Boot context");
        assertNotNull(bookRepository, "BookRepository should be autowired by Spring Boot context");
        assertNotNull(bookService.getBookRepository(), "BookRepository should be injected into BookService");
    }

    @Test
    @DisplayName("Exercise 3 & 8: Spring AOP Execution Time & Logging Aspect Test")
    void testSpringAopLogging() {
        List<Book> books = bookService.getAllBooks();
        assertNotNull(books, "getAllBooks should return list intercepted by LoggingAspect");
        
        Book newBook = new Book("Spring Boot in Action", "Craig Walls", "9781617292545", 44.99);
        Book savedBook = bookService.addBook(newBook);
        assertNotNull(savedBook.getId(), "Added book should have generated ID");
    }

    @Test
    @DisplayName("Exercise 9: Spring Boot Service & CRUD Operations")
    void testCrudOperations() {
        int initialCount = bookService.getAllBooks().size();
        
        Book book = new Book("Microservices Patterns", "Chris Richardson", "9781617293740", 49.99);
        Book created = bookService.addBook(book);
        
        assertEquals(initialCount + 1, bookService.getAllBooks().size());
        assertTrue(bookService.getBookById(created.getId()).isPresent());
        
        boolean deleted = bookService.deleteBook(created.getId());
        assertTrue(deleted, "Book should be deleted successfully");
    }
}
