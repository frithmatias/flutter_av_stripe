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
  
  }) async {

    try {
      final paymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: card));
      final paymentResponse = await _realizarPago(amount: amount, currency: currency, paymentMethod: paymentMethod);
      return paymentResponse;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }

  }


  Future<StripeCustomResponse> pagarConTarjetaNueva({
  
    required String amount, 
    required String currency
  
  }) async {

    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      final paymentResponse = await _realizarPago(amount: amount, currency: currency, paymentMethod: paymentMethod);
      return paymentResponse;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }

  }


  Future<StripeCustomResponse> payAppleAndGoogle({required String amount, required String currency}) async {

      try {

        final newAmount = double.parse(amount)/100;
        final token = await StripePayment.paymentRequestWithNativePay(
          androidPayOptions: AndroidPayPaymentRequest( 
            totalPrice: amount,
            currencyCode: currency
          ), 
          applePayOptions: ApplePayPaymentOptions(  
            countryCode: 'US',
            currencyCode: currency,
            items: [  
              ApplePayItem(  
                label: 'Detalle del producto', 
                amount: '$newAmount'
              )
            ]
          )
        );

        final paymentMethod = await StripePayment.createPaymentMethod(  
          PaymentMethodRequest(  
            token: token
          )
        );

        final paymentResponse = await _realizarPago(amount: amount, currency: currency, paymentMethod: paymentMethod);
        await StripePayment.completeNativePayRequest();
        return paymentResponse;

      } catch(e) {
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

  Future _realizarPago({ required String amount, required String currency, required PaymentMethod paymentMethod }) async {

    try {
      
      // Intent
      final intentResponse = await _crearPaymentIntent(amount: amount, currency: currency);

      // Payment
      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: intentResponse.clientSecret,
          paymentMethodId: paymentMethod.id
        )
      );

      if (paymentResult.status == 'succeeded'){
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(ok: false, msg: paymentResult.status);
      }

    } catch(e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

}
