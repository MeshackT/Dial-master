import 'dart:io';

import 'package:dial/ReusableCode.dart';
import 'package:dial/payments/payment_configurations.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({Key? key}) : super(key: key);

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  String os = Platform.operatingSystem;

  var applePayButton = ApplePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
    paymentItems: const [
      PaymentItem(
        label: 'Item A',
        amount: '0.01',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Item B',
        amount: '0.01',
        status: PaymentItemStatus.final_price,
      ),
      PaymentItem(
        label: 'Total',
        amount: '0.02',
        status: PaymentItemStatus.final_price,
      )
    ],
    style: ApplePayButtonStyle.black,
    width: double.infinity,
    height: 50,
    type: ApplePayButtonType.buy,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) => debugPrint('Payment Result $result'),
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  var googlePayButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    paymentItems: const [
      PaymentItem(
        label: 'Total',
        amount: '0.01',
        status: PaymentItemStatus.final_price,
      )
    ],
    type: GooglePayButtonType.pay,
    margin: const EdgeInsets.only(top: 15.0),
    onPaymentResult: (result) => debugPrint('Payment Result $result'),
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.cancel,
        //     color: Theme.of(context).primaryColorLight,
        //     size: 30,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context)
        //         .pushNamedAndRemoveUntil('/', (route) => false);
        //   },
        // ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFF072456),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "data",
                style: textStyleText.copyWith(
                    color: Theme.of(context).primaryColorLight),
              ),
              Reuse.spaceBetween(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 3.9,
                child: Platform.isIOS ? applePayButton : googlePayButton,
                // child: TextButton.icon(
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //         Theme.of(context).primaryColor.withOpacity(.2)),
                //   ),
                //   icon: Icon(
                //     Icons.payments_outlined,
                //     color: Theme.of(context).primaryColorLight,
                //   ),
                //   label: Text(
                //     "Get more services",
                //     style: textStyleText.copyWith(
                //       color: Theme.of(context).primaryColorLight,
                //     ),
                //   ),
                //   onPressed: () {
                //   },
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
