import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeUserConsentApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsWithUserConsentApi();
    if (res.hasData) {
      return res.data!.code;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}

class UserConsentApiExample extends StatefulWidget {
  const UserConsentApiExample({super.key});

  @override
  State<UserConsentApiExample> createState() => _UserConsentApiExampleState();

  @override
  String toStringShort() => 'User Consent';
}

class _UserConsentApiExampleState extends State<UserConsentApiExample> {
  late final SmsRetrieverImpl smsRetrieverImpl;

  @override
  void initState() {
    smsRetrieverImpl = SmsRetrieverImpl(SmartAuth.instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Prompts the user through SMS User Consent API via a custom SmsRetriever.',
            textAlign: TextAlign.center,
          ),
        ),
        Pinput(
          smsRetriever: smsRetrieverImpl,
          length: 6,
        ),
      ],
    );
  }
}
