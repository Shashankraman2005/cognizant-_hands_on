package com.library.repository;

import com.library.model.Book;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;

@Repository("bookRepository")
public class BookRepository {

    private final List<Book> bookList = new ArrayList<>();
    private final AtomicLong idGenerator = new AtomicLong(0);

    public BookRepository() {
        // Sample initial data
        save(new Book("Spring in Action", "Craig Walls", "9781617294945", 39.99));
        save(new Book("Effective Java", "Joshua Bloch", "9780134685991", 45.00));
        save(new Book("Clean Code", "Robert C. Martin", "9780132350884", 42.50));
    }

    public List<Book> findAll() {
        return new ArrayList<>(bookList);
    }

    public Optional<Book> findById(Long id) {
        return bookList.stream()
                .filter(book -> book.getId() != null && book.getId().equals(id))
                .findFirst();
    }

    public Book save(Book book) {
        if (book.getId() == null) {
            book.setId(idGenerator.incrementAndGet());
            bookList.add(book);
        } else {
            deleteById(book.getId());
            bookList.add(book);
        }
        return book;
    }

    public boolean deleteById(Long id) {
        return bookList.removeIf(book -> book.getId() != null && book.getId().equals(id));
    }

    public void displayRepositoryInfo() {
        System.out.println("[BookRepository] Total books in repository: " + bookList.size());
    }
}
