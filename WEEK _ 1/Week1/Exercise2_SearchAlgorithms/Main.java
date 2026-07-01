public class Main {

    public static void main(String[] args) {

        Product[] products = {
                new Product(101, "Laptop", "Electronics"),
                new Product(102, "Phone", "Electronics"),
                new Product(103, "Keyboard", "Accessories"),
                new Product(104, "Mouse", "Accessories"),
                new Product(105, "Monitor", "Electronics")
        };

        System.out.println("Linear Search:");

        Product result1 = Search.linearSearch(products, 103);

        if (result1 != null) {
            result1.displayProduct();
        } else {
            System.out.println("Product not found.");
        }

        System.out.println("\nBinary Search:");

        Product result2 = Search.binarySearch(products, 104);

        if (result2 != null) {
            result2.displayProduct();
        } else {
            System.out.println("Product not found.");
        }
    }
}