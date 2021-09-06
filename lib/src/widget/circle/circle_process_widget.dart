import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProcessOptions {
  double? currentValue;
  double? maxValue;
  double? strokeWidth;
  Color? strokeColor;
  Color? backgroundColor;
  double radius;

  ProcessOptions(
      {required this.radius,
      this.currentValue = 0,
      this.maxValue = 100,
      this.strokeWidth = 5,
      this.backgroundColor = Colors.white,
      this.strokeColor = Colors.blue});
}

class CircleProgressWidget extends StatefulWidget {

  ProcessOptions options;


  CircleProgressWidget(this.options);

  @override
  State<StatefulWidget> createState() => _CircleProcessState();
}

class _CircleProcessState extends State<CircleProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.options.radius * 2,
      height: widget.options.radius * 2,
      // alignment: Alignment.center,
      // color: Colors.white,
      child:CustomPaint(painter: ProcessPainter(widget.options),),
    );
  }
}

class ProcessPainter extends CustomPainter {
  ProcessOptions _progress;
  Paint? _paint;
  double? _radius;

  ProcessPainter(this._progress) {
    _paint = Paint();
    _radius = _progress.radius - (_progress.strokeWidth!) / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Rect rect = Offset.zero & size;
    // canvas.clipRect(rect); //裁剪区域
    canvas.translate(_progress.strokeWidth! / 2, _progress.strokeWidth! / 2);
    drawProgress(canvas);
  }

  drawProgress(Canvas canvas) {
    canvas.save();
    _paint!
      ..style = PaintingStyle.stroke
      ..color = _progress.backgroundColor!
      ..strokeWidth = _progress.strokeWidth!;
    canvas.drawCircle(Offset(_radius!, _radius!), _radius!, _paint!);

    _paint! //进度
      ..color = _progress.strokeColor!
      ..strokeWidth = _progress.strokeWidth! * 1.2
      ..strokeCap = StrokeCap.round;
    double sweepAngle =
        (_progress.currentValue! / _progress.maxValue!) * 360; //完成角度
    print(sweepAngle);
    canvas.drawArc(Rect.fromLTRB(0, 0, _radius! * 2, _radius! * 2),
        -90 / 180 * pi, sweepAngle / 180 * pi, false, _paint!);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
