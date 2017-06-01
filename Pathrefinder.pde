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
    Ani.to(this, 3, "t", tEnd, Ani.QUART_IN_OUT, "onStart:onStart, onEnd:onEnd");
  }

  void onStart(Ani theAni) {
  }

  void onEnd(Ani theAni) {
    state.onMorphEnd();
  }
}

class State {
  Dancer dancer;
  Morph x;
  Morph y;
  int endCount = 0;

  State(Dancer _dancer) {
    dancer = _dancer;
  }

  void setup(float _x, float _y) {
    endCount = 0;
    x = new Morph(this, _x, random(-16, 16));
    y = new Morph(this, _y, random(-16, 16));
    x.start();
  }

  void onMorphEnd() {
    println(this + "end");
    endCount++;
    if(endCount == 1) {
      y.start();
    }
    if (endCount >= 2) {
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
    states[0].setup(0, 0);
  }

  void draw() {
    stroke(255);
    strokeWeight(3);
    point(states[curState].x.t, states[curState].y.t);
  }

  void onStateEnd() {
    int prevState = curState;
    curState = (curState + 1) % states.length;
    states[curState].setup(states[prevState].x.t, states[prevState].y.t);
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
  scale(20, 20);
  for (Dancer d : dancers) {
    d.draw();
  }
}