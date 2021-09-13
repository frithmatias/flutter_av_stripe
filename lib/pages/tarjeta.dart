import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/widgets/pay_footer.dart';

class TarjetaPage extends StatelessWidget {
  const TarjetaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tarjeta = context.read<PagarBloc>().state.tarjeta;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Pagar'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<PagarBloc>().add(OnDesactivarTarjeta());
              Navigator.pop(context);
            },
          )),
      body: Stack(
        children: [
          Container(),
          Hero(
            tag: tarjeta!.cardNumber,
            child: CreditCardWidget(
                height: 220,
                cardNumber: tarjeta.cardNumber,
                expiryDate: tarjeta.expiracyDate,
                cardHolderName: tarjeta.cardHolderName,
                cvvCode: tarjeta.cvv,
                showBackView: false),
          ),
          const Positioned(bottom: 0, child: PayFooter())
        ],
      ),
    );
  }
}
