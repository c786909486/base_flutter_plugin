import 'dart:io';
import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/utils/app_update_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:install_apk_plugin/install_apk_plugin.dart';
import 'package:path_provider/path_provider.dart';

class DefaultUpdateDialog extends StatefulWidget {
  final NetVersionInfo netMap;

  DefaultUpdateDialog({Key? key, required this.netMap});

  @override
  _DefaultUpdateDialogState createState() => _DefaultUpdateDialogState();
}

class _DefaultUpdateDialogState extends State<DefaultUpdateDialog> {
  CancelToken _cancelToken = CancelToken();
  bool _isDownload = false;
  double _value = 0;
  var version = "";

  @override
  void dispose() {
    if (!_cancelToken.isCancelled && _value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    version = widget.netMap.netVerions;
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor =
        Theme.of(context).primaryColor; //Theme.of(context).primaryColor;
    var versionInfo = widget.netMap;
    var updateStr = widget.netMap.updateLog;
    if (updateStr == null || updateStr.isEmpty) {
      updateStr = '1.bug修复。\n\n2.提升用户体验。';
    }

    return WillPopScope(
      onWillPop: () async {
        /// 使用false禁止返回键返回，达到强制升级目的
        return !versionInfo.isForce;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                width: 280.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        height: 120.0,
                        width: 280.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: const Radius.circular(8.0),
                              topRight: const Radius.circular(8.0)),
                          image: DecorationImage(
                            image: AssetImage("images/update_head.jpg",
                                package: 'base_flutter'),
                            fit: BoxFit.cover,
                          ),
                        )),
                    const Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 16.0),
                      child: const Text('新版本更新',
                          style: TextStyle(
                              color: Color(0xff333333), fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Text(updateStr),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, left: 15.0, right: 15.0, top: 5.0),
                      child: _isDownload
                          ? LinearProgressIndicator(
                              backgroundColor: Color(0xffdddddd),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(primaryColor),
                              value: _value,
                            )
                          : Row(
                              mainAxisAlignment: versionInfo.isForce
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                if (!versionInfo.isForce)
                                  Container(
                                    width: 110.0,
                                    height: 36.0,
                                    child: TextButton(
                                      onPressed: () {
                                        // NavigatorUtils.goBack(context);
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.white),
                                          shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                    color: primaryColor,
                                                    width: 0.8,
                                                  )))),
                                      child: Text(
                                        '残忍拒绝',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff999999)),
                                      ),
                                    ),
                                  ),
                                Container(
                                  width: 110.0,
                                  height: 36.0,
                                  child: TextButton(
                                    onPressed: () {
                                      if (defaultTargetPlatform ==
                                          TargetPlatform.android) {
                                        // Navigator.pop(context);
                                        // InstallApkPlugin.jumpToAppStore();
                                        setState(() {
                                          _isDownload = true;
                                        });
                                        AppUpdateUtils.instance.downloadFile(
                                            netVersion: versionInfo,
                                            errorListener: (error) {},
                                            onReceiveProgress: (count, total,filePath) {
                                              if (total != -1) {
                                                _value = count / total;
                                                setState(() {});
                                                if (count == total) {
                                                  Navigator.pop(context);
                                                  // InstallApkPlugin.install(path);
                                                  InstallApkPlugin.installApk(filePath);
                                                }
                                              }
                                            });
                                      } else {}
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                Colors.blue),
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                    child: Text(
                                      '立即更新',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    )
                  ],
                )),
          )),
    );
  }
}
