import 'package:permission_handler/permission_handler.dart';

class PermissionRequest{

  static Future<dynamic> requestPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }

  static bool isLackPermission(List<Permission> permissions){
    bool lack = true;
    permissions.forEach((element) async {
      if(await element.status.isGranted){
        lack = false;
      }else{
        lack = true;
      }
    });
    return lack;
  }
}