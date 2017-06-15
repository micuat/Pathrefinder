class Grid {
  int nx, ny;

  Grid(int _nx, int _ny) {
    nx = _nx;
    ny = _ny;
  }

  void draw() {
    for (int i = -ny; i <= ny; i++) {
      for (int j = -nx; j <= nx; j++) {
        stroke(255, 128);
        strokeWeight(0.1);
        float d = 0.125;
        line(j - d, i, j + d, i);
        line(j, i - d, j, i + d);
      }
    }
  }
}