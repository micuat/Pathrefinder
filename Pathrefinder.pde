import java.util.Iterator;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

Dancer[] dancers = new Dancer[8];
boolean isSetup = false;

void setup() {
  size(1920, 1080, P2D);
}

void draw() {
  background(0);

  translate(width * 0.5, height * 0.5);
  scale(30, 30);

  drawGrid(16, 16);

  if (!isSetup) {
    if (millis() < 5000) return;
    else {
      Ani.init(this);

      for (int i = 0; i < dancers.length; i++)
        dancers[i] = new Dancer();

      isSetup = true;
    }
  }

  for (Dancer d : dancers) {
    d.draw();
  }
}

void drawGrid(int x, int y) {
  for (int i = -y; i <= y; i++) {
    for (int j = -x; j <= x; j++) {
      stroke(255, 128);
      strokeWeight(0.1);
      float d = 0.125;
      line(j - d, i, j + d, i);
      line(j, i - d, j, i + d);
    }
  }
}