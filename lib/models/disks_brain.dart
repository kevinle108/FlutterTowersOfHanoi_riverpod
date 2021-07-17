import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'disk.dart';
import '../constants_enums.dart';

class DisksState extends StateNotifier<List<Disk>> {
  List<List<int>> _stacks = [];
  // List<Disk> state = [];
  // int _diskCount = 4;
  int _curDiskIndex = 0;
  var _animationValues = List<double>.filled(9, 0);
  var _animationX = List<double>.filled(9, 0);
  var _animationY = List<double>.filled(9, 0);

  DisksState() : super([]){
    reset(4);
  }

  void reset(int diskCount) {
    // Create 3 empty stacks;
    _stacks.clear();
    for (int i = 0; i < 3; i++) {
      _stacks.add([]);
    }
    // Create all state and place them in stack 0
    state.clear();
    for (int i = 0; i < diskCount; i++) {
      state.add(
          Disk(diskIndex: i, x: 60, y: i * (kDiskHeight + kDiskHeightOffset)));
      _stacks[0].add(i);
    }
  }

  void incrementDisks() {
    if (state.length < 8) {
      reset(state.length+1);
    }
    state = state;
  }

  void decrementDisks() {
    if (state.length > 1) {
      reset(state.length-1);
    }
    state = state;
  }

  bool moveTopDisk(int fromRodIndex, int toRodIndex) {
    // Make sure all indices are from 0 to 2
    if (fromRodIndex < 0 ||
        fromRodIndex > 2 ||
        toRodIndex < 0 ||
        toRodIndex > 2) return false;
    // Make sure there is a disk to move
    if (_stacks[fromRodIndex].isEmpty) return false;
    // Make sure the disk to be moved is smaller than all the state at the destination
    if (_stacks[toRodIndex].isNotEmpty) {
      if (_stacks[fromRodIndex].last < _stacks[toRodIndex].last) return false;
    }
    // If we get here, the move is valid
    _curDiskIndex = _stacks[fromRodIndex].removeLast();
    double fromX = state[_curDiskIndex].x;
    double fromY = state[_curDiskIndex].y;
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
        state[_curDiskIndex].x = _animationX[i - 1] +
            fraction * (_animationX[i] - _animationX[i - 1]);
        state[_curDiskIndex].y = _animationY[i - 1] +
            fraction * (_animationY[i] - _animationY[i - 1]);
        return;
      }
    }
  }

  bool solved() {
    return _stacks[2].length == state.length;
  }

  @override
  String toString() {
    String rs = '';
    state.forEach((disk) {
      rs += disk.toString() + '\n';
    });
    return rs;
  }
}
