enum GridSize {
  three,
  four,
  five;

  int get size => switch (this) {
    GridSize.three => 3,
    GridSize.four => 4,
    GridSize.five => 5,
  };

  int get nCells => size * size;
}
