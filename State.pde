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