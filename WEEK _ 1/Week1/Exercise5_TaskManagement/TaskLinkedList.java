public class TaskLinkedList {

    Task head;

    public void addTask(int id, String name, String status) {

        Task newTask = new Task(id, name, status);

        if (head == null) {
            head = newTask;
            return;
        }

        Task temp = head;

        while (temp.next != null) {
            temp = temp.next;
        }

        temp.next = newTask;
    }

    public void traverse() {

        Task temp = head;

        while (temp != null) {

            System.out.println(
                    temp.taskId + " " +
                    temp.taskName + " " +
                    temp.status);

            temp = temp.next;
        }
    }

    public void search(int id) {

        Task temp = head;

        while (temp != null) {

            if (temp.taskId == id) {

                System.out.println("Task Found:");
                System.out.println(temp.taskName);
                return;
            }

            temp = temp.next;
        }

        System.out.println("Task not found");
    }

    public void delete(int id) {

        if (head == null)
            return;

        if (head.taskId == id) {
            head = head.next;
            return;
        }

        Task temp = head;

        while (temp.next != null && temp.next.taskId != id) {
            temp = temp.next;
        }

        if (temp.next != null) {
            temp.next = temp.next.next;
        }
    }
}