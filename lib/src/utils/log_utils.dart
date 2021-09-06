import 'package:base_flutter/base_flutter.dart';
import 'package:base_flutter/src/utils/ext_utils.dart';

class Log {
  static bool _isDebug = true;

  static void initDebug(bool debug) {
    _isDebug = debug;
  }

  static void d(String tag, dynamic printStr,
      {StackTrace? current, bool showTime = true}) {
    if (!_isDebug) {
      return;
    }

    String msg = "D:";
    if (showTime) {
      msg +=
          "${DateTime.now().toDateStr([
                yyyy,
                "-",
                mm,
                "-",
                dd,
                " ",
                HH,
                ":",
                nn,
                ":",
                ss
              ])}:";
    }

    msg += "${tag} ===> ${printStr}";
    if (current != null) {
      _XFCustomTrace programInfo = _XFCustomTrace(current);
      var infoText = "${programInfo.fileName}:${programInfo.lineNumber}";
      msg += " ${programInfo.packageInfo}";
    }
    print(msg);
  }
}

class _XFCustomTrace {
  final StackTrace _trace;

  String? fileName;
  String? packageInfo;
  int? lineNumber;
  int? columnNumber;

  _XFCustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    var traceString = this._trace.toString().split("\n")[0];
    var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    var packageData = traceString.indexOf(RegExp('package.*dart'));
    var packageInfo = "(" + traceString.substring(packageData);
    var fileInfo = traceString.substring(indexOfFileName);
    var listOfInfos = fileInfo.split(":");
    // print("1231233"+packageInfo.toString());
    this.fileName = listOfInfos[0];
    this.lineNumber = int.parse(listOfInfos[1]);
    this.packageInfo = packageInfo;
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(")", "");
    this.columnNumber = int.parse(columnStr);
  }
}
