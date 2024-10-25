import 'package:flutter/services.dart';

class BcsFaceVerify {
  final methodChannel = const MethodChannel('net.erroba.bcs');

  Future<VerifyResult> faceVerify(String code) async {
    var ret = await methodChannel.invokeMethod<String>('faceVerify', <String, dynamic>{'code': code});
    return VerifyResult.values.byName(ret!);
  }

  Future<void> setUrlService(String url) async {
    await methodChannel.invokeMethod<String>('setUrlService', <String, dynamic>{'url': url});
  }

  Future<void> setColors(Color primary, Color onPrimary) async {
    await methodChannel.invokeMethod<String>('setColors', <String, dynamic>{'primary': colorToHex(primary), 'onPrimary':  colorToHex(onPrimary)});
  }

  String colorToHex(Color color) {
    String hexColor = color.value.toRadixString(16).padLeft(8, '0');
    return '#${hexColor.substring(2)}'; // Omite los dos primeros caracteres que corresponden al alfa
  }
}

enum VerifyResult { DONE, CANCELED, PERMISSIONS_ERROR, CONNECTION_ERROR, TRANSACTION_NOT_FOUND }