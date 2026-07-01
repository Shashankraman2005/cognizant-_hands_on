import java.util.Arrays;
import java.util.Comparator;

public class LibrarySearch {

    public static Book linearSearch(Book[] books, String title) {

        for (Book book : books) {

            if (book.title.equalsIgnoreCase(title)) {
                return book;
            }
        }

        return null;
    }

    public static Book binarySearch(Book[] books, String title) {

        Arrays.sort(books,
                Comparator.comparing(b -> b.title));

        int low = 0;
        int high = books.length - 1;

        while (low <= high) {

            int mid = (low + high) / 2;

            int result =
                    books[mid].title.compareToIgnoreCase(title);

            if (result == 0)
                return books[mid];

            if (result < 0)
                low = mid + 1;
            else
                high = mid - 1;
        }

        return null;
    }
}