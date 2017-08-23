class Morph {
  float t = 0;
  float tStart, tEnd;
  State state;

  Morph(State _state, float _tStart, float _tEnd, float _t) {
    state = _state;
    tStart = _tStart;
    tEnd = _tEnd;
    t = _t;

    state.morphs.add(this);
  }

  Morph(State _state, float _tStart, float _tEnd) {
    state = _state;
    t = tStart = _tStart;
    tEnd = _tEnd;

    state.morphs.add(this);
  }

  void start() {
    t = tStart;
    if (tStart != tEnd)
      Ani.to(this, 2, "t", tEnd, Ani.QUART_IN_OUT, "onStart:onStart, onEnd:onEnd");
    else {
      state.onMorphEnd(this);
    }
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

  float p() {
    return (t - tStart) / (tEnd - tStart);
  }
}