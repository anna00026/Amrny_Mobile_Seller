import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/payments_service/payment_service.dart';
import 'package:qixer_seller/view/payments/mercado_pago_payment_page.dart';

class MercadoPagoService {
  payByMercado(BuildContext context,
      {bool isFromWalletDeposite = false, bool reniewSubscription = false}) {
    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => MercadopagoPaymentPage(
          isFromWalletDeposite: isFromWalletDeposite,
          reniewSubscription: reniewSubscription,
        ),
      ),
    );
  }
}
