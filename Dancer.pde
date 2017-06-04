class Dancer {
  State[] states = new State[8];
  int curState = 0;

  Dancer() {
    states[0] = randomState();
    states[0].setup(null);
  }

  void draw() {
    states[curState].draw(color(255, 64), -1);
    states[curState].draw(color(255, 255), 0);
    states[curState].draw(color(255, 64), 1);
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