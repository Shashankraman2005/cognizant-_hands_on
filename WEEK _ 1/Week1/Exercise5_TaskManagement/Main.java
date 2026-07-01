public class Main {

    public static void main(String[] args) {

        TaskLinkedList list = new TaskLinkedList();

        list.addTask(1, "Coding", "Pending");
        list.addTask(2, "Testing", "Completed");
        list.addTask(3, "Documentation", "Pending");

        System.out.println("All Tasks:");
        list.traverse();

        System.out.println("\nSearch:");
        list.search(2);

        System.out.println("\nDelete:");
        list.delete(2);

        System.out.println("\nAfter Delete:");
        list.traverse();
    }
}