/*
INSTRUCCIONES DE CONTROL.

Teclas:
  1 = Activa el momento uno.
    Dentro del momento uno (lineas laterales, rayerio y lineas gravitacionales):
    Teclas:
      A = Muestra o esconde las lineas laterales-
      V = Muestra o esconde las lineas que giran en torno al mouse-
      click = Muestra el rayerio-
   2 = Activa el momento dos (cuerda)
     Teclas:
       click = Agrega duplicados de la cuerda-
       X = Hace vibrar la cuerda a la izquierda-
       C = Hace vibrar la cuerda a la derecha-
       M = Elimina una cuerda al azar, excepto la del medio-
   3 = Activa el momento tres (bichos)
     Teclas:
       F = Cambian el tipo de movimiento, de caotico a moverse en manada-
       P = Activa o desactiva el depredador (se alejan o no del mouse)-
       A = Se aleja la camara en Z-
 */
int x, y;
boolean auto;
int choise;
int probabilidad = 30;
//Rayas
PVector puntos;
PVector mouse;
//Rayas gravedad
Lineas linea;
ArrayList<Lineas> a_lineas;
boolean visible;
//Cuerda
float vibracion = 0;
float inicial_pos;
Cuerda cuerda;
ArrayList<Cuerda> a_cuerda;
boolean see_cuerda = false;
// Bichos
ArrayList<Boid> boids = new ArrayList<Boid>(); //To store all boids in.
ArrayList<Predator> preds = new ArrayList<Predator>(); //To store all predators in.
int boidNum = 600; //Initial number of boids created.
int predNum = 1; //Initial number of predators created.
PVector mouse_f; //Mouse-vector to use as obstacle.
float obstRad = 250; //Radius of mouse-obstacle.
int boolT = 0; //Keeps track of time to improve user-input.
boolean flocking = false; //Toggle flocking.
boolean arrow = true; //Toggle arrows.
boolean circle = false; //Toggle circles.
boolean predBool = true; //Toggle predators.
boolean obsBool = false; //Toggle obstacles. 
int z = 0;

/*//====TSPS=====
 import tsps.*;
 TSPS tspsReceiver;
 float posX;
 float posY;
 //=============
 */
int momento = 1;


import spout.*;
Spout spout;


void setup() {
  size(1024, 768, P3D);
  spout = new Spout(this);

  //====TSPS=====
  // tspsReceiver= new TSPS(this, 12000);
  //=============

  inicial_pos = width/2; //Calibrar este valor para ajustar a la posicion de la cuerda
  a_cuerda = new ArrayList<Cuerda>();
  a_cuerda.add(new Cuerda(inicial_pos));

  a_lineas = new ArrayList<Lineas>();

  for (int i = 0; i < 100; i++) {
    a_lineas.add(new Lineas(int(random(width)), int(random(height))));
  }

  for (int i=0; i<boidNum; i++) { //Make boidNum boids.
    boids.add(new Boid(new PVector(random(0, width), random(0, height))));
  }
  for (int j=0; j<predNum; j++) { //Make predNum predators.
    preds.add(new Predator(new PVector(random(0, width), random(0, height)), 50));
  }
}

void draw() {

  translate(0, 0, z);

  switch(momento) {

  case 1:

    fill(0, 20);
    rect(0, 0, width, height);

    for (Lineas linea : a_lineas) {
      if (visible) {
        linea.actualizar();
        linea.mostrar();
      }
    }
    strokeWeight(1);
    if (mousePressed) {
      figuras();
    }
    if ((choise == 1) && (auto)) {
      lugar();
      for (int i = 0; i < 20; i++) {
        if ((x < width)&&(y < height)) {
          stroke(255);
          line(x, y, x+ random(-60, 60), y + random(-60, 60));
          x = x - int(random(50));
          y = y - int(random(50));
          x--;
          y--;
        }
      }
    }
    break;

  case 2:

    fill(0, 20);
    rect(0, 0, width, height);
    //Si la cuerda esta activa, se desactiva el resto de los dibujos
    see_cuerda = true;
    for (Cuerda cuerda : a_cuerda) {
      cuerda.dibujar(vibracion);
    }

    if (keyPressed) {
      if (key == 'x' || key == 'X') { //Aumenta la vibracion de la cuerda
        vibracion --;
      }
      if (key == 'c' || key == 'C') { //Reduce la vibracion de la cuerda
        vibracion ++;
      }
    } else {
      if (vibracion < 0) {
        vibracion ++;
      }
      if (vibracion > 0) {
        vibracion --;
      }
    }
    break;

  case 3:

    stroke(255);
    fill(0, 20);
    rect(0, 0, width, height);
    /*  TSPSPerson[] people = tspsReceiver.getPeopleArray();
     //Dibuja el punto central del blob
     for (int i=0; i<people.length; i++) {
     strokeWeight(1);
     stroke(255);
     posX = people[i].centroid.x*width;
     posY = people[i].centroid.y*height;
     ellipse(people[i].centroid.x*width, people[i].centroid.y*height, 10, 10);
     }*/
    for (Boid boid : boids) { //Cycle through all the boids and to the following for each:

      if (predBool) { //Flee from each predator.
        for (Predator pred : preds) { 
          PVector predBoid = pred.getLoc();
          boid.repelForce(predBoid, obstRad);
        }
      }
      if (obsBool) { //Flee from mouse.
        mouse_f = new PVector(mouseX, mouseY);
        //mouse_f = new PVector(posX, posY);
        boid.repelForce(mouse_f, obstRad);
      }
      if (flocking) { //Execute flocking rules.
        boid.flockForce(boids);
      }

      boid.display(circle, arrow); //Draw to screen.
    }
    for (Predator pred : preds) {
      //Predators use the same flocking behaviour as boids, but they use it to chase rather than flock.
      if (flocking) { 
        pred.flockForce(boids);
        for (Predator otherpred : preds) { //Predators should not run into other predators.
          if (otherpred.getLoc() != pred.getLoc()) {
            pred.repelForce(otherpred.getLoc(), 30.0);
          }
        }
      }
      pred.display();
    }

    if (keyPressed) {
      if ((key=='a')||(key == 'A')) { 
        if ((z <= 0)&&(z> -5000)) {
          z = z -50;
        }
      }
    } else {
      if (z < 0) {
        z = z +25;
      }
    }
    break;
  }

  choise = int(random(probabilidad));
  println(choise + " " + auto + " " + probabilidad);
  spout.sendTexture();
}



void keyPressed() {
  if (key == 'a' || key == 'A') { //Muestra las lineas laterales
    auto = !auto;
  }
  if (key == 'p' || key == 'P') { //Dibuja mas lineas laterales
    if (probabilidad > 2) {
      probabilidad--;
    }
  }
  if (key == 'v' || key == 'V') { //Muestra las lineas gravitacionales
    visible = !visible;
  }

  if (key == 'c' || key == 'C') { //Agrega lineas gravitacionales
    for (int i = 0; i < 20; i++) {
      a_lineas.add(new Lineas(int(random(width)), int(random(height))));
    }
  }
  if (key == 'l' || key == 'L') { //Activa la cuerda, desactiva el resto
    see_cuerda = !see_cuerda;
  }
  if (key == 'm' || key == 'M') { //Remueve un elemento cuerda
    if (a_cuerda.size() != 1) {
      a_cuerda.remove(int(random(1, a_cuerda.size())));
    }
  }
  if (keyPressed && key=='p' && boolT<40) { //Enciende o apaga el deprededador
    predBool = !predBool;
    println("pradator:", predBool);
    boolT = 0;
  }
  if (keyPressed && key=='o' && boolT<40) {//Enciende o apaga los obstaculos
    obsBool = !obsBool;
    println("obstacle:", obsBool);
    boolT = 0;
  }
  if (keyPressed && key=='f' && boolT<40) {//Enciende o apaga el flocking
    flocking = !flocking;
    println("Flocking:", flocking);
    boolT = 0;
  }
  if (key == '1') { //Momento 1
    momento = 1;
  }
  if (key == '2') { //Momento 2
    momento = 2;
  }
  if (key == '3') { //Momento 3
    momento = 3;
  }
}

void mousePressed() {
  if (see_cuerda) {
    a_cuerda.add(new Cuerda(random(width)));
  }
}

void lugar() {
  x = int(random(width));
  y = int(random(height));
}

void figuras() {
  fill(0, 20);
  rect(0, 0, width, height);
  beginShape();
  for (int i = 0; i<200; i++) {
    int x = int( random(width));
    int y = int( random(height));

    puntos = new PVector (x, y);
    mouse = new PVector(mouseX, mouseY);

    float dist = puntos.dist(mouse);

    if (dist > 300) {
      stroke(255);
      vertex(puntos.x, puntos.y);
      fill(255);
    }
  }
  noFill();
  endShape();
}