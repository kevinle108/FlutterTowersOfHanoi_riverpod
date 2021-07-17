import 'package:flutter/material.dart';
import '../models/disk.dart';
import '../constants_enums.dart';

class DiskWidget extends StatelessWidget {
  final Disk disk;

  DiskWidget({required this.disk});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: disk.x - disk.halfWidth,
      bottom: disk.y,
      child: Container(
        width: disk.halfWidth * 2,
        height: kDiskHeight,
        decoration: BoxDecoration(
          color: Colors.orange,
          // color: (disk.diskIndex % 2 == 0) ? Colors.purple : Colors.orange,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
