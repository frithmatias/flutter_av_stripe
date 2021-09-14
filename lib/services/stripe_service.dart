import 'package:dio/dio.dart';
import 'package:stripe_app/global/environments.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_app/models/stripe_intent_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  final String _secretKey = Environment().secretKey;
  final String _apiKey = Environment().apiKey;

  final headerOptions = Options(  
    contentType: Headers.formUrlEncodedContentType, 
    headers: { 'Authorization': 'Bearer ${Environment().secretKey}'}
  );

  void init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: _apiKey, 
        androidPayMode: 'test', 
        merchantId: 'test'
    ));
  }

  Future pagarConTarjetaExistente({
    required String amount,
    required String currency,
    required CreditCard card
  }) async {}


  Future<StripeCustomResponse> pagarConTarjetaNueva({required String amount, required String currency}) async {

    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      final resp = await _crearPaymentIntent(amount: amount, currency: currency);
      return StripeCustomResponse(ok: true);
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }

  }

  Future<StripeIntentResponse> _crearPaymentIntent({required String amount, required String currency}) async {

        try{
          final dio = Dio();
          final data = {  
            'amount': amount, 
            'currency': currency
          };
          final resp = await dio.post(_paymentApiUrl, data: data, options: headerOptions);
          return StripeIntentResponse.fromJson(resp.data);
        } catch(e) {
            return StripeIntentResponse(status: '400');
        }
      }

  Future pagarConGooglePay({required String amount, required String currency}) async {}

  Future pagarConApplePay() async {}

  Future _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod
  }) async {}

}
