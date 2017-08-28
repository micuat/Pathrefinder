import java.util.Iterator;
import java.util.Date;

import controlP5.*;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

PrintWriter scoreLog, motionLog;

ControlP5 cp5;

Grid grid = new Grid(12, 12);
Dancer[] dancers = new Dancer[1];
boolean isSetup = false;

void setup() {
  size(1920, 1080, P2D);
  frameRate(30);

  String d = nf(year(), 4) + "-" + nf(month(), 2) + "-" + nf(day(), 2) + "-" + nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2);
  scoreLog = createWriter("log/" + d + "-score.txt");
  motionLog = createWriter("log/" + d + "-motion.txt");

  PFont f = createFont("SourceCodePro-Regular.ttf", 20);
  cp5 = new ControlP5(this, f);
  cp5.begin(1350, 200);
  cp5.addSlider("r")
    .setRange(0, 1)
    .setHeight(15)
    .linebreak();
  cp5.addSlider("tx")
    .setRange(0, 1)
    .setHeight(15)
    .linebreak();
  cp5.addSlider("ty")
    .setRange(0, 1)
    .setHeight(15)
    .linebreak();
  cp5.addSlider("sx")
    .setRange(0, 1)
    .setHeight(15)
    .linebreak();
  cp5.addSlider("sy")
    .setRange(0, 1)
    .setHeight(15)
    .linebreak();
  cp5.addSlider("tri")
    .setRange(0, 1)
    .setHeight(15)
    .linebreak();
  cp5.end();
  cp5.addTextarea("score")
    .setPosition(1350, 550)
    .setWidth(300)
    .setHeight(500);
}

void draw() {
  background(0);

  pushMatrix();
  translate(width * 0.5, height * 0.5);
  scale(30, 30);

  grid.draw();

  if (!isSetup) {
    if (millis() < 5000*2) {
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

  if (key == ' ') {
    saveFrame("######.png");
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0;
    scoreLog.flush();
    scoreLog.close();
    motionLog.flush();
    motionLog.close();
    exit();
  }
}