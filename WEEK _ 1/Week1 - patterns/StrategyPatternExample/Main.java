public class Main {

    public static void main(String[] args) {

        PaymentContext context =
                new PaymentContext(
                        new CreditCardPayment());

        context.executePayment(5000);

        context.setStrategy(
                new PayPalPayment());

        context.executePayment(3000);
    }
}