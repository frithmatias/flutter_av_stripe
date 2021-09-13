import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/pages/home.dart';
import 'package:stripe_app/pages/pago_realizado.dart';
import 'package:stripe_app/services/stripe_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    StripeService().init();

    return MultiBlocProvider(
      providers: [ 
        BlocProvider(create: (_) => PagarBloc()) 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stripe App',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'pago': (_) => const PagoRealizadoPage(),
        },
        theme: ThemeData.light().copyWith(
            primaryColor: const Color(0xff284879),
            scaffoldBackgroundColor: const Color(0xff21232a)),
      ),
    );
  }
}
