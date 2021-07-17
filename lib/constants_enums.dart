const double kMaxDiskHalfWidth = 60;
const double kDiskWidthOffset = 4;
const double kDiskHeight = 20;
const double kDiskHeightOffset = 2;
const double kRodHeight = 300;
const double kRodWidth = 20;
const double kFirstRodX = 60;
const double kRodDeltaX = 140;
const double kArcHeight = 100;
const String kToMoveADisk = 'To move a disk, tap source rod, then destination';
const String kGotIt = "You got it!";
const String kSolving = 'Please wait while your puzzle is being solved ...';
const String kSolved = 'Solution is complete!';
const String kInvalidMove = 'Invalid move. Try again ...';


enum Status {
  starting,
  playing,
  moving,
  solving,
  solved,
}
