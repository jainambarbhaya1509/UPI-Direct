import 'package:flutter/material.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class UssdResponse {
  final String returnMessage;

  UssdResponse(this.returnMessage);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'USSD Transaction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UssdTransactionScreen(),
    );
  }
}

class UssdTransactionScreen extends StatefulWidget {
  @override
  _UssdTransactionScreenState createState() => _UssdTransactionScreenState();
}

class _UssdTransactionScreenState extends State<UssdTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  String _transactionStatus = '';

  Future<void> _makeTransaction() async {
    String amount = _amountController.text;
    String pin = _pinController.text;

    // Example USSD code for a transaction
    String ussdCode = "*99*1*KKBK";


    try {
      await UssdAdvanced.sendUssd(code: ussdCode);
      setState(() {
        _transactionStatus = 'Transaction successful';
      });
    } catch (e) {
      setState(() {
        _transactionStatus = 'Transaction failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('USSD Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: 'PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makeTransaction,
              child: Text('Make Transaction'),
            ),
            SizedBox(height: 20),
            Text(_transactionStatus),
          ],
        ),
      ),
    );
  }
}
