public class Main {

    static Employee[] employees = new Employee[5];
    static int count = 0;

    public static void addEmployee(Employee emp) {
        employees[count++] = emp;
    }

    public static void searchEmployee(int id) {

        for (int i = 0; i < count; i++) {

            if (employees[i].employeeId == id) {
                employees[i].display();
                return;
            }
        }

        System.out.println("Employee not found");
    }

    public static void traverseEmployees() {

        for (int i = 0; i < count; i++) {
            employees[i].display();
        }
    }

    public static void deleteEmployee(int id) {

        for (int i = 0; i < count; i++) {

            if (employees[i].employeeId == id) {

                for (int j = i; j < count - 1; j++) {
                    employees[j] = employees[j + 1];
                }

                count--;

                System.out.println("Employee deleted");
                return;
            }
        }

        System.out.println("Employee not found");
    }

    public static void main(String[] args) {

        addEmployee(new Employee(101, "Shashank", "Developer", 50000));
        addEmployee(new Employee(102, "Rahul", "Tester", 45000));
        addEmployee(new Employee(103, "Priya", "Manager", 70000));

        System.out.println("All Employees:");
        traverseEmployees();

        System.out.println("\nSearch Employee:");
        searchEmployee(102);

        System.out.println("\nDelete Employee:");
        deleteEmployee(102);

        System.out.println("\nAfter Deletion:");
        traverseEmployees();
    }
}