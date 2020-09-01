Redes Redes;
FuncionesLinux FuncionesLinux;
String MenuActual = "SeleccionAdaptador";

void setup(){
 size(640,480);textSize(16);frameRate(60);
 Redes = new Redes();
 FuncionesLinux = new FuncionesLinux();
 setupTablas();
 setupDeslizadores();
 setupBotones();
 setupInterruptores();
 setupTemporizadores();
 cargarAdaptadores();
}

void draw(){
background(0,200,250);
if (MenuActual.equals("SeleccionAdaptador"))dibujarSeleccionAdaptador();
if (MenuActual.equals("SeleccionRouter"))dibujarSeleccionRouter();
if (MenuActual.equals("SeleccionCliente"))dibujarSeleccionCliente();
}


void mousePressed(){
mousePressedBotones();
mousePressedInterruptores();
mousePressedDeslizadores();
//println(mouseX + " " + mouseY);
}

void mouseWheel(MouseEvent event){
TablaAdaptadorRed.verificarRuedaMouse(event.getCount());
TablaRouters.verificarRuedaMouse(event.getCount());
TablaClientes.verificarRuedaMouse(event.getCount());
}
