import 'package:dio/dio.dart';
import 'package:nyoba/models/history_redeem_model.dart';
import 'package:nyoba/models/redeem_history_model.dart';
import 'package:nyoba/services/session.dart';

class RedeemApi {
  Future<Response> fetchDataRedeem() async {
    var dio = Dio();
    var response = await dio.get("http://103.146.202.121:2000/redeem");
    print(response);
    return response;
  }

  Future<Response> fetchRedeemSetting() async {
    var dio = Dio();
    var response = await dio.get("http://103.146.202.121:2000/setting");
    print(response);
    return response;
  }

  Future<Response> createDataRedeem(
      RedeemHistory history, int pointRedeem) async {
    print(history.redeemProductId);
    Map<String, dynamic> formData = {
      "user_id": history.userId,
      "point_redeem": "-$pointRedeem",
      "redeem_point_id": history.redeemProductId,
    };
    var dio = Dio();

    var response = await dio.post(
        "http://103.146.202.121:2000/create-historyredeem",
        data: formData,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
            headers: {"Content-Type": "application/x-www-form-urlencoded"}));
    return response;
  }

  Future<List<HistoryData>> fetchDataHistoryRedeem() async {
    var dio = Dio();
    final idUser = Session.data.getInt("id");
    print(idUser);
    var response =
        await dio.get("http://103.146.202.121:2000/history-redeem/${idUser}",
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return HistoryRedeem.fromJson(response.data).data!.toList();
  }
}
