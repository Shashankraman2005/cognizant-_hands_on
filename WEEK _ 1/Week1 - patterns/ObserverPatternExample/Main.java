public class Main {

    public static void main(String[] args) {

        StockMarket stock = new StockMarket("TCS");

        Observer mobileUser =
                new MobileApp("Shashank");

        Observer webUser =
                new WebApp("Rahul");

        stock.registerObserver(mobileUser);
        stock.registerObserver(webUser);

        stock.setPrice(4200);

        System.out.println();

        stock.setPrice(4500);
    }
}