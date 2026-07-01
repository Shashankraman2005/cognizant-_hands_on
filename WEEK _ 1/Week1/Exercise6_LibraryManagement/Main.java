public class Main {

    public static void main(String[] args) {

        Book[] books = {

                new Book(101,
                        "Java Programming",
                        "James Gosling"),

                new Book(102,
                        "Data Structures",
                        "Mark Allen"),

                new Book(103,
                        "Algorithms",
                        "Robert Sedgewick"),

                new Book(104,
                        "Operating Systems",
                        "Galvin")
        };

        System.out.println("Linear Search:");

        Book b1 =
                LibrarySearch.linearSearch(
                        books,
                        "Algorithms");

        if (b1 != null)
            b1.display();

        System.out.println("\nBinary Search:");

        Book b2 =
                LibrarySearch.binarySearch(
                        books,
                        "Java Programming");

        if (b2 != null)
            b2.display();
    }
}