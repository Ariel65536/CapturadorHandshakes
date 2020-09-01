/* 
Temporizador TemporizadorImportarDatos;

void setup(){
TemporizadorImportarDatos = new Temporizador();    
}

void draw(){

TemporizadorImportarDatos.esperar(1000)   // Activa el temporizador para que espere 1000ms antes de ser activado
TemporizadorImportarDatos.ejecutar()      // Devuelve true solo una ves, cuando llega a 0, una vez leido el mismo devuelve false hasta volver a ser activado
  
}
*/

Temporizador TemporizadorImportarDatosRouters;
Temporizador TemporizadorRedesInactivas;
Temporizador TemporizadorRevisarHandshake;
Temporizador TemporizadorAutoDesautenticar;
Temporizador TemporizadorHashCatActualizar;

void setupTemporizadores(){
  TemporizadorImportarDatosRouters = new Temporizador();
  TemporizadorRedesInactivas = new Temporizador();
  TemporizadorRevisarHandshake = new Temporizador();
  TemporizadorAutoDesautenticar = new Temporizador();
  TemporizadorHashCatActualizar = new Temporizador();
}

class Temporizador{
  int TiempoLimite = 0;
  boolean Activado = false;
 void esperar(int a){
   Activado = true;
   TiempoLimite = millis() + a;
 }
 boolean ejecutar(){
   boolean Estado = false;
   if (Activado){
     if (TiempoLimite < millis()){
     Estado = true;
     Activado = false;
     }
   }
   return Estado;
 } 
}
