import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:base_flutter/base_flutter.dart';
import 'package:flutter/services.dart';

class NetworkRecordPage extends StatefulWidget {
  static NetworkRecordPage? _instance;
  static NetworkRecordPage get instance => _instance ??= NetworkRecordPage._();
  
  NetworkRecordPage._();
  
   var isOpen = false;
  @override
  State<NetworkRecordPage> createState() => _NetworkRecordPageState();
}

class _NetworkRecordPageState extends State<NetworkRecordPage> {
 

  @override
  void initState() {
    super.initState();
    widget.isOpen = true;
  }

  @override
  void dispose() {
    widget.isOpen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('网络请求记录'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('清除记录'),
                  content: Text('确定要清除所有网络请求记录吗？'),
                  actions: [
                    TextButton(
                      child: Text('取消'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('确定'),
                      onPressed: () {
                        DevConfig.clearNetworkRecords();
                        Navigator.pop(context);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: DevConfig.networkRecords.length,
        itemBuilder: (context, index) {
          final record = DevConfig.networkRecords[index];
          return ListTile(
            title: Text(record.url),
            subtitle: Text('${record.method} - ${record.statusCode ?? "未知"}'),
            onTap: () => _showRecordDetail(context, record),
          );
        },
      ),
    );
  }

  void _showRecordDetail(BuildContext context, NetworkRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              // 拖动指示器
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('请求详情', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    // 基本信息
                    SelectableText('URL: ${record.url}',),
                    SelectableText('Method: ${record.method}'),
                    SelectableText('Time: ${record.timestamp.toString()}'),
                    SelectableText('Duration: ${record.duration.inMilliseconds}ms'),
                    SelectableText('Status: ${record.statusCode ?? "未知"}'),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      _buildSectionHeader('Headers:', record.headers),
                      Flexible(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: record.headers.entries.map((entry) => Padding(
                              padding: EdgeInsets.only(left: 16, top: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(entry.key, style: TextStyle(color: Colors.blue)),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: Text(entry.value.toString()),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ),
                        ),
                      ),
                      Divider(),
                      // Request Body 部分
                      _buildSectionHeader('Request Body:', record.requestBody),
                      Flexible(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: _buildRequestBody(record),
                        ),
                      ),
                      Divider(),
                      // Response Body 部分
                      _buildSectionHeader('Response Body:', record.responseBody),
                      Flexible(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: _buildResponseBody(record),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildRequestBody(NetworkRecord record) {
    final contentType = record.headers['content-type']?.toString().toLowerCase() ?? '';
    if (contentType.contains('json')) {
      try {
        // 尝试格式化 JSON
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        final formattedJson = encoder.convert(record.requestBody);
        return Text(formattedJson);
      } catch (e) {
        return Text(record.requestBody?.toString() ?? "空");
      }
    } else {
      // 非 JSON 格式，以键值对形式显示
      if (record.requestBody is Map) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (record.requestBody as Map).entries.map((entry) => Padding(
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key.toString(),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(entry.value.toString()),
                ),
              ],
            ),
          )).toList(),
        );
      } else {
        return Text(record.requestBody?.toString() ?? "空");
      }
    }
  }

Widget _buildSectionHeader(String title, dynamic content) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Spacer(),
        IconButton(
          icon: Icon(Icons.copy, size: 20),
          onPressed: () {
            final text = content is String ? content : json.encode(content);
            Clipboard.setData(ClipboardData(text: text));
            // ToastUtils.shotToast('已复制到剪贴板');
          },
        ),
      ],
    );
  }

Widget _buildResponseBody(NetworkRecord record) {
    try {
      if (record.responseBody != null) {
        // const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        // final formattedJson = encoder.convert(record.responseBody);
        return Text(record.responseBody);
      }
    } catch (e) {
      // JSON 格式化失败，返回原始字符串
    }
    return Text(record.responseBody?.toString() ?? "空");
  }
