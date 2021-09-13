import 'package:stripe_app/global/environments.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  final String _secretKey = Environment().secretKey;
  final String _apiKey = Environment().apiKey;

  void init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: _apiKey, androidPayMode: 'test', merchantId: 'test'));
  }

  Future pagarConTarjetaExistente(
      {required String amount,
      required String currency,
      required CreditCard card}) async {}

  Future<StripeCustomResponse> pagarConTarjetaNueva(
      {required String amount, required String currency}) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      return StripeCustomResponse(ok: true);
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future pagarConGooglePay(
      {required String amount, required String currency}) async {}

  Future pagarConApplePay() async {}

  Future _crearPaymentIntent(
      {required String amount, required String currency}) async {}

  Future _realizarPago(
      {required String amount,
      required String currency,
      required PaymentMethod paymentMethod}) async {}
}
