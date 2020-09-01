/*
Deslizador Velocidad;
void setup(){
  Velocidad = new Deslizador(50,300,200,50,150);          // (PosicionX, PosicionY, Longitud, ValorMinimo, ValorMaximo)
  Velocidad = new Deslizador(50,300,200,50,150,#38DE24);  // (PosicionX, PosicionY, Longitud, ValorMinimo, ValorMaximo, Color)
  Velocidad.posicionRegreso(50);                          // Al soltar el deslizador, el mismo regresa a la posicion indicada
  
  Velocidad.Vertical = false;                             // Asigna si el Deslizador tendra una orientacion Vertical o Horizontal
}
void draw(){
  Velocidad.dibujar();      // Dibuja y hace funcionar el deslizador
  Velocidad.ValorActual     // Devuelve el valor actual del deslizador
}

void mousePressed(){
  Velocidad.informarMouseApretado();  //Necesario para detectar cuando el deslizador es cliqueado
}

*/

Deslizador DelayDesautenticar;

void setupDeslizadores(){
  DelayDesautenticar = new Deslizador(30,408,194,1,60); 
}
void mousePressedDeslizadores(){
  DelayDesautenticar.informarMouseApretado();
}

class Deslizador{
  int Escala = 1;
  int PosX = 40; int PosY = 100; 
  int Tamano = 200;
  float ValorMinimo = 0; float ValorMaximo = 100; float ValorActual = 20;
  boolean Vertical = false;
  boolean CambiandoValor = false;
  color ColorPosicion = #0098FA;
  boolean PosicionRegreso = false;
  float ValorRegreso = 0;
  
  Deslizador(int a, int b, int c, float d, float e){PosX = a; PosY = b; Tamano = c; ValorMinimo = d; ValorMaximo = e; ValorActual = ValorMinimo;}
  Deslizador(int a, int b, int c, float d, float e, color f){PosX = a; PosY = b; Tamano = c; ValorMinimo = d; ValorMaximo = e; ColorPosicion = f;}
  void posicionRegreso(float a){
    PosicionRegreso = true;
    ValorRegreso = a;
  }
  void dibujar(){
    actualizarPosicion();
    noStroke();fill(220);
    if (Vertical){
    rect(PosX,PosY,4,-Tamano,2);
    fill(ColorPosicion);
    rect(PosX,PosY,4,map(ValorActual,ValorMinimo,ValorMaximo,0,-Tamano),2);
    ellipse(PosX+2,map(ValorActual,ValorMinimo,ValorMaximo,PosY,PosY-Tamano),14,14);  
    } else {
    rect(PosX,PosY,Tamano,4,2);
    fill(ColorPosicion);
    rect(PosX,PosY,map(ValorActual,ValorMinimo,ValorMaximo,0,Tamano),4,2);
    ellipse(map(ValorActual,ValorMinimo,ValorMaximo,PosX,PosX+Tamano),PosY+2,14,14);
    }
  }
  
  void informarMouseApretado(){
    if (mouseArriba()){CambiandoValor = true;}
  }
  
  void actualizarPosicion(){
    if (CambiandoValor){
      if (Vertical){
        ValorActual = constrain(map(mouseY,PosY,PosY-Tamano,ValorMinimo,ValorMaximo),ValorMinimo,ValorMaximo);
      } else {
        ValorActual = constrain(map(mouseX,PosX,PosX+Tamano,ValorMinimo,ValorMaximo),ValorMinimo,ValorMaximo);
      }
      if (!mousePressed){
        CambiandoValor = false;
        if (PosicionRegreso){ValorActual = ValorRegreso;}
      }
    }
  }
  
  boolean mouseArriba(){
    boolean Respuesta = false;
    if (Vertical){
      if ((PosY*Escala > mouseY)&&(mouseY > (PosY-Tamano)*Escala)&&((PosX-10)*Escala < mouseX)&&(mouseX < (PosX+14)*Escala)){Respuesta = true;}
    } else {
      if ((PosX*Escala < mouseX)&&(mouseX < (PosX+Tamano)*Escala)&&((PosY-10)*Escala < mouseY)&&(mouseY < (PosY+14)*Escala)){Respuesta = true;}
    }
    return Respuesta;
  }
  
}
