import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../Api/Config.dart';


class merpago extends StatefulWidget {
  final String? totalAmount;

  const merpago({this.totalAmount});

  @override
  State<merpago> createState() => _merpagoState();
}

class _merpagoState extends State<merpago> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? accessToken;
  bool isLoading = true;

  String? payerID;
  var progress;

  @override
  void initState() {
    super.initState();
    setState(() {});
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (e) {
            setState(() {
              isLoading = false;
            });
          },
          onProgress: (val) {
            progress = val;
            setState(() {});
          },
          onNavigationRequest: (navigation) async {
            final uri = Uri.parse(navigation.url);
            if (uri.queryParameters["status"] == null) {
              accessToken = uri.queryParameters["token"];
            } else {
              if (uri.queryParameters["status"] == "successful") {
                payerID = await uri.queryParameters["transaction_id"];
                Get.back(result: payerID);
              }else{

                Get.back();

                Fluttertoast.showToast(msg: "${uri.queryParameters["status"]}",timeInSecForIosWeb: 4);
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "${Config.base_url + "/merpago/index.php?amt=${widget.totalAmount}"}"));
  }

  late final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(
                  controller: controller,
                ),
                // WebView(
                //   initialUrl:
                //       "${Config.baseUrl}/paypal/index.php?amt=${widget.totalAmount}",
                //   javascriptMode: JavascriptMode.unrestricted,
                //   gestureNavigationEnabled: true,
                //   navigationDelegate: (NavigationRequest request) async {
                //     final uri = Uri.parse(request.url);
                //     if (uri.queryParameters["status"] == null) {
                //       accessToken = uri.queryParameters["token"];
                //     } else {
                //       if (uri.queryParameters["status"] == "payment_success") {
                //         payerID = await uri.queryParameters["tid"];

                //         Get.back(result: payerID);
                //       } else {
                //         Get.back();
                //         // ApiWrapper.showToastMessage(
                //         //     "${uri.queryParameters["status"]}");
                //       }
                //     }

                //     return NavigationDecision.navigate;
                //   },
                //   onPageFinished: (finish) {
                //     setState(() {
                //       isLoading = false;
                //     });
                //   },
                //   onProgress: (val) {
                //     progress = val;
                //     setState(() {});
                //   },
                // ),

                isLoading
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      SizedBox(
                        width: Get.width * 0.80,
                        child: const Text(
                          'Please don`t press back until the transaction is complete',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
                    : Stack(),
              ],
            )),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back()),
            backgroundColor: Colors.black12,
            elevation: 0.0),
        body: Center(
            child: Container(
              child: CircularProgressIndicator(),
            )),
      );
    }
  }
}