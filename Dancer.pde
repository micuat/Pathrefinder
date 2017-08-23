class Dancer {
  State[] states = new State[8];
  int curState = 0;

  PVector[] trace = new PVector[512];
  int curTrace = 0;

  Dancer() {
    states[0] = randomState();
    states[0].setup(null);

    for (int i = 0; i < trace.length; i++) {
      trace[i] = new PVector(100000, 100000);
    }
  }

  void draw() {
    State s = states[curState];

    if (frameCount % 4 == 0) {
      trace[curTrace + 0].x = s.tx.t + (map(s.tri.t, 0, 1, s.sx.t, 0) * cos(s.r.t) - map(s.tri.t, 0, 1, s.sy.t, 0) * sin(s.r.t));
      trace[curTrace + 0].y = s.ty.t + (map(s.tri.t, 0, 1, s.sx.t, 0) * sin(s.r.t) + map(s.tri.t, 0, 1, s.sy.t, 0) * cos(s.r.t));
      trace[curTrace + 1].x = s.tx.t + (-s.sx.t * cos(s.r.t) - s.sy.t * sin(s.r.t));
      trace[curTrace + 1].y = s.ty.t + (-s.sx.t * sin(s.r.t) + s.sy.t * cos(s.r.t));
      trace[curTrace + 2].x = s.tx.t + (-s.sx.t * cos(s.r.t) + s.sy.t * sin(s.r.t));
      trace[curTrace + 2].y = s.ty.t + (-s.sx.t * sin(s.r.t) - s.sy.t * cos(s.r.t));
      trace[curTrace + 3].x = s.tx.t + (s.sx.t * cos(s.r.t) + s.sy.t * sin(s.r.t));
      trace[curTrace + 3].y = s.ty.t + (s.sx.t * sin(s.r.t) - s.sy.t * cos(s.r.t));
      curTrace = (curTrace + 4) % trace.length;
    }
    stroke(255, 0, 0);
    beginShape(POINTS);
    for (PVector v : trace) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);

    s.draw(color(255, 64), -1);
    s.draw(color(255, 255), 0);
    s.draw(color(255, 64), 1);
  }

  void onStateEnd(State prevS) {
    curState = (curState + 1) % states.length;
    states[curState] = randomState();
    states[curState].setup(prevS);
  }

  State randomState() {
    State s;
    switch((int)floor(random(4))) {
    case 0:
      s = new PointState(this);
      break;
    case 1:
      s = new LineState(this);
      break;
    case 2:
      s = new QuadState(this);
      break;
    default:
      s = new TriState(this);
      break;
    }
    return s;
  }
}