import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PayFooter extends StatelessWidget {
  const PayFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final pagarBloc = context.read<PagarBloc>();
    final width = MediaQuery.of(context).size.width;

    return Container(
        width: width,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${pagarBloc.state.montoPagarString} ${pagarBloc.state.moneda}', style: const TextStyle(fontSize: 20))
              ],
            ),
            const PayButton()
          ],
        ));
  }
}

class PayButton extends StatelessWidget {
  const PayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagarBloc, PagarState>(
      builder: (context, state) {

        return state.tarjetaActiva
            ? buildCreditCardPay(context)
            : buildAppleAndGooglePay(context);
      },
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: [
          Icon(
              Platform.isAndroid
                  ? FontAwesomeIcons.google
                  : FontAwesomeIcons.apple,
              color: Colors.white),
          const Text(' Pay',
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget buildCreditCardPay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: const [
          Icon(FontAwesomeIcons.creditCard, color: Colors.white),
          Text('  Pay', style: TextStyle(color: Colors.white, fontSize: 22)),
        ],
      ),
      onPressed: () async {
                
        mostrarLoading(context);

        final stripeService = StripeService();
        final pagarState = context.read<PagarBloc>().state;
        final expDate = pagarState.tarjeta!.expiracyDate.split('/');
        final resp = await stripeService.pagarConTarjetaExistente(
          amount: pagarState.montoSendString, 
          currency: pagarState.moneda, 
          card: CreditCard(
            number: pagarState.tarjeta!.cardNumber,
            currency: pagarState.moneda,
            expMonth: int.parse(expDate[0]),
            expYear: int.parse(expDate[1]),
          )); 
        
        Navigator.pop(context);

        if (resp.ok) {
          mostrarAlerta(context, 'Tarjata OK', 'Todo salió OK');
        } else {
          mostrarAlerta(context, 'Falló', resp.msg!);
        }
      },
    );
  }
}
