import 'package:flutter/material.dart';
import '../widgets/animation_area.dart';
import '../models/disks_brain.dart';
import '../constants_enums.dart';

class TowerOfHanoi extends StatefulWidget {
  @override
  _TowerOfHanoiState createState() => _TowerOfHanoiState();
}

class _TowerOfHanoiState extends State<TowerOfHanoi>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  // late DisksBrain disksBrain;
  var status = Status.starting;
  String errorMsg = '';
  String infoMsg = '';
  int? fromRodIndex;

  bool canDecrement() {
    return status == Status.starting && disksBrain.disks.length > 1;
  }

  void decrementDisks() {
    setState(() {
      disksBrain.decrementDisks();
    });
  }

  bool canIncrement() {
    return status == Status.starting && disksBrain.disks.length < 9;
  }

  void incrementDisks() {
    setState(() {
      disksBrain.incrementDisks();
    });
  }

  bool canPlay() {
    return status == Status.starting;
  }

  void play() {
    setState(() {
      infoMsg = kToMoveADisk;
      status = Status.playing;
    });
  }

  bool canSolve() {
    return status == Status.starting;
  }

  Future solve() async {
    status = Status.solving;
    infoMsg = kSolving;
    disksBrain.reset(disksBrain.disks.length);
    await moveDisks(disksBrain.disks.length, 0, 2);
    status = Status.solved;
    infoMsg = kSolved;
  }

  bool canReset() {
    return status == Status.playing || status == Status.solved;
  }

  void reset() {
    setState(() {
      disksBrain.reset();
      status = Status.starting;
      errorMsg = '';
      infoMsg = '';
    });
  }

  Future onTap(int rodIndex) async {
    errorMsg = '';
    if (fromRodIndex == null) {
      fromRodIndex = rodIndex;
      infoMsg =
          'Moving the disk at rod ${String.fromCharCode(rodIndex + 65)} ...';
    } else {
      infoMsg =
          'Moving the disk at rod ${String.fromCharCode(fromRodIndex! + 65)}' +
              ' to rod ${String.fromCharCode(rodIndex + 65)}';
      status = Status.moving;
      await moveDisk(fromRodIndex!, rodIndex);
      fromRodIndex = null;
      if (disksBrain.solved()) {
        infoMsg = kGotIt;
        status = Status.solved;
      } else {
        infoMsg = kToMoveADisk;
        status = Status.playing;
      }
    }
    setState(() {});
  }

  Future moveDisk(int fromRodIndex, int toRodIndex) async {
    if (disksBrain.moveTopDisk(fromRodIndex, toRodIndex)) {
      controller.reset();
      await controller.forward();
    } else {
      errorMsg = kInvalidMove;
    }
  }

  Future moveDisks(int numDisks, int fromRodIndex, int toRodIndex) async {
    if (numDisks > 1) {
      await moveDisks(
          numDisks - 1, fromRodIndex, 3 - fromRodIndex - toRodIndex);
      await moveDisk(fromRodIndex, toRodIndex);
      await moveDisks(numDisks - 1, 3 - fromRodIndex - toRodIndex, toRodIndex);
    } else {
      await moveDisk(fromRodIndex, toRodIndex);
    }
  }

  @override
  void initState() {
    super.initState();

    disksBrain = DisksBrain();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    animation.addListener(() {
      disksBrain.move(animation.value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tower of Hanoi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMsg, style: TextStyle(fontSize: 16, color: Colors.red)),
          Text(infoMsg, style: TextStyle(fontSize: 16)),
          AnimationArea(status: status, disksBrain: disksBrain, onTap: onTap),
          SizedBox(
              height: 30,
              child: Container(
                color: Colors.black54,
              )),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                  onPressed: canDecrement() ? () => decrementDisks() : null,
                  child: Icon(Icons.remove)),
              ElevatedButton(
                  onPressed: canIncrement() ? () => incrementDisks() : null,
                  child: Icon(Icons.add)),
              ElevatedButton(
                  onPressed: canPlay() ? () => play() : null,
                  child: Text('Play')),
              ElevatedButton(
                  onPressed: canSolve() ? () => solve() : null,
                  child: Text('Solve')),
              ElevatedButton(
                  onPressed: canReset() ? () => reset() : null,
                  child: Text('Reset')),
            ],
          ),
        ],
      ),
    );
  }
}
