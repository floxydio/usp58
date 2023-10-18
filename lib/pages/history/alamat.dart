import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_localizations.dart';
import '../../utils/utility.dart';

class AlamatUsp extends StatelessWidget {
  const AlamatUsp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .translate('address')!,
          style: TextStyle(
              fontSize: responsiveFont(14),
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _buildWebView(),
    );
  }

  Widget _buildWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl:
      'https://www.google.com/maps/place/Uspatih+Studio/@-0.456216,100.4012723,17z/data=!3m1!4b1!4m5!3m4!1s0x2fd5252475fe12c3:0x59b93927e7e417f2!8m2!3d-0.456216!4d100.403461',
    );
  }
}
