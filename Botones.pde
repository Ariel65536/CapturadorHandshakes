/*
Boton Cambiar;
 
void setup(){
Cambiar = new Boton(10,180,80,40,"Cambiar");                         // (posX, posY, tamX,tamY, textointerno);          color por defecto: verde
Cambiar = new Boton(10,180,80,40,"Cambiar", color(200,200,200));     // (posX, posY, tamX,tamY, textointerno, color);
Cambiar = new Boton(10,180,80,40,"Cambiar", color(200), color(20));  // (posX, posY, tamX,tamY, color, colortexto); 
}

void draw(){
 Cambiar.Apretado()                                          // Devuelve true si el boton fue apretado, en caso de que haya sido presionado 2 veces, devuelve true durante 2 frames
}
void mousePressed(){
 Cambiar.informarMouseApretado();                            // Necesario para detectar cuando el boton es apretado
}
*/
Boton ActualizarAdaptadores;
Boton SeleccionarAdaptador;

Boton SeleccionarRouter;

Boton ResetearRouters;
Boton VolverAdaptadores;

Boton VolverRouters;
Boton DesautenticarUsuario;

void setupBotones(){
  ActualizarAdaptadores = new Boton(242,345,244,40,"Volver a buscar", #0098FA);
  SeleccionarAdaptador = new Boton(500,345,122,40,"Seleccionar", #0098FA);

  SeleccionarRouter = new Boton(242,345,126,40,"Seleccionar", #0098FA);
  ResetearRouters = new Boton(373,345,122,40,"Resetear", #0098FA);
  VolverAdaptadores = new Boton(500,345,122,40,"Volver", #0098FA);
  
  VolverRouters = new Boton(500,345,122,40,"Volver", #0098FA);
  DesautenticarUsuario = new Boton(242,345,122,40,"Desautenticar", #0098FA);
   
}

void mousePressedBotones(){
  if (MenuActual.equals("SeleccionAdaptador")){
    ActualizarAdaptadores.informarMouseApretado();  
    SeleccionarAdaptador.informarMouseApretado(); 
  } else if (MenuActual.equals("SeleccionRouter")){
    SeleccionarRouter.informarMouseApretado();   
    VolverAdaptadores.informarMouseApretado(); 
    ResetearRouters.informarMouseApretado(); 
  } else if (MenuActual.equals("SeleccionCliente")){
    VolverRouters.informarMouseApretado(); 
    DesautenticarUsuario.informarMouseApretado(); 
  }
}

class Boton{
int Escala = 1;
int posX = 0;int posY = 0;int tamX = 80; int tamY = 30;
String Nombre = "";
int BufferVecesApretado = 0;
boolean Apretado = false;
color Fondo = #2CB433;
color ColorTexto = color(255);

 Boton(int a, int b, int c, int d, String e){ posX = a; posY = b; tamX = c; tamY = d;Nombre = e;}
 Boton(int a, int b, int c, int d, String e, color f){posX = a; posY = b; tamX = c; tamY = d;Nombre = e; Fondo = f;}
 Boton(int a, int b, int c, int d, String e, color f, color g){posX = a; posY = b; tamX = c; tamY = d;Nombre = e; Fondo = f;ColorTexto = g;}
 

 boolean apretado(){
  noStroke();
  if (mouseArriba()){
  fill(Fondo,210);
  if (mousePressed)fill(Fondo,255);stroke(Fondo);
  } else {fill(Fondo,190);}
  if (BufferVecesApretado > 0)fill(Fondo,255);stroke(Fondo);
  rect(posX,posY,tamX,tamY,6);fill(ColorTexto);
  text(Nombre,posX+(tamX-textWidth(Nombre))/2,posY+tamY/2+textAscent()/3);
  stroke(0);fill(0);
  boolean Respuesta = false;
  if (BufferVecesApretado > 0){Respuesta = true;BufferVecesApretado--;}
  return Respuesta;
 }

 void informarMouseApretado(){
  if (mouseArriba()){BufferVecesApretado++;}
 }
 boolean mouseArriba(){
   boolean Respuesta = false;
   if ((posX*Escala < mouseX)&&(mouseX < (posX+tamX)*Escala)&&(posY*Escala < mouseY)&&(mouseY < (posY+tamY)*Escala)){Respuesta = true;}
   return Respuesta;
 }
 
 
}
