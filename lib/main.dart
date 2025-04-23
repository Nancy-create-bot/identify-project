import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Authentication Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthExample(),
    );
  }
}

class AuthExample extends StatefulWidget {
  @override
  _AuthExampleState createState() => _AuthExampleState();
}

class _AuthExampleState extends State<AuthExample> {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final bool canCheckBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canCheckBiometrics || await auth.isDeviceSupported();

    if (canAuthenticate) {
      availableBiometrics = await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        print('可用的生物识别类型: $availableBiometrics');
      }
    }
  }

  Future<void> _authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: '请认证以登录',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate) {
        // success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('认证成功')),
        );
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        // 没有记录
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('认证失败')),
        );
      } else {
        // other error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('认证失败: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生物认证'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: Text('认证'),
        ),
      ),
    );
  }
}