import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/disks_brain.dart';
import 'models/disk.dart';

final disksStateProvider = StateNotifierProvider<DisksState, List<Disk>>((ref) {
  return DisksState();
});