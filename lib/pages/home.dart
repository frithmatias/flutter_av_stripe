import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/data/tarjetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/tarjeta.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_app/widgets/pay_footer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final stripeService = StripeService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pagar'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final pagarBloc = context.read<PagarBloc>().state;
                final resp = await stripeService.pagarConTarjetaNueva(
                    amount: pagarBloc.montoPagarString,
                    currency: pagarBloc.moneda);

                if (resp.ok) {
                  mostrarAlerta(context, 'Tarjata OK', 'Todo salió OK');
                } else {
                  mostrarAlerta(context, 'Falló', resp.msg!);
                }
              },
            )
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              width: size.width,
              height: size.height,
              top: 100,
              child: PageView.builder(
                  controller: PageController(viewportFraction: .8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tarjetas.length,
                  itemBuilder: (_, i) {
                    final tarjeta = tarjetas[i];
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<PagarBloc>()
                            .add(OnSeleccionarTarjeta(tarjeta));

                        Navigator.push(context,
                            navegarTarjetaFadeIn(context, const TarjetaPage()));
                      },
                      child: Hero(
                        tag: tarjeta.cardNumber,
                        child: CreditCardWidget(
                            height: 175,
                            cardNumber: tarjeta.cardNumber,
                            expiryDate: tarjeta.expiracyDate,
                            cardHolderName: tarjeta.cardHolderName,
                            cvvCode: tarjeta.cvv,
                            showBackView: false),
                      ),
                    );
                  }),
            ),
            const Positioned(bottom: 0, child: PayFooter())
          ],
        ));
  }
}
