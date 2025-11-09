import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MebMapPage extends StatefulWidget {
  const MebMapPage({super.key});

  @override
  State<MebMapPage> createState() => _MebMapPageState();
}

class _MebMapPageState extends State<MebMapPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse('https://esinav.meb.gov.tr/harita'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('e-Sınav Merkezleri Sonuç Öğrenme'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
