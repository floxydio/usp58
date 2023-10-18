import 'package:flutter/material.dart';
import 'package:nyoba/provider/redeem_provider.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:provider/provider.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({Key? key}) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<RedeemProvider>(context, listen: false)
        .fetchDataRedeemHistoryById()
        .then((value) => {setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    final redeem = Provider.of<RedeemProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Redeem History",
          textAlign: TextAlign.center,
          style: TextStyle(
            // color: Colors.white,
            fontSize: responsiveFont(16),
          ),
        )),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: redeem.historyDataRedeem.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListTile(
                          title: Text(redeem.historyDataRedeem[i].title!),
                          subtitle: Text(
                              redeem.historyDataRedeem[i].redeemAt.toString()),
                          leading: Image.network(
                              "http://103.146.202.121:2000/img-redeem/" +
                                  redeem.historyDataRedeem[i].picture!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill)),
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }
}
