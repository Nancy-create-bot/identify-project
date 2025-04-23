import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthExample extends StatefulWidget {
  @override
  _AuthExampleState createState() => _AuthExampleState();
}

class _AuthExampleState extends State<AuthExample> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canAuthenticateWithBiometrics = false;
  bool _canAuthenticate = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    setState(() {
      _canAuthenticateWithBiometrics = canAuthenticateWithBiometrics;
      _canAuthenticate = canAuthenticate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Authentication Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Can authenticate with biometrics: $_canAuthenticateWithBiometrics',
            ),
            Text('Device supports authentication: $_canAuthenticate'),
            ElevatedButton(
              onPressed: _canAuthenticate ? _authenticate : null,
              child: Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      final bool authenticated = await auth.authenticate(
        localizedReason: '请验证您的身份',
        options: AuthenticationOptions(
          biometricOnly: true, // 仅使用生物识别
        ),
      );
      if (authenticated) {
        // 认证成功
      }
    } catch (e) {
      // 处理错误
    }
  }
}
