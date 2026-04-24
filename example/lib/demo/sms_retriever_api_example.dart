import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsRetrieverApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsWithRetrieverApi();
    if (res.hasData) {
      return res.data!.code;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}

class SmsRetrieverApiExample extends StatefulWidget {
  const SmsRetrieverApiExample({super.key});

  @override
  State<SmsRetrieverApiExample> createState() => _SmsRetrieverApiExampleState();

  @override
  String toStringShort() => 'SMS Retriever';
}

class _SmsRetrieverApiExampleState extends State<SmsRetrieverApiExample> {
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
            'Autofills from SMS Retriever API through a custom SmsRetriever.',
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
