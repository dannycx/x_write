import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// webView
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('uri'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('webView title'),),
      body: WebViewWidget(controller: controller,),
    );
  }
}
