class Lineas {
  PVector lugar;
  PVector lugar_b;
  PVector velocidad;
  PVector aceleracion;


  float max_velocidad;



  Lineas(int x_pos, int y_pos) {
    float x = x_pos;
    float y = y_pos;

    lugar = new PVector (x, y);
    lugar_b = new PVector(x+random(-50, 50), y+random(-20, 20));
    velocidad = new PVector (0, 0);
    max_velocidad = 10;
  }

  void actualizar() {
    PVector objetivo = new PVector(mouseX, mouseY);
    PVector aceleracion = PVector.sub(objetivo, lugar);

    aceleracion.setMag(0.1);

    velocidad.add(aceleracion);

    velocidad.limit(max_velocidad);

    lugar.add(velocidad);
    lugar_b.add(velocidad);
  }

  void mostrar() {
    
    stroke(255,30);
    strokeWeight(3);
    line(lugar.x, lugar.y, lugar_b.x, lugar_b.y);
  }

}