import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';

class PayFooter extends StatelessWidget {
  const PayFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              children: const [
                Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('250.55 USD', style: TextStyle(fontSize: 20))
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
        print(state.tarjetaActiva);
        return state.tarjetaActiva
            ? buildCardPay(context)
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

  Widget buildCardPay(BuildContext context) {
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
      onPressed: () {},
    );
  }
}
