import 'package:flutter/material.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  Future<void> _transferMoney() async {
    final amount = _amountController.text.trim();
    final upiId = _upiIdController.text.trim();

    if (amount.isEmpty || upiId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all details")),
      );
      return;
    }

    try {
      final response = await EasyUpiPaymentPlatform.instance.startPayment(
        EasyUpiPaymentModel(
          payeeVpa: 'anis191004@okaxis', // Assuming the phone number can act as VPA
          payeeName: 'Anisha',
          amount: double.parse(amount),
          description: 'Payment Transfered to $upiId',
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaction Status: ${response}")),
      );
    } on EasyUpiPaymentException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaction Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction Page")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter Amount"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _upiIdController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Enter UPI ID"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _transferMoney,
              child: Text("Transfer"),
            ),
          ],
        ),
      ),
    );
  }
}
