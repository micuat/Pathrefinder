import java.util.Iterator;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

class Morph {
  float t = 0;
  float tStart, tEnd;
  State state;

  Morph(State _state, float _tStart, float _tEnd) {
    state = _state;
    t = tStart = _tStart;
    tEnd = _tEnd;

    if (_tStart == _tEnd) {
    } else {
      state.morphs.add(this);
    }
  }

  void start() {
    if (tStart != tEnd)
      Ani.to(this, 2, "t", tEnd, Ani.QUART_IN_OUT, "onStart:onStart, onEnd:onEnd");
  }

  void onStart(Ani theAni) {
  }

  void onEnd(Ani theAni) {
    state.onMorphEnd(this);
  }

  float get(int tense) {
    if (tense < 0) return tStart; // past
    else if (tense == 0) return t; // present
    else return tEnd; // future
  }
}

class State {
  Dancer dancer;
  Morph r;
  Morph tx;
  Morph ty;
  Morph sx;
  Morph sy;
  Morph tri;
  ArrayList morphs = new ArrayList<Morph>();
  Iterator<Morph> itr;

  State(Dancer _dancer) {
    dancer = _dancer;
  }

  void setup(State _s) {
    setup(_s.r.t, _s.tx.t, _s.ty.t, _s.sx.t, _s.sy.t, _s.tri.t);
  }

  void setup(float _r, float _tx, float _ty, float _sx, float _sy, float _tri) {
    r = new Morph(this, _r, 0.5 * PI * (int)floor(random(0, 2)));
    tx = new Morph(this, _tx, (int)floor(random(-16, 16)));
    ty = new Morph(this, _ty, (int)floor(random(-16, 16)));
    switch((int)floor(random(4))) {
    case 0:
      sx = new Morph(this, _sx, 0);
      sy = new Morph(this, _sy, 0);
      tri = new Morph(this, _tri, 0);
      break;
    case 1:
      if (random(1) > 0.5) {
        sx = new Morph(this, _sx, (int)floor(random(1, 8)));
        sy = new Morph(this, _sy, 0);
      } else {
        sx = new Morph(this, _sx, 0);
        sy = new Morph(this, _sy, (int)floor(random(1, 8)));
      }
      tri = new Morph(this, _tri, 0);
      break;
    case 2:
      sx = new Morph(this, _sx, (int)floor(random(1, 8)));
      sy = new Morph(this, _sy, (int)floor(random(1, 8)));
      tri = new Morph(this, _tri, 1);
      break;
    case 3:
      sx = new Morph(this, _sx, (int)floor(random(1, 8)));
      sy = new Morph(this, _sy, (int)floor(random(1, 8)));
      tri = new Morph(this, _tri, 0);
      break;
    }

    if (morphs.size() == 0) { // nothing to do
      dancer.onStateEnd(this);
      return;
    }
    itr = morphs.iterator();
    nextMorph();
  }

  void nextMorph() {
    Morph m = itr.next();
    m.start();
  }

  void onMorphEnd(Morph m) {
    if (itr.hasNext()) {
      nextMorph();
    } else {
      dancer.onStateEnd(this);
    }
  }

  void draw(color c, int tense) {
    pushMatrix();

    translate(tx.get(tense), ty.get(tense));
    rotate(r.get(tense));

    stroke(c);
    strokeWeight(0.25);
    drawRect(sx.get(tense), sy.get(tense), tri.get(tense), POINTS);

    noFill();
    strokeWeight(0.1);
    drawRect(sx.get(tense), sy.get(tense), tri.get(tense), QUADS);
    fill(255);

    popMatrix();
  }

  void drawRect(float x, float y, float tri, int mode) {
    beginShape(mode);
    vertex(map(tri, 0, 1, x, 0), map(tri, 0, 1, y, 0));
    vertex(-x, y);
    vertex(-x, -y);
    vertex(x, -y);
    endShape(CLOSE);
  }
}

class Dancer {
  State[] states = new State[8];
  int curState = 0;

  Dancer() {
    for (int i = 0; i < states.length; i++) {
      states[i] = new State(this);
    }
    states[0].setup(0, 0, 0, 0, 0, 0);
  }

  void draw() {
    states[curState].draw(color(255, 64), -1);
    states[curState].draw(color(255, 255), 0);
    states[curState].draw(color(255, 64), 1);
  }

  void onStateEnd(State prevS) {
    curState = (curState + 1) % states.length;
    states[curState].setup(prevS);
  }
}

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