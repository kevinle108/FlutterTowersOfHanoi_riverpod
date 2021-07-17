import 'dart:math';
import 'disk.dart';
import '../constants_enums.dart';

class DisksBrain {
  List<List<int>> _stacks = [];
  List<Disk> disks = [];
  int diskCount = 0;
  int _curDiskIndex = 0;
  var _animationValues = List<double>.filled(9, 0);
  var _animationX = List<double>.filled(9, 0);
  var _animationY = List<double>.filled(9, 0);

  DisksBrain({required this.diskCount}) {
    reset();
  }

  void reset() {
    // Create 3 empty stacks;
    _stacks.clear();
    for (int i = 0; i < 3; i++) {
      _stacks.add([]);
    }
    // Create all disks and place them in stack 0
    disks.clear();
    for (int i = 0; i < diskCount; i++) {
      disks.add(
          Disk(diskIndex: i, x: 60, y: i * (kDiskHeight + kDiskHeightOffset)));
      _stacks[0].add(i);
    }
  }

  void incrementDisks() {
    if (diskCount < 9) {
      diskCount++;
      reset();
    }
  }

  void decrementDisks() {
    if (diskCount > 1) {
      diskCount--;
      reset();
    }
  }

  bool moveTopDisk(int fromRodIndex, int toRodIndex) {
    // Make sure all indices are from 0 to 2
    if (fromRodIndex < 0 ||
        fromRodIndex > 2 ||
        toRodIndex < 0 ||
        toRodIndex > 2) return false;
    // Make sure there is a disk to move
    if (_stacks[fromRodIndex].isEmpty) return false;
    // Make sure the disk to be moved is smaller than all the disks at the destination
    if (_stacks[toRodIndex].isNotEmpty) {
      if (_stacks[fromRodIndex].last < _stacks[toRodIndex].last) return false;
    }
    // If we get here, the move is valid
    _curDiskIndex = _stacks[fromRodIndex].removeLast();
    double fromX = disks[_curDiskIndex].x;
    double fromY = disks[_curDiskIndex].y;
    double toX = kFirstRodX + kRodDeltaX * toRodIndex;
    double toY = (kDiskHeight + kDiskHeightOffset) * _stacks[toRodIndex].length;
    _stacks[toRodIndex].add(_curDiskIndex);
    // Calculate distances
    double centerX = (fromX + toX) / 2;
    double signedRadius = (fromX - toX) / 2;

    double timeGoingUp = 0.3;
    double timeGoingOnCurve = 0.4;
    if (centerX == kFirstRodX + kRodDeltaX) {
      timeGoingUp = 0.25;
      timeGoingOnCurve = 0.5;
    }
    // Fill the animation lists
    _animationValues[0] = 0;
    _animationX[0] = fromX;
    _animationY[0] = fromY;
    double radiansFor30deg = asin(1) / 3;
    for (int i = 0; i < 7; i++) {
      _animationValues[i + 1] = timeGoingUp + timeGoingOnCurve / 6 * (i);
      _animationX[i + 1] = centerX + signedRadius * cos(radiansFor30deg * i);
      _animationY[i + 1] = kRodHeight + kArcHeight * sin(radiansFor30deg * i);
    }
    _animationValues[8] = 1;
    _animationX[8] = toX;
    _animationY[8] = toY;
    return true;
  }

  void move(double animationValue) {
    for (int i = 1; i < 9; i++) {
      if (animationValue <= _animationValues[i]) {
        double fraction = (animationValue - _animationValues[i - 1]) /
            (_animationValues[i] - _animationValues[i - 1]);
        disks[_curDiskIndex].x = _animationX[i - 1] +
            fraction * (_animationX[i] - _animationX[i - 1]);
        disks[_curDiskIndex].y = _animationY[i - 1] +
            fraction * (_animationY[i] - _animationY[i - 1]);
        return;
      }
    }
  }

  bool solved() {
    return _stacks[2].length == diskCount;
  }

  @override
  String toString() {
    String rs = '';
    disks.forEach((disk) {
      rs += disk.toString() + '\n';
    });
    return rs;
  }
}
