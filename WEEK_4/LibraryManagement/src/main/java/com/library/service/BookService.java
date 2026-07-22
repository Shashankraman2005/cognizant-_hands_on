package com.library.service;

import com.library.model.Book;
import com.library.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service("bookService")
public class BookService {

    private BookRepository bookRepository;

    // Default Constructor (Exercise 1, 2, 5, 7)
    public BookService() {
        System.out.println("[BookService] Default Constructor called.");
    }

    // Constructor Injection (Exercise 7)
    public BookService(BookRepository bookRepository) {
        System.out.println("[BookService] Constructor Injection called with BookRepository.");
        this.bookRepository = bookRepository;
    }

    // Setter Injection (Exercise 2, 5, 7)
    @Autowired
    public void setBookRepository(BookRepository bookRepository) {
        System.out.println("[BookService] Setter Injection setBookRepository called.");
        this.bookRepository = bookRepository;
    }

    public BookRepository getBookRepository() {
        return bookRepository;
    }

    public List<Book> getAllBooks() {
        System.out.println("[BookService] Fetching all books...");
        if (bookRepository == null) {
            throw new IllegalStateException("BookRepository is not injected into BookService!");
        }
        return bookRepository.findAll();
    }

    public Optional<Book> getBookById(Long id) {
        System.out.println("[BookService] Fetching book with ID: " + id);
        return bookRepository.findById(id);
    }

    public Book addBook(Book book) {
        System.out.println("[BookService] Adding book: " + book.getTitle());
        return bookRepository.save(book);
    }

    public Book updateBook(Long id, Book updatedBook) {
        System.out.println("[BookService] Updating book with ID: " + id);
        updatedBook.setId(id);
        return bookRepository.save(updatedBook);
    }

    public boolean deleteBook(Long id) {
        System.out.println("[BookService] Deleting book with ID: " + id);
        return bookRepository.deleteById(id);
    }
}
