public class Order {

    int orderId;
    String customerName;
    double totalPrice;

    public Order(int orderId, String customerName, double totalPrice) {
        this.orderId = orderId;
        this.customerName = customerName;
        this.totalPrice = totalPrice;
    }

    public void displayOrder() {
        System.out.println("Order ID: " + orderId +
                ", Customer: " + customerName +
                ", Total Price: ₹" + totalPrice);
    }
}