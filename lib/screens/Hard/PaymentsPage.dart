import 'package:flutter/material.dart';
import 'package:easy_upi_payment/easy_upi_payment.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isProcessing = false;

  // Constants for UPI payment
  static const String PAYEE_VPA = 'anis191004@okaxis';
  static const String PAYEE_NAME = 'Anisha';

  bool _validateInputs() {
    String amount = _amountController.text.trim();
    String phone = _phoneController.text.trim();

    // Validate amount
    if (amount.isEmpty) {
      _showSnackbar("⚠️ Please enter an amount");
      return false;
    }

    try {
      double amountValue = double.parse(amount);
      if (amountValue <= 0) {
        _showSnackbar("⚠️ Amount must be greater than 0");
        return false;
      }
    } catch (e) {
      _showSnackbar("⚠️ Please enter a valid amount");
      return false;
    }

    // Validate phone number
    if (phone.isEmpty) {
      _showSnackbar("⚠️ Please enter a phone number");
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _showSnackbar("⚠️ Please enter a valid 10-digit phone number");
      return false;
    }

    return true;
  }

  Future<void> _transferMoney() async {
    if (!_validateInputs()) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final response = await EasyUpiPaymentPlatform.instance.startPayment(
        EasyUpiPaymentModel(
          payeeVpa: PAYEE_VPA,
          payeeName: PAYEE_NAME,
          amount: double.parse(_amountController.text.trim()),
          description: 'Payment to ${_phoneController.text.trim()}',
        ),
      );

      if (response.toString().toLowerCase().contains('success')) {
        _showSnackbar("✅ Transaction Successful!");
        // Clear input fields after successful transaction
        _amountController.clear();
        _phoneController.clear();
      } else {
        _showSnackbar("❌ Transaction Failed: ${response.toString()}");
      }
    } on EasyUpiPaymentException catch (e) {
      _showSnackbar("❌ Transaction Failed: ${e.toString()}");
    } catch (e) {
      _showSnackbar("❌ An unexpected error occurred");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        action: message.contains("Failed") || message.contains("⚠️")
            ? SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        )
            : null,
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.info, color: Colors.purple),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DigiPal",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        leading: const Icon(Icons.account_circle, color: Colors.white),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("💡 Payment Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildInfoCard(
                  "Quick Pay",
                  "Enter amount and phone number to make instant payment through UPI"
              ),
              _buildInfoCard("What is a UPI ID?", "A unique identifier (e.g., user@okaxis) to send/receive money securely."),
              SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Amount",
                  hintText: "Enter amount to pay",
                  prefixIcon: Icon(Icons.currency_rupee, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.purple, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Enter 10-digit phone number",
                  prefixIcon: Icon(Icons.phone, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.purple, width: 2),
                  ),
                  counterText: "", // Hides the character counter
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _transferMoney,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    elevation: 2,
                  ),
                  child: _isProcessing
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    "Pay Now",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}