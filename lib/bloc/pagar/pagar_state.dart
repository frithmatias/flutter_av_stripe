part of 'pagar_bloc.dart';

@immutable
class PagarState {

  final double montoPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito? tarjeta;

  String get montoPagarString => ((montoPagar * 100).floor() / 100).toString();
  String get montoSendString => ((montoPagar * 100).floor()).toString();

  
  const PagarState({  
    this.montoPagar = 258.54, 
    this.moneda = 'USD', 
    this.tarjetaActiva = false, 
    this.tarjeta 
  });

  PagarState copyWith({  
    double? montoPagar,
    String? moneda,
    bool? tarjetaActiva,
    TarjetaCredito? tarjeta,
  }) => PagarState (   
    montoPagar: montoPagar ?? this.montoPagar, 
    moneda: moneda ?? this.moneda, 
    tarjetaActiva: tarjetaActiva ?? this.tarjetaActiva, 
    tarjeta: tarjeta ?? this.tarjeta
  );
  
}

