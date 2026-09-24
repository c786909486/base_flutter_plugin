import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../base_flutter.dart';
import 'default_update_dialog.dart';

typedef RequestNetVersionBuilder = Future<NetVersionInfo> Function();
typedef CompareListener = bool Function(NetVersionInfo info);
typedef UpdateDialogBuilder = Widget Function(BuildContext context, NetVersionInfo version);
typedef OnDownloadListener = Function(num process, num total, String filePath);

class AppUpdateUtils {
  static AppUpdateUtils? _instance;

  static AppUpdateUtils get instance => _instance ??= AppUpdateUtils._();

  AppUpdateUtils._();

  Future<void> checkVersion(
      {required BuildContext context,
      required RequestNetVersionBuilder versionRequest,
      CompareListener? compare,
      Function()? onNoUpdate,
      String? fileName,
      UpdateDialogBuilder? dialogBuilder}) async {
    var netVersion = await versionRequest();
    var needUpdate = compare!(netVersion);
    if (needUpdate) {
      showDialog(
          context: context,
          builder: (context) {
            return dialogBuilder == null
                ? DefaultUpdateDialog(
                    netMap: netVersion,
                  )
                : dialogBuilder(
                    context,
                    netVersion,
                  );
          });
    } else {
      if (onNoUpdate != null) {
        onNoUpdate();
      }
    }
  }

  Future<void> downloadFile(
      {required NetVersionInfo netVersion,
      String? fileName,
      OnDownloadListener? onReceiveProgress,
      required onRequestFail errorListener}) async {
    final name =
        "${fileName ?? "${DateTime.now().microsecond}"}_v${netVersion.netVerions}.apk";
    if (kIsWeb) {
      //web 无文件系统：savePath 仅作为下载文件名，
      //由 dio 浏览器适配器触发“另存为”，保存位置与进度由浏览器管理。
      //（path_provider / Platform.pathSeparator / File 在 web 上均不可用）
      try {
        await HttpGo.instance.dio!.download(
          netVersion.fileUrl,
          name,
          onReceiveProgress: onReceiveProgress == null
              ? null
              : (process, total) => onReceiveProgress(process, total, name),
        );
      } catch (e) {
        errorListener(e.toNetError());
      }
      return;
    }
    Directory? appDocDir = await getExternalStorageDirectory();
    var filePath =
        "${appDocDir!.path}${Platform.pathSeparator}$name";
    HttpGo.instance.downloadFile(netVersion.fileUrl, filePath, (process, total) {
      if (onReceiveProgress != null) {
        onReceiveProgress(process, total, filePath);
      }
    }, (error) {
      var file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
      errorListener(error);
    }, useNewDio: false);
  }

  /// * 版本号对比，0代表相等，1代表version1大于version2，-1代表version1小于version2
  /// * @param version1
  /// * @param version2
  ///* @return
  int compareVersion(String onLineVersion, String localVersion) {
    if (onLineVersion == localVersion) {
      return 0;
    }

    List<String> version1Array = onLineVersion.split(".");
    List<String> version2Array = localVersion.split(".");
    int index = 0;
    int minLen = min(version1Array.length, version2Array.length);
    int diff = 0;
    while (index < minLen &&
        (diff = int.parse(version1Array[index], radix: 10) -
                int.parse(version2Array[index], radix: 10)) ==
            0) {
      index++;
    }

    if (diff == 0) {
      for (int i = index; i < version1Array.length; i++) {
        if (int.parse(version1Array[i]) > 0) {
          return 1;
        }
      }
      for (int i = index; i < version2Array.length; i++) {
        if (int.parse(version2Array[i]) > 0) {
          return -1;
        }
      }
      return 0;
    } else {
      return diff > 0 ? 1 : -1;
    }
  }
}

class NetVersionInfo {
  ///服务器版本
  String netVerions;

  ///更新日志
  String? updateLog;

  ///文件下载地址
  String fileUrl;

  ///是否强更
  bool isForce;

  NetVersionInfo(
      {required this.netVerions, this.updateLog, required this.fileUrl, required this.isForce});
}
