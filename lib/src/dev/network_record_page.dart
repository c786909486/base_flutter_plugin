import 'package:flutter/material.dart';
import 'package:base_flutter/base_flutter.dart';

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
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 拖动指示器
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('请求详情', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('URL: ${record.url}'),
              Text('Method: ${record.method}'),
              Text('Time: ${record.timestamp.toString()}'),
              Text('Duration: ${record.duration.inMilliseconds}ms'),
              Text('Status: ${record.statusCode ?? "未知"}'),
              Divider(),
              Text('Headers:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(record.headers.toString()),
              Divider(),
              Text('Request Body:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(record.requestBody?.toString() ?? "空"),
              Divider(),
              Text('Response Body:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(record.responseBody?.toString() ?? "空"),
            ],
          ),
        );
      },
    );
  }
}