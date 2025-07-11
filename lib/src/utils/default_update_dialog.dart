import 'dart:io';
import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/utils/app_update_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:install_apk_plugin_plus/install_apk_plugin_plus.dart';
import 'package:path_provider/path_provider.dart';

class DefaultUpdateDialog extends BaseUpdateDialog {
  DefaultUpdateDialog({Key? key, required NetVersionInfo netMap})
      : super(key: key, netMap: netMap);

  @override
  _DefaultUpdateDialogState createState() => _DefaultUpdateDialogState();
}

class _DefaultUpdateDialogState extends BaseUpdateState<DefaultUpdateDialog> {
  @override
  Widget buildContent(NetVersionInfo versionInfo, String updateStr) {
    Color primaryColor =
        Theme.of(context).primaryColor; //Theme.of(context).primaryColor;
    return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: 295.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "images/update_head.png",
              package: "base_flutter",
              width: double.infinity,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('新版本更新',
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 11,),
                Text(updateStr,style: TextStyle(fontSize: 14,color: Color(0xFF333333)),),
                SizedBox(height: 20,),
                isDownload
                    ? Column(children: [
                        LinearProgressIndicator(
                          backgroundColor: Color(0xffdddddd),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                          value: value,
                        ),
                        if (downloadFinish)
                          TextButton(
                            onPressed: () {
                              InstallApkPluginPlus().installApk(filePath);
                            },
                            child: CommonText("立即安装", textColor: Colors.white),
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                backgroundColor: Colors.blue),
                          )
                      ])
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
                                        WidgetStateProperty.all(Colors.white),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                              color: Color(0xff999999),
                                              width: 0.8,
                                            )))),
                                child: Text(
                                  '暂不更新',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff999999)),
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
                                    isDownload = true;
                                  });
                                  AppUpdateUtils.instance.downloadFile(
                                      netVersion: versionInfo,
                                      errorListener: (error) {},
                                      onReceiveProgress:
                                          (count, total, filePath) {
                                        if (total != -1) {
                                          value = count / total;
                                          setState(() {});
                                          if (count == total) {
                                            this.filePath = filePath;
                                            setState(() {
                                              downloadFinish = true;
                                            });
                                            if (!versionInfo.isForce) {
                                              Navigator.pop(context);
                                            }
                                            // InstallApkPlugin.install(path);
                                            InstallApkPluginPlus()
                                                .installApk(filePath);
                                          }
                                        }
                                      });
                                } else {}
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.blue),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: Text(
                                '立即更新',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )
              ],
            ).addToContainer(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: 8.radius)),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16))
          ],
        ));
  }
}

abstract class BaseUpdateDialog extends StatefulWidget {
  final NetVersionInfo netMap;

  BaseUpdateDialog({Key? key, required this.netMap});
}

abstract class BaseUpdateState<T extends BaseUpdateDialog> extends State<T> {
  CancelToken _cancelToken = CancelToken();
  bool isDownload = false;
  bool downloadFinish = false;
  double value = 0;
  String filePath = "";
  var version = "";

  @override
  Widget build(BuildContext context) {
    var versionInfo = widget.netMap;
    var updateStr = widget.netMap.updateLog;
    if (updateStr == null || updateStr.isEmpty) {
      updateStr = '1.bug修复。\n2.提升用户体验。';
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
            child: buildContent(versionInfo, updateStr),
          )),
    );
  }

  @override
  void dispose() {
    if (!_cancelToken.isCancelled && value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    version = widget.netMap.netVerions;
  }

  Widget buildContent(NetVersionInfo versionInfo, String updateStr);
}
