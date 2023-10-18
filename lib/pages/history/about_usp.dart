import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';

import '../../app_localizations.dart';
import '../../utils/utility.dart';
import 'alamat.dart';
import 'circular_clipper.dart';

class TentangUspatih extends StatefulWidget {
  @override
  _TentangUspatihState createState() => _TentangUspatihState();
}

class _TentangUspatihState extends State<TentangUspatih> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .translate('about_us')!,
          style: TextStyle(
            color: Colors.white,
              fontSize: responsiveFont(14),
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                child: ClipShadowPath(
                  clipper: CircularClipper(),
                  shadow: Shadow(blurRadius: 20.0),
                  child: Image.network(
                    'https://uspatih.id/images/uspstore.jpg',
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RawMaterialButton(
                    padding: EdgeInsets.all(10.0),
                    elevation: 12.0,
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AlamatUsp())),
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.map,
                      size: 60.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 20.0,
                child: IconButton(
                  onPressed: () => LaunchReview.launch(
                      androidAppId: "id.uspatihdp.uspatihapps.androidoverview"),
                  icon: Icon(Icons.star),
                  iconSize: 40.0,
                  color: Colors.redAccent,
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 25.0,
                child: IconButton(
                  onPressed: () {
                    Share.share(
                        "Yuk Download Aplikasi USPATIH Go, dapatkan promo menarik https://play.google.com/store/apps/details?id=id.uspatihdp.uspatihapps.androidoverview");
                  },
                  icon: Icon(Icons.share),
                  iconSize: 35.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'USPATIH studio',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  AppLocalizations.of(context)!
                      .translate('one_stop')!,
                  style: TextStyle(
                      fontSize: responsiveFont(12),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '⭐ ⭐ ⭐ ⭐',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!
                              .translate('year')!,
                          style: TextStyle(
                              fontSize: responsiveFont(12),
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          '2007',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!
                              .translate('month')!,
                          style: TextStyle(
                              fontSize: responsiveFont(12),
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          'Juli',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!
                              .translate('date')!,
                          style: TextStyle(
                              fontSize: responsiveFont(12),
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          '11',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 300.0,
                  child: SingleChildScrollView(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('history')!,
                      style: TextStyle(
                          fontSize: responsiveFont(12),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!
                      .translate('logo')!,
                  style: TextStyle(
                      fontSize: responsiveFont(12),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ImageScroll(
                        imgpath:
                            "https://uspatih.id/images/icon/uspicon2008.png",
                        text: "2007 - 2008",
                      ),
                      ImageScroll(
                        imgpath:
                        "https://uspatih.id/images/icon/uspicon2013.png",
                        text: "2008 - 2013",
                      ),
                      ImageScroll(
                        imgpath:
                            "https://uspatih.id/images/icon/uspicon2016.png",
                        text: "2013 - 2016",
                      ),
                      ImageScroll(
                        imgpath:
                            "https://uspatih.id/images/icon/uspicon2019.png",
                        text: "2016 - 2019",
                      ),
                      ImageScroll(
                        imgpath:
                            "https://uspatih.id/images/icon/uspicon21.png",
                        text: "2019 - 2021",
                      ),
                      ImageScroll(
                        imgpath:
                        "https://uspatih.id/images/icon/uspicon23.png",
                        text: "2021 - sekarang",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}

class ImageScroll extends StatelessWidget {
  final String imgpath;
  final text;

  const ImageScroll({
    Key? key,
    required this.imgpath,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: <Widget>[
          Container(
            width: 110,
            height: 110,
            decoration: new BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(imgpath),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 20),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
