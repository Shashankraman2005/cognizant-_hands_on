public class Main {

    public static void main(String[] args) {

        Inventory inventory = new Inventory();

        // Creating Products
        Product p1 = new Product(101, "Laptop", 10, 65000);
        Product p2 = new Product(102, "Mobile", 20, 25000);
        Product p3 = new Product(103, "Keyboard", 30, 1500);

        // Adding Products
        inventory.addProduct(p1);
        inventory.addProduct(p2);
        inventory.addProduct(p3);

        // Display Products
        inventory.displayProducts();

        // Update Product
        inventory.updateProduct(102, 15, 23000);

        // Delete Product
        inventory.deleteProduct(103);

        // Display Updated Inventory
        inventory.displayProducts();
    }
}