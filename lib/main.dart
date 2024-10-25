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
    _initializePluginColors();
  }

  Future<void> _initializePluginColors() async {
    // Obtener los colores del tema actual y se los paso al plugin.
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;
    await _bcsFaceVerifyPlugin.setColors(primary, onPrimary);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
          ),
        ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
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
      var result = await _verifyFace(code);
      setState(() {
        _result = result.toString();
      });
    }
  }

  Future<VerifyResult> _verifyFace(String code) async {
    //Podemos establecer la URL al ambiente de desarrollo
    await _bcsFaceVerifyPlugin.setUrlService("https://bas.develop.ex-cle.com");
    return _bcsFaceVerifyPlugin.faceVerify(code);
  }

  Future<bool> _checkPermissions() async {
    var p1 = await Permission.camera.request();
    var p2 = await Permission.microphone.request();
    return p1.isGranted && p2.isGranted;
  }

}
