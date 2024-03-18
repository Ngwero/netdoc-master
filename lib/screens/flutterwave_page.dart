

import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:netdoc/models/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FlutterwavePage extends StatefulWidget {
  FlutterwavePage(this.title);

  final String title;

  @override
  _FlutterwavePageState createState() => _FlutterwavePageState();
}

class _FlutterwavePageState extends State<FlutterwavePage> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final narrationController = TextEditingController();
  final publicKeyController = TextEditingController();
  final encryptionKeyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String selectedCurrency = "";

  bool isTestMode = true;

  @override
  Widget build(BuildContext context) {
    this.currencyController.text = this.selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: this.formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(hintText: "Amount"),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Amount is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.currencyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  readOnly: true,
                  onTap: this._openBottomSheet,
                  decoration: InputDecoration(
                    hintText: "Currency",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Currency is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.publicKeyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Public Key",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.encryptionKeyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Encryption Key",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.emailController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.phoneNumberController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  children: [
                    Text("Use Debug"),
                    Switch(
                      onChanged: (value) => {
                        setState(() {
                          isTestMode = value;
                        })
                      },
                      value: this.isTestMode,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  onPressed: this._onPressed,
                  child: Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onPressed() {
    if (this.formKey.currentState!.validate()) {
      this._handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    final Customer customer = Customer(
        name: "FLW Developer",
        phoneNumber: this.phoneNumberController.text ?? "12345678",
        email: "customer@customer.com");

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: Provider.of<DoctorProvider>(context, listen: false).flutterwavePublicKey,
       // "FLWPUBK_TEST-15ec7ce670062494429cddc5c64cd177-X",

        // this.publicKeyControllerUGC.text.trim().isEmpty
        //     ? this.getPublicKey()
        //     : this.publicKeyController.text.trim(),
        currency: this.selectedCurrency,
        redirectUrl: 'https://google.com',
        txRef: Uuid().v1(),
        amount: this.amountController.text.toString().trim(),
        customer: customer,
        paymentOptions: "card, payattitude, barter, bank transfer, ussd",
        customization: Customization(title: "Test Payment"),
        isTestMode: this.isTestMode);
    final ChargeResponse response = await flutterwave.charge();
    if (response != null) {
      this.showLoading(response.toString());
      print("${response.toJson()}");
    } else {
      this.showLoading("No Response!");
    }
  }

  String getPublicKey() {

    if (isTestMode) return Provider.of<DoctorProvider>(context, listen: false).flutterwaveTestKey;
    //"FLWPUBK_TEST-6f008dca68dc8988715b929f2861da41-X";
    return "FLWSECK_TEST-59ed89c716f1ca8e4309df9ac043e6bc-X";
   // return "FLWPUBK-45587fdb1c84335354ab0fa388b803d5-X";
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getCurrency();
        });
  }

  Widget _getCurrency() {
    final currencies = ["NGN", "RWF", "UGX", "KES", "ZAR", "USD", "GHS", "TZS"];
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: currencies
            .map((currency) => ListTile(
          onTap: () => {this._handleCurrencyTap(currency)},
          title: Column(
            children: [
              Text(
                currency,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 4),
              Divider(height: 1)
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  _handleCurrencyTap(String currency) {
    this.setState(() {
      this.selectedCurrency = currency;
      this.currencyController.text = currency;
    });
    Navigator.pop(this.context);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:ade_flutterwave_working_version/core/ade_flutterwave.dart';
//
// class FlutterwavePaymentPage extends StatefulWidget {
//   static String id = 'Flutterwave Page';
//
//   @override
//   State<FlutterwavePaymentPage> createState() => _FlutterwavePaymentPageState();
// }
//
// class _FlutterwavePaymentPageState extends State<FlutterwavePaymentPage> {
//   //controllers
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _fullNameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Ade Flutterwave payment'),
//           backgroundColor: Colors.orange,
//           foregroundColor: Colors.white,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Form(
//             child: Column(
//               children: [
//                 //title
//                 const Text(
//                   'Flutterwave payment',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _fullNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Name',
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone',
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _amountController,
//                   decoration: const InputDecoration(
//                     labelText: 'Amount',
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     var data = {
//                       'amount': _amountController.text,
//                       'email': _emailController.text,
//                       'phone': _phoneController.text,
//                       'name': _fullNameController.text,
//                       'payment_options': 'card, banktransfer, ussd',
//                       'title': 'Flutterwave payment',
//                       'currency': "NGN",
//                       'tx_ref':
//                       "AdeFlutterwave-${DateTime.now().millisecondsSinceEpoch}",
//                       'icon':
//                       "https://www.aqskill.com/wp-content/uploads/2020/05/logo-pde.png",
//                       'public_key':
//                       "FLWPUBK_TEST-e0787ab2e5b0b6fcb3d32ce465ad44d0-X",
//                       'sk_key':
//                       'FLWSECK_TEST-af1af523da3f141f894a26be4b071230-X'
//                     };
//
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AdeFlutterWavePay(data),
//                       ),
//                     ).then((response) {
//                       //response is the response from the payment
//                       print(response);
//                     });
//                   },
//                   child: const Text('Pay'),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }