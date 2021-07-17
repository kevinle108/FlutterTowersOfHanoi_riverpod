import '../constants_enums.dart';

class Disk {
  int diskIndex;
  double x;
  double y;
  late final double halfWidth;

  Disk({required this.diskIndex, required this.x, required this.y}) {
    halfWidth = kMaxDiskHalfWidth - diskIndex * kDiskWidthOffset;
  }

  @override
  String toString() {
    return 'Disk #$diskIndex: x = $x, y = $y, halfWidth = $halfWidth';
  }
}
