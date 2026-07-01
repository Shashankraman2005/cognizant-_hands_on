public class MobileApp implements Observer {

    private String user;

    public MobileApp(String user) {
        this.user = user;
    }

    @Override
    public void update(String stockName, double price) {

        System.out.println(
                "Mobile App [" + user + "] : " +
                stockName + " price updated to ₹" + price);
    }
}