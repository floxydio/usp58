import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:nyoba/models/redeem_history_model.dart';
import 'package:nyoba/pages/home/home_screen.dart';
import 'package:nyoba/provider/redeem_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:provider/provider.dart';

class CouponDetailPage extends StatefulWidget {
  final int redeemProductId;
  final int pointRedeem;
  final String image;
  final String description;
  final String title;

  const CouponDetailPage(
      {super.key,
      required this.redeemProductId,
      required this.image,
      required this.pointRedeem,
      required this.description,
      required this.title});
  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  final Color icon = Color(0xffEF412D);
  static final String path = "lib/src/pages/food/recipe_single.dart";

  final Color color1 = Color(0xffCF3529);

  final Color color2 = Color(0xffE1372F);

  final Color color3 = Color(0xffFF6C1C);

  @override
  Widget build(BuildContext context) {
    final redeemVm = Provider.of<RedeemProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 350,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [color2, color3],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                )),
            Positioned(
                top: 350,
                left: 0,
                right: 150,
                bottom: 80,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50.0))),
                )),
            Positioned(
              top: 350,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Text(
                      "${widget.title}".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 30.0),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "${widget.description}",
                      style: TextStyle(color: Colors.white,fontSize:18),
                    ),
                    SizedBox(height: 50.0),
                    // SizedBox(
                    //   height: 30.0,
                    //   width: double.infinity,
                    //   child: Row(
                    //     children: <Widget>[
                    //       Icon(FontAwesomeIcons.fire, color: Colors.white),
                    //       SizedBox(width: 5.0),
                    //       Text(
                    //         "65%",
                    //         style:
                    //             TextStyle(color: Colors.white, fontSize: 18.0),
                    //       ),
                    //       Spacer(),
                    //       VerticalDivider(color: Colors.white),
                    //       Spacer(),
                    //       Text(
                    //         "Vegetarian",
                    //         style:
                    //             TextStyle(color: Colors.white, fontSize: 18.0),
                    //       ),
                    //       Spacer(),
                    //       VerticalDivider(color: Colors.white),
                    //       Spacer(),
                    //       Icon(FontAwesomeIcons.stopwatch, color: Colors.white),
                    //       SizedBox(width: 5.0),
                    //       Text(
                    //         "10 min",
                    //         style:
                    //             TextStyle(color: Colors.white, fontSize: 18.0),
                    //       ),
                    //     ],
                    //   ),
                    // )
                 
                  ],
                ),
              ),
            ),
            Container(
                height: 380,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 30.0)
                ]),
                child: SizedBox(
                    height: 350,
                    child: Image.network(widget.image, fit: BoxFit.cover))
                // SizedBox(
                //   height: 350,
                //   child: PNetworkImage(
                //     meal,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                ),
            // Positioned(
            //   top: 325,
            //   left: 20,
            //   child: CircleAvatar(
            //     backgroundColor: Colors.white,
            //     radius: 25,
            //     child: IconButton(
            //         color: icon,
            //         onPressed: () {},
            //         icon: Icon(
            //           Icons.play_arrow,
            //         )),
            //   ),
            // ),
            Positioned(
              top: 325,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                child: Text("Redeem Sekarang".toUpperCase(),
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  var idUser = Session.data.getInt("id");

                  if (idUser == null) {
                    Fluttertoast.showToast(
                        msg: "Login Terlebih dahulu",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    var data = RedeemHistory(
                        userId: idUser,
                        redeemProductId: widget.redeemProductId);

                    redeemVm.createRedeem(context, data, widget.pointRedeem);
                  }
                },
              ),
            ),
            Container(
                height: 70.0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                )),
          ],
        ),
      ),
    );
  }
}
