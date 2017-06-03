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