import java.util.Iterator;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

Grid grid = new Grid(16, 16);
Dancer[] dancers = new Dancer[1];
boolean isSetup = false;

void setup() {
  size(1920, 1080, P2D);
}

void draw() {
  background(0);

  translate(width * 0.5, height * 0.5);
  scale(30, 30);

  grid.draw();

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