/*
Interruptor Prendido;
 
void setup(){
Prendido = new Interruptor(10,300,30);                        // (posX, posY, tamaño);  color verde por defecto
Prendido = new Interruptor(10,300,30, color(#48A2FF));        // (posX, posY, tamaño, color); 
}

void draw(){
 Prendido.dibujar()                                           // Dibuja y hace funcionar el interruptor
 if (Prendido.cambioDisponible()){ }                          // Devuelve true en caso de haber un cambio sin leer, una vez leido devuelve false hasta que haya otro cambio
 Prendido.Encendido                                           // Devuelve el estado del interruptor (true o false) , se puede asignar directamente un estado:(Prendido.Encendido = true;)
}
void mousePressed(){
 Prendido.informarMouseApretado();                            // Necesario para detectar cuando el interruptor es apretado
}
*/

Interruptor EscanearRouters;
Interruptor Modo5Ghz;
Interruptor OcultarInactivos;
Interruptor AutoDesautenticacion;

void setupInterruptores(){
  EscanearRouters = new Interruptor(180,365,30, #0098FA);
  OcultarInactivos = new Interruptor(180,410,30, #0098FA);
  AutoDesautenticacion = new Interruptor(180,365,30, #0098FA);
  Modo5Ghz = new Interruptor(180,365,30, #0098FA);
}
void mousePressedInterruptores(){
  if (MenuActual.equals("SeleccionRouter")){
  EscanearRouters.informarMouseApretado();
  OcultarInactivos.informarMouseApretado();
  } else if (MenuActual.equals("SeleccionCliente")){
  AutoDesautenticacion.informarMouseApretado();
  } else if (MenuActual.equals("SeleccionAdaptador")){
  Modo5Ghz.informarMouseApretado();
  }
}

class Interruptor{
int Escala = 1;
float posX = 0;float posY = 0;float tam = 30;
color ColorEncendido = color(0,200,0);
color ColorApagado = color(200);
boolean Encendido = false;
float posicionInterruptor = 1;
int PosicionActualInterruptor = 1;
boolean CambioDisponible = true;
PShape FondoForma;
   Interruptor(float a, float b, float c){ 
     posX = a; posY = b; tam = c; posicionInterruptor = tam*0.5;
   }
   Interruptor(float a, float b, float c, color d){ 
     posX = a; posY = b; tam = c; posicionInterruptor = tam*0.5; ColorEncendido = d;
   }
   
   void dibujar(){
     if (Encendido){
       if (PosicionActualInterruptor < 10){ posicionInterruptor = map(sin(PosicionActualInterruptor*PI/20), -1, 1,tam*0.5, tam*1.2) ; PosicionActualInterruptor++;}
     } else {
       if (PosicionActualInterruptor > -10){posicionInterruptor = map(sin(PosicionActualInterruptor*PI/20), -1, 1,tam*0.5, tam*1.2) ; PosicionActualInterruptor--;}
     }  
     fill(ColorApagado);noStroke();
     arc(posX+tam/2,posY,tam,tam,HALF_PI,PI+HALF_PI);
     arc(posX+tam*0.8*1.5,posY,tam,tam,-HALF_PI,HALF_PI);
     rect(posX+tam/2,posY-tam/2,tam*0.8*1.5-tam/2,tam);
     fill(ColorEncendido,map(posicionInterruptor,tam*0.5,tam*1.2,0,255));
     noStroke();
     arc(posX+tam/2,posY,tam,tam,HALF_PI,PI+HALF_PI);
     arc(posX+tam*0.8*1.5,posY,tam,tam,-HALF_PI,HALF_PI);
     rect(posX+tam/2,posY-tam/2,tam*0.8*1.5-tam/2,tam);
     fill(255);
     ellipse(posX+posicionInterruptor,posY,tam*0.8,tam*0.8);
   }
   
   void informarMouseApretado(){
     if (mouseArriba()){Encendido = !Encendido; CambioDisponible = true;}
   }
   
   boolean mouseArriba(){
     boolean Respuesta = false;
     if (((posX)*Escala < mouseX)&&(mouseX < (posX+tam*1.7)*Escala)&&((posY-tam/2)*Escala < mouseY)&&(mouseY < (posY+tam/2)*Escala)){Respuesta = true;}
     return Respuesta;
   }
   
   boolean cambioDisponible(){
     boolean Respuesta = false;
     if (CambioDisponible){
       Respuesta = true;
       CambioDisponible = false;
     }
     return Respuesta;
     
   }
}
