// import '../../base_flutter.dart';
//
// class PermissionUtils{
//   static Future<Map<Permission, PermissionStatus>> requestPermissions(
//       List<Permission> permissions) async {
//     Map<Permission, PermissionStatus> statuses = await permissions.request();
//     return statuses;
//   }
//
//   static Future<bool> isLackPermissions(List<Permission> permissions) async {
//     bool lack = true;
//     permissions.forEach((element) async {
//       if (await element.status.isGranted) {
//         lack = false;
//       } else {
//         lack = true;
//       }
//     });
//     return lack;
//   }
//
//
//   static Future<bool> isLackPermission(Permission permission) async {
//     if (await permission.status.isGranted) {
//       return false;
//     } else {
//       return true;
//     }
//   }
// }
//
//
// typedef OnRequestListener = Function(bool hasPermission);
// extension PermissionsExt on List<Permission>{
//   ///申请权限
//   Future<void> requestPermissions(OnRequestListener listener) async {
//     var lackPermissions = await PermissionUtils.isLackPermissions(this);
//     if(lackPermissions){
//       var result = await PermissionUtils.requestPermissions(this);
//       var hasPermission = true;
//       this.forEach((element) {
//         var result2 = result[element];
//         if(result2!=PermissionStatus.granted){
//           hasPermission = false;
//         }
//       });
//       listener(hasPermission);
//     }else{
//       listener(true);
//     }
//   }
//
// }
//
// extension PermissionExt on Permission{
//   Future<void> checkPermission(OnRequestListener listener) async {
//     var lackPermissions = await PermissionUtils.isLackPermission(this);
//     if(lackPermissions){
//       var result = await PermissionUtils.requestPermissions([this]);
//       var data = result[this];
//       if(data==PermissionStatus.granted){
//         listener(true);
//       }else{
//         listener(false);
//       }
//     }else{
//       listener(true);
//     }
//   }
// }