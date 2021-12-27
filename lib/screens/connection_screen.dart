import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:niresto_flutter/services/authentication_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get_it/get_it.dart';


void _navigateIntroduction(BuildContext context) {
  Navigator.popAndPushNamed(
    context,
    "/intro"
  );
}


class ConnectionScreen extends StatefulWidget {

  const ConnectionScreen({Key? key}) : super(key: key);


  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    _QRLogin(),
    Padding(
      padding: EdgeInsets.all(16.0),
      child: _ManualLogin(),
    )

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Manual',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _QRLogin extends StatefulWidget {
  const _QRLogin({Key? key}) : super(key: key);

  @override
  _QRLoginState createState() => _QRLoginState();
}

class _QRLoginState extends State<_QRLogin> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text('Scan the QR code given to you by the instructor'),
          ),
        )
      ],
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      var instance = GetIt.instance<AuthenticationService>();
      instance.login(scanData.code)
        .then((value) => _navigateIntroduction(context));
    });
  }
  
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


class _ManualLogin extends StatefulWidget {
  const _ManualLogin({Key? key}) : super(key: key);

  @override
  State<_ManualLogin> createState() => _ManualLoginState();
}

class _ManualLoginState extends State<_ManualLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final tokenController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tokenController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: tokenController,
            decoration: const InputDecoration(
              hintText: 'Enter your login token',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  var instance = GetIt.instance<AuthenticationService>();
                  instance.login(tokenController.value.text)
                    .then((value) => _navigateIntroduction(context));
                }
              },
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
