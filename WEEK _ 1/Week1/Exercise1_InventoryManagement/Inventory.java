import java.util.HashMap;

public class Inventory {

    HashMap<Integer, Product> products = new HashMap<>();

    // Add Product
    public void addProduct(Product product) {
        products.put(product.productId, product);
        System.out.println(product.productName + " added successfully.");
    }

    // Update Product
    public void updateProduct(int productId, int quantity, double price) {

        if (products.containsKey(productId)) {

            Product p = products.get(productId);

            p.quantity = quantity;
            p.price = price;

            System.out.println("Product updated successfully.");
        } else {

            System.out.println("Product not found.");
        }
    }

    // Delete Product
    public void deleteProduct(int productId) {

        if (products.containsKey(productId)) {

            products.remove(productId);

            System.out.println("Product deleted successfully.");
        } else {

            System.out.println("Product not found.");
        }
    }

    // Display Products
    public void displayProducts() {

        if (products.isEmpty()) {

            System.out.println("Inventory is empty.");
            return;
        }

        System.out.println("\nInventory Details:");

        for (Product p : products.values()) {
            p.displayProduct();
        }
    }
}