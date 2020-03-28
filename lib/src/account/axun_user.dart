import 'package:base_flutter/src/utils/share_preference_utils.dart';

class AxunUser {
  static String userId = "";
  static String userName = "";
  static String customerId = "";
  static String userAddress = "";
  static String userAddressId="";
  static String phone="";
  static String memberCode="";
  static String key = "a736c0c78c2c407b922c0e6d360cdd1b";
  static String picturePassword = "";
  static String deviceCode = "";

  void initUser() async {
    AxunUser.userId = await getString("userId");
    AxunUser.userName = await getString("userName");
    AxunUser.customerId = await getString("customerId");
    AxunUser.picturePassword = await getString("picturePassword");
    if (AxunUser.userId == null) {
      AxunUser.userId = "";
    }

    if (AxunUser.userName == null) {
      AxunUser.userName = "";
    }

    if (AxunUser.customerId == null) {
      AxunUser.customerId = "";
    }
  }

  void logout() async {
    await remove("userId");
    await remove("userName");
    await remove("customerId");
    AxunUser.userId = "";
    AxunUser.userName = "";
    AxunUser.customerId = "";
    AxunUser.deviceCode = "";
  }
}
