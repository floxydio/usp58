import 'package:nyoba/services/base_woo_api.dart';

String appId = '1569566623';
String url = "https://uspatih.id/store";

// oauth_consumer_key
String consumerKey = "ck_6c0f155c25d2c7e71200245ce3e0c666d6275c93";
String consumerSecret = "cs_266620bdcf53161534fbd20ce55cac50ee84bd57";

// String version = '2.5.6';

// baseAPI for WooCommerce
BaseWooAPI baseAPI = BaseWooAPI(url, consumerKey, consumerSecret);

const debugNetworkProxy = false;
