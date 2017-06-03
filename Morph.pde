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