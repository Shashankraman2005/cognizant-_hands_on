public class Main {

    public static void main(String[] args) {

        Order[] orders = {
                new Order(1, "Shashank", 4500),
                new Order(2, "Rahul", 1200),
                new Order(3, "Priya", 7800),
                new Order(4, "Aman", 3000)
        };

        System.out.println("Before Sorting:");

        for (Order o : orders) {
            o.displayOrder();
        }

        SortOrders.quickSort(orders, 0, orders.length - 1);

        System.out.println("\nAfter Quick Sort:");

        for (Order o : orders) {
            o.displayOrder();
        }
    }
}