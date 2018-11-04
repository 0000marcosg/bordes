class Cuerda {
float x;
float v;

  Cuerda(float xpos) {

     x = xpos;
  }

  void dibujar(float vib) {
    v = vib;;
    stroke(255);
    noFill();
    strokeWeight(2);

    beginShape();
    for (int i = 0; i< height; i = i + 10) {
      vertex(x + random(v), i);
    }
    endShape();
  }
}