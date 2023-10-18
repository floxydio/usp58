import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nyoba/models/history_redeem_model.dart';
import 'package:nyoba/models/redeem_history_model.dart';
import 'package:nyoba/models/redeem_model.dart';
import 'package:nyoba/models/redeem_setting_model.dart';
import 'package:nyoba/pages/home/home_screen.dart';
import 'package:nyoba/pages/redeem/redeem_screen.dart';
import 'package:nyoba/services/redeem_api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RedeemProvider with ChangeNotifier {
  List<RedeemData> redeemData = [];
  Future<void> getDataRedeem() async {
    redeemData = [];
    await RedeemApi().fetchDataRedeem().then((data) {
      var res = data.data;
      if (data.statusCode == 200) {
        print("RESSSSS -> ${res}");
        redeemData = RedeemModel.fromJson(res).data!;
      } else if (data.statusCode != 400) {
        Fluttertoast.showToast(
            msg: data.data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      notifyListeners();
    });
  }

  RedeemSettingData redeemSettingData = RedeemSettingData();

  Future<void> fetchRedeemSetting() async {
    redeemSettingData = RedeemSettingData();
    await RedeemApi().fetchRedeemSetting().then((value) {
      var res = value.data;
      if (value.statusCode == 200) {
        redeemSettingData = RedeemSetting.fromJson(res).data!;
        print(redeemSettingData);
      } else {
        Fluttertoast.showToast(
            msg: value.data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
    notifyListeners();
  }

  void createRedeem(
      BuildContext context, RedeemHistory form, int pointRedeem) async {
    await RedeemApi().createDataRedeem(form, pointRedeem).then((data) {
      var res = data.data;
      print(data.statusCode);
      if (data.statusCode == 200) {
        print(res);
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Lottie.asset(
                    "lottie/success.json",
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Berhasil Redeem")
                ]),
              );
            });
      } else if (data.statusCode != 200) {
        Fluttertoast.showToast(
            msg: data.data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      notifyListeners();
    });
  }

  List<HistoryData> historyDataRedeem = [];

  Future<void> fetchDataRedeemHistoryById() async {
    historyDataRedeem.clear();
    await RedeemApi().fetchDataHistoryRedeem().then((value) => {
          if (value.isEmpty)
            {
              Fluttertoast.showToast(
                  msg: "Data Kosong",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            }
          else
            {historyDataRedeem.addAll(value)}
        });
    notifyListeners();
  }
}
