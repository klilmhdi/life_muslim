import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';

Widget openWebPage(BuildContext context, String url) => navTo(
    context,
    Scaffold(
      appBar: AppBar(
        title: const Text('About the developer'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        onWebViewCreated: (InAppWebViewController controller) {
          // You can use the controller to interact with the WebView
        },
        onLoadStart: (InAppWebViewController controller, Uri? url) {
          // Called when the WebView starts loading a URL
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          // Called when the WebView finishes loading a URL
        },
        onProgressChanged: (InAppWebViewController controller, int progress) {
          // Called when the loading progress changes
        },
      ),
    ));
