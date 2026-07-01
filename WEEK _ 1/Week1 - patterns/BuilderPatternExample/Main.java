public class Main {

    public static void main(String[] args) {

        Computer computer =
                new Computer.Builder()
                        .setCPU("Intel i7")
                        .setRAM("16GB")
                        .setStorage("512GB SSD")
                        .setGraphicsCard("NVIDIA RTX 4060")
                        .setOperatingSystem("Windows 11")
                        .build();

        computer.display();
    }
}