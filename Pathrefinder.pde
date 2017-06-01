import java.util.Iterator;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

class Morph {
  float t = 0;
  float tEnd;
  State state;

  Morph(State _state, float _tStart, float _tEnd) {
    state = _state;
    t = _tStart;
    tEnd = _tEnd;
  }

  void start() {
    Ani.to(this, 2, "t", tEnd, Ani.QUART_IN_OUT, "onStart:onStart, onEnd:onEnd");
  }

  void onStart(Ani theAni) {
  }

  void onEnd(Ani theAni) {
    state.onMorphEnd();
  }
}

class State {
  Dancer dancer;
  Morph tx;
  Morph ty;
  Morph sx;
  Morph sy;
  ArrayList morphs = new ArrayList<Morph>();
  Iterator<Morph> itr;

  State(Dancer _dancer) {
    dancer = _dancer;
  }

  void setup(float _tx, float _ty, float _sx, float _sy) {
    tx = new Morph(this, _tx, (int)floor(random(-16, 16)));
    ty = new Morph(this, _ty, (int)floor(random(-16, 16)));
    switch((int)floor(random(3))) {
    case 0:
      sx = new Morph(this, _sx, 0);
      sy = new Morph(this, _sy, 0);
      break;
    case 1:
      if (random(1) > 0.5) {
        sx = new Morph(this, _sx, (int)floor(random(1, 4)));
        sy = new Morph(this, _sy, 0);
      } else {
        sx = new Morph(this, _sx, 0);
        sy = new Morph(this, _sy, (int)floor(random(1, 4)));
      }
      break;
    default:
      sx = new Morph(this, _sx, (int)floor(random(1, 4)));
      sy = new Morph(this, _sy, (int)floor(random(1, 4)));
      break;
    }

    if(tx.tEnd != _tx)
      morphs.add(tx);
    if(ty.tEnd != _ty)
      morphs.add(ty);
    if(sx.tEnd != _sx)
      morphs.add(sx);
    if(sy.tEnd != _sy)
      morphs.add(sy);
    nextMorph();
  }

  void nextMorph() {
    Morph m;
    if (itr == null) {
      itr = morphs.iterator();
      m = (Morph)morphs.get(0);
    } else {
      m = itr.next();
    }
    m.start();
  }

  void onMorphEnd() {
    println(this + "end");
    if (itr.hasNext()) {
      nextMorph();
    } else {
      dancer.onStateEnd();
    }
  }
}

class Dancer {
  State[] states = new State[8];
  int curState = 0;

  Dancer() {
    for (int i = 0; i < states.length; i++) {
      states[i] = new State(this);
    }
    states[0].setup(0, 0, 0, 0);
  }

  void draw() {
    stroke(255);
    strokeWeight(0.25);
    State s = states[curState];
    point(s.tx.t + s.sx.t, s.ty.t + s.sy.t);
    point(s.tx.t - s.sx.t, s.ty.t + s.sy.t);
    point(s.tx.t - s.sx.t, s.ty.t - s.sy.t);
    point(s.tx.t + s.sx.t, s.ty.t - s.sy.t);
    noFill();
    strokeWeight(0.1);
    beginShape();
    vertex(s.tx.t + s.sx.t, s.ty.t + s.sy.t);
    vertex(s.tx.t - s.sx.t, s.ty.t + s.sy.t);
    vertex(s.tx.t - s.sx.t, s.ty.t - s.sy.t);
    vertex(s.tx.t + s.sx.t, s.ty.t - s.sy.t);
    endShape(CLOSE);
    fill(255);
  }

  void onStateEnd() {
    int prevState = curState;
    curState = (curState + 1) % states.length;
    State s = states[prevState];
    states[curState].setup(s.tx.t, s.ty.t, s.sx.t, s.sy.t);
  }
}

Dancer[] dancers = new Dancer[1];

void setup() {
  size(1920, 1080, P2D);

  Ani.init(this);

  dancers[0] = new Dancer();
}

void draw() {
  background(0);

  translate(width * 0.5, height * 0.5);
  scale(30, 30);

  for (int i = -16; i <= 16; i++) {
    for (int j = -16; j <= 16; j++) {
      stroke(128);
      strokeWeight(0.1);
      float d = 0.125;
      line(j - d, i, j + d, i);
      line(j, i - d, j, i + d);
    }
  }
  for (Dancer d : dancers) {
    d.draw();
  }
}