import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
class CacheManageUtils{

  static CacheManageUtils? _singelton;
  static Directory? _tempDir;
  static Lock _lock = Lock();

  static Future<CacheManageUtils> getInstance() async {
    if(_singelton==null){
      await _lock.synchronized(() async {
        if(_singelton==null){
          var singleton = CacheManageUtils._();
          _tempDir = await getTemporaryDirectory();
          _singelton = singleton;
        }
      });
    }
    return _singelton!;
  }

  CacheManageUtils._();


  Future<String> loadCache() async {
    double value = await _getTotalSizeOfFilesInDir(_tempDir!);
    String size = _renderSize(value);
    return size;
    //清除缓存
    // delDir(tempDir)
  }

  ///计算缓存大小（异步遍历，避免同步IO阻塞UI）
  Future _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List children = await file.list().toList();
      double total = 0;
      for (final FileSystemEntity child in children) {
        total += await _getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

 String _renderSize(double value) {
    if (value==0) {
      return "0M";
    }
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

//递归方式删除目录（异步版本）
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      await for (final FileSystemEntity child in file.list()) {
        await delDir(child);
      }
    }
    await file.delete();
  }


}
