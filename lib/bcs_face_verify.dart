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
}

enum VerifyResult { DONE, CANCELED, PERMISSIONS_ERROR, CONNECTION_ERROR }