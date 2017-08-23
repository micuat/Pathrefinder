import java.util.Iterator;

import controlP5.*;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

ControlP5 cp5;

Grid grid = new Grid(16, 16);
Dancer[] dancers = new Dancer[1];
boolean isSetup = false;

void setup() {
  size(1920, 1080, P2D);
  cp5 = new ControlP5(this);
  cp5.addSlider("r")
    .setPosition(100, 140)
    .setRange(0, 1);
  cp5.addSlider("tx")
    .setPosition(100, 170)
    .setRange(0, 1);
  cp5.addSlider("ty")
    .setPosition(100, 200)
    .setRange(0, 1);
  cp5.addSlider("sx")
    .setPosition(100, 230)
    .setRange(0, 1);
  cp5.addSlider("sy")
    .setPosition(100, 260)
    .setRange(0, 1);
  cp5.addSlider("tri")
    .setPosition(100, 290)
    .setRange(0, 1);
}

void draw() {
  background(0);

  pushMatrix();
  translate(width * 0.5, height * 0.5);
  scale(30, 30);

  grid.draw();

  if (!isSetup) {
    if (millis() < 5000) {
    } else {
      Ani.init(this);

      for (int i = 0; i < dancers.length; i++)
        dancers[i] = new Dancer();

      isSetup = true;
    }
  }

  if (isSetup) {
    for (Dancer d : dancers) {
      d.draw();
    }
  }

  popMatrix();
}