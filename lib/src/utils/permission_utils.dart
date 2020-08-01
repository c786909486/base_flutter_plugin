import 'package:permission_handler/permission_handler.dart';

class PermissionUtils{

  Future<dynamic> requestPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }

//  Future<bool> isLackPermissions(List<Permission> permissions){
//    bool lack = true;
//    permissions.forEach((element) async {
//      var status = await element.status;
//      if(status.isUndetermined){
//        lack = true;
//      }else if(status.isDenied){
//        lack = true;
//      }else if(status.isGranted){
//        lack = false;
//      }
//    })
//  }
}