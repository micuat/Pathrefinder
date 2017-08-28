abstract class State {
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
    setupMorphs(_s);

    if (morphs.size() == 0) { // nothing to do
      dancer.onStateEnd(this);
      return;
    }

    Textarea ta = (Textarea)cp5.get("score");
    String score = "score: " + str(morphs.size());
    score += "\n  r: " + nfp(r.tStart, 2, 3) + " -> " + nfp(r.tEnd, 2, 3);
    score += "\n tx: " + nfp(tx.tStart, 2, 3) + " -> " + nfp(tx.tEnd, 2, 3);
    score += "\n ty: " + nfp(ty.tStart, 2, 3) + " -> " + nfp(ty.tEnd, 2, 3);
    score += "\n sx: " + nfp(sx.tStart, 2, 3) + " -> " + nfp(sx.tEnd, 2, 3);
    score += "\n sy: " + nfp(sy.tStart, 2, 3) + " -> " + nfp(sy.tEnd, 2, 3);
    score += "\ntri: " + nfp(tri.tStart, 2, 3) + " -> " + nfp(tri.tEnd, 2, 3);
    ta.setText(score);

    Date d = new Date();
    score = str(int(d.getTime() / 1000)) + "." + str(int(d.getTime() % 1000)) + " r: " + nfp(r.tStart, 2, 3) + " -> " + nfp(r.tEnd, 2, 3);
    score += " tx: " + nfp(tx.tStart, 2, 3) + " -> " + nfp(tx.tEnd, 2, 3);
    score += " ty: " + nfp(ty.tStart, 2, 3) + " -> " + nfp(ty.tEnd, 2, 3);
    score += " sx: " + nfp(sx.tStart, 2, 3) + " -> " + nfp(sx.tEnd, 2, 3);
    score += " sy: " + nfp(sy.tStart, 2, 3) + " -> " + nfp(sy.tEnd, 2, 3);
    score += " tri: " + nfp(tri.tStart, 2, 3) + " -> " + nfp(tri.tEnd, 2, 3);
    score += "\n";
    print(score);

    itr = morphs.iterator();
    nextMorph();
  }

  abstract void setupMorphs(State _s);
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

    if (tense == 0) {
      cp5.get("r").setValue(r.p());
      cp5.get("tx").setValue(tx.p());
      cp5.get("ty").setValue(ty.p());
      cp5.get("sx").setValue(sx.p());
      cp5.get("sy").setValue(sy.p());
      cp5.get("tri").setValue(tri.p());
    }
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

class PointState extends State {
  PointState(Dancer _dancer) {
    super(_dancer);
  }

  void setupMorphs(State _s) {
    float _r, _tx, _ty, _sx, _sy, _tri;
    if (_s == null) {
      _r = 0;
      _tx = 0;
      _ty = 0;
      _sx = 0;
      _sy = 0;
      _tri = 0;
    } else {
      _r = _s.r.t;
      _tx = _s.tx.t;
      _ty = _s.ty.t;
      _sx = _s.sx.t;
      _sy = _s.sy.t;
      _tri = _s.tri.t;
    }
    float rEnd = 0;
    if (_s == null || _s.getClass().getName().equals("Pathrefinder$PointState")) {
      r = new Morph(this, rEnd, rEnd);
    } else {
      r = new Morph(this, _r, rEnd);
    }
    tri = new Morph(this, _tri, 0); // TODO: I don't like this to be in the beginning
    tx = new Morph(this, _tx, (int)floor(random(-grid.nx, grid.nx)));
    ty = new Morph(this, _ty, (int)floor(random(-grid.ny, grid.ny)));
    sx = new Morph(this, _sx, 0);
    sy = new Morph(this, _sy, 0);

    if (morphs.size() == 0) { // nothing to do
      dancer.onStateEnd(this);
      return;
    }
    itr = morphs.iterator();
    nextMorph();
  }
}

class LineState extends State {
  LineState(Dancer _dancer) {
    super(_dancer);
  }

  void setupMorphs(State _s) {
    float _r, _tx, _ty, _sx, _sy, _tri;
    if (_s == null) {
      _r = 0;
      _tx = 0;
      _ty = 0;
      _sx = 0;
      _sy = 0;
      _tri = 0;
    } else {
      _r = _s.r.t;
      _tx = _s.tx.t;
      _ty = _s.ty.t;
      _sx = _s.sx.t;
      _sy = _s.sy.t;
      _tri = _s.tri.t;
    }
    float rEnd = 0.5 * PI * (int)floor(random(0, 2));
    if (_s == null || _s.getClass().getName().equals("Pathrefinder$PointState")) {
      r = new Morph(this, rEnd, rEnd);
    } else {
      r = new Morph(this, _r, rEnd);
    }
    tx = new Morph(this, _tx, (int)floor(random(-grid.nx, grid.nx)));
    ty = new Morph(this, _ty, (int)floor(random(-grid.ny, grid.ny)));
    sx = new Morph(this, _sx, (int)floor(random(1, grid.nx / 2)));
    sy = new Morph(this, _sy, 0);
    tri = new Morph(this, _tri, 0);

    if (morphs.size() == 0) { // nothing to do
      dancer.onStateEnd(this);
      return;
    }
    itr = morphs.iterator();
    nextMorph();
  }
}

class QuadState extends State {
  QuadState(Dancer _dancer) {
    super(_dancer);
  }
  void setupMorphs(State _s) {
    float _r, _tx, _ty, _sx, _sy, _tri;
    if (_s == null) {
      _r = 0;
      _tx = 0;
      _ty = 0;
      _sx = 0;
      _sy = 0;
      _tri = 0;
    } else {
      _r = _s.r.t;
      _tx = _s.tx.t;
      _ty = _s.ty.t;
      _sx = _s.sx.t;
      _sy = _s.sy.t;
      _tri = _s.tri.t;
    }
    float rEnd = 0.5 * PI * (int)floor(random(0, 2));
    if (_s == null || _s.getClass().getName().equals("Pathrefinder$PointState")) {
      r = new Morph(this, rEnd, rEnd);
    } else {
      r = new Morph(this, _r, rEnd);
    }
    tx = new Morph(this, _tx, (int)floor(random(-grid.nx, grid.nx)));
    ty = new Morph(this, _ty, (int)floor(random(-grid.ny, grid.ny)));
    sx = new Morph(this, _sx, (int)floor(random(1, grid.nx / 2)));
    sy = new Morph(this, _sy, (int)floor(random(1, grid.ny / 2)));
    tri = new Morph(this, _tri, 0);

    if (morphs.size() == 0) { // nothing to do
      dancer.onStateEnd(this);
      return;
    }
    itr = morphs.iterator();
    nextMorph();
  }
}

class TriState extends State {
  TriState(Dancer _dancer) {
    super(_dancer);
  }

  void setupMorphs(State _s) {
    float _r, _tx, _ty, _sx, _sy, _tri;
    if (_s == null) {
      _r = 0;
      _tx = 0;
      _ty = 0;
      _sx = 0;
      _sy = 0;
      _tri = 0;
    } else {
      _r = _s.r.t;
      _tx = _s.tx.t;
      _ty = _s.ty.t;
      _sx = _s.sx.t;
      _sy = _s.sy.t;
      _tri = _s.tri.t;
    }
    // allow 180, 270 as they are not symmetric
    float rEnd = 0.5 * PI * (int)floor(random(0, 4));
    if (_s == null || _s.getClass().getName().equals("Pathrefinder$PointState")) {
      r = new Morph(this, rEnd, rEnd);
    } else {
      r = new Morph(this, _r, rEnd);
    }
    tx = new Morph(this, _tx, (int)floor(random(-grid.nx, grid.nx)));
    ty = new Morph(this, _ty, (int)floor(random(-grid.ny, grid.ny)));
    sx = new Morph(this, _sx, (int)floor(random(1, grid.nx / 2)));
    sy = new Morph(this, _sy, (int)floor(random(1, grid.ny / 2)));
    tri = new Morph(this, _tri, 1);

    if (morphs.size() == 0) { // nothing to do
      dancer.onStateEnd(this);
      return;
    }
    itr = morphs.iterator();
    nextMorph();
  }
}