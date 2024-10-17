import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'bcs_face_verify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = '-';
  final _codeController = TextEditingController();
  final _bcsFaceVerifyPlugin = BcsFaceVerify();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demo BCS'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: "Codigo",
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => processVerifyAsync(_codeController.text ),
                child: Text('Verificar'),
              ),
              Text(_result)
            ],
          ),
        ),
      ),
    );
  }

  Future processVerifyAsync(String code) async{
    final checkPermissions = await this._checkPermissions();
    if (!checkPermissions) {
      /// Manejar permisos denegados
    }
    else {
      String result = await _verifyFace(code);
      setState(() {
        _result = result;
      });
    }
  }

  Future<String> _verifyFace(String code) async {
    //await _bcsFaceVerifyPlugin.setUrlService("https://674c-84-17-40-112.ngrok-free.app");
    return _bcsFaceVerifyPlugin.faceVerify(code);
  }

  Future<bool> _checkPermissions() async {
    var p1 = await Permission.camera.request();
    var p2 = await Permission.microphone.request();
    return p1.isGranted && p2.isGranted;
  }

}
