import 'package:flutter/material.dart';
import 'package:towers_of_hanoi/models/disk.dart';
import 'rod_widget.dart';
import 'disk_widget.dart';
import '../constants_enums.dart';
import '../models/disks_brain.dart';
import 'package:towers_of_hanoi/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimationArea extends StatelessWidget {
  final Status status;
  final Function onTap;

  AnimationArea(
      {required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 450,
        //color: Colors.lightGreen,
        child: Consumer(
          builder: (context, ref, child) {
            List<Disk> disks = ref(disksStateProvider);
            return Stack(
              //alignment: Alignment.bottomLeft,
              children: [
                for (int i = 0; i < 3; i++)
                  RodWidget(
                      rodIndex: i, enabled: status == Status.playing, onTap: onTap),
                for (var disk in disks)
                  DiskWidget(
                    disk: disk,
                  ),
              ],
            );
          }
        ));
  }
}
