public class Computer {

    private String CPU;
    private String RAM;
    private String Storage;
    private String GraphicsCard;
    private String OperatingSystem;

    private Computer(Builder builder) {
        this.CPU = builder.CPU;
        this.RAM = builder.RAM;
        this.Storage = builder.Storage;
        this.GraphicsCard = builder.GraphicsCard;
        this.OperatingSystem = builder.OperatingSystem;
    }

    public void display() {

        System.out.println("CPU: " + CPU);
        System.out.println("RAM: " + RAM);
        System.out.println("Storage: " + Storage);
        System.out.println("Graphics Card: " + GraphicsCard);
        System.out.println("Operating System: " + OperatingSystem);
    }

    public static class Builder {

        private String CPU;
        private String RAM;
        private String Storage;
        private String GraphicsCard;
        private String OperatingSystem;

        public Builder setCPU(String CPU) {
            this.CPU = CPU;
            return this;
        }

        public Builder setRAM(String RAM) {
            this.RAM = RAM;
            return this;
        }

        public Builder setStorage(String Storage) {
            this.Storage = Storage;
            return this;
        }

        public Builder setGraphicsCard(String GraphicsCard) {
            this.GraphicsCard = GraphicsCard;
            return this;
        }

        public Builder setOperatingSystem(String OperatingSystem) {
            this.OperatingSystem = OperatingSystem;
            return this;
        }

        public Computer build() {
            return new Computer(this);
        }
    }
}