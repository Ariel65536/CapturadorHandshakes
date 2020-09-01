/*
Tabla TablaRouters;

void setup(){
TablaRouters = new Tabla();
TablaRouters.agregarTitulos(new String[]{"Nombre", "Usuarios", "Potencia"}, new int[]{0,1,1}));     // La cantidad de titulos define la cantidad de columnas de la tabla, new int define el tipo de dato de cada columna(0=String, 1=int, 2=float)
TablaRouters.asignarDatosForma(177,157,197, new int[]{112,97,80});                                  // PosicionX, PosicionY, TamañoY, AnchoColumna[i]
}

{
TablaRouters.actualizarColumna(1, new String[]{"Wifi 1", "Wifi 2", "Wifi 3", "Wifi 4"});            // Columna 1, asigna el dato de cada FILA de la columna 1 (columna 0 reservada para el ID)
TablaRouters.actualizarColumna(2, new int[]{4,2,1,0});                                              // Columna 2, asigna el dato de cada FILA de la columna 1 (en el ejemplo corresponde a los usuarios de cada router)
TablaRouters.actualizarColumna(3, new int[]{80,50,30});
TablaRouters.actualizarColumnaID();                                              // Resetea la columna de ID (columna 0)
TablaRouters.actualizarPosiciones();                                             // Aplica la funcion de orden sort() seleccionada a la tabla (al apretar clic sobre el titulo de columna)
TablaRouters.obtenerElementoSeleccionado();                                      // Devuelve elemento de la lista seleccionado, en forma de int          
}

void draw(){
TablaRouters.funcionar();                                                        // Dibuja y funciona la Tabla
}

void mouseWheel(MouseEvent event){
TablaRouters.verificarRuedaMouse(event.getCount());                              // Si el mouse esta sobre la tabla, la lista de la misma se desplaza con la rueda de raton
}

*/

Tabla TablaAdaptadorRed;
Tabla TablaRouters;
Tabla TablaClientes;

void setupTablas(){
  TablaAdaptadorRed = new Tabla();
  TablaAdaptadorRed.agregarTitulos(new String[]{"Nombre de adaptador de red"},new int[]{0});
  TablaAdaptadorRed.asignarDatosForma(17,14,210, new int[]{603});  
  
  TablaRouters = new Tabla();
  TablaRouters.agregarTitulos(new String[]{"Nombre", "Users", "Señal", "M/I",""},new int[]{0,1,1,1,0});
  TablaRouters.asignarDatosForma(17,14,210, new int[]{378,75,75,75,0});  
  
  TablaClientes = new Tabla();
  TablaClientes.agregarTitulos(new String[]{"Cliente MAC", "Paquetes", "Potencia"},new int[]{0,1,1});
  TablaClientes.asignarDatosForma(17,14,210, new int[]{403,101,99});   
}

class Tabla{
  int Escala = 1;
  int Columnas = 0;
  String[] TitulosColumnas = new String[20];
  int[] CantidadFilasDeColumna = new int[20];
  int[] TipoDeColumna = new int[20];
  int[] TamanoColumna = new int[20];
  int[] PosicionColumna = new int[20];
  Table TablaPrincipal; 
  int PosX = 20; int PosY = 20; int TamX = 100; int TamY = 100;
  int AlturaTituloColumna = 30;
  int MouseEncima = 0;
  int ElementoSeleccionado = 0;
  boolean MayorAMenor = false;
  boolean Ordenar = false;
  int ColumnaOrdenadora = 1;
  int ColumnaTituloObservada = 0;
  int DelayClick;
  int PosicionRuedaMouse;
  
  Tabla(){
    TablaPrincipal = new Table();
    for (int i = 0; i < 20;i++){TipoDeColumna[i] = 0;}
  }

  void funcionar(){
    verificarMouse();
    dibujar(); 
  }
    
  void seleccionarElemento(int a){
    ElementoSeleccionado = a;
  }
  
  int obtenerElementoSeleccionado(){
    int Respuesta = 0;
    if (TablaPrincipal.getRowCount() > 0){Respuesta = TablaPrincipal.getInt(constrain(ElementoSeleccionado,0,TablaPrincipal.getRowCount()-1),0);}
    return Respuesta;
  }
  
  int obtenerElementoSeleccionado2(){
    return constrain(ElementoSeleccionado,0, TablaPrincipal.getRowCount()-1);
  }
  String leerCelda(int a, int b){
    String Respuesta = "";
    if ((a >= 0 )&&(a <= TablaPrincipal.getRowCount())){
      Respuesta = TablaPrincipal.getString(a,b);
    }
    return Respuesta;
  }
   
  void agregarTitulos(String[] a, int[] b){
    Columnas = a.length;
    TablaPrincipal.addColumn("0",Table.INT);
    for (int i = 0; i < Columnas;i++){
      if (b[i] == 0){TablaPrincipal.addColumn(str(i+1),Table.STRING);}
      if (b[i] == 1){TablaPrincipal.addColumn(str(i+1),Table.INT);}
      if (b[i] == 2){TablaPrincipal.addColumn(str(i+1),Table.FLOAT);}
      TitulosColumnas[i] = a[i]; 
      TamanoColumna[i] = 15+int(textWidth(a[i]));
    }
    actualizarPosTamColumnas();
  }
   
  void actualizarPosTamColumnas(){
    int ColumnaTamanoAnterior = 0;
    for (int i = 0; i < Columnas;i++){
      PosicionColumna[i] = ColumnaTamanoAnterior;
      ColumnaTamanoAnterior += TamanoColumna[i];
    }
    TamX = ColumnaTamanoAnterior;
  }
  void actualizarColumnaID(){
    for (int i = 0; i < TablaPrincipal.getRowCount();i++){
      TablaPrincipal.setInt(i,0,i);
    }
  }
  int cantidadFilas(){
    return TablaPrincipal.getRowCount() ; 
  }
  void actualizarColumna(int a, String[] b){
    TipoDeColumna[a] = 0;
    while (TablaPrincipal.getRowCount() < b.length){TablaPrincipal.addRow();} 
    while (TablaPrincipal.getRowCount() > b.length){TablaPrincipal.removeRow(0);} 
    for (int i = 0; i < b.length;i++){TablaPrincipal.setString(i,str(a),b[i]);}
  }
  void actualizarColumna(int a, int[] b){
    TipoDeColumna[a] = 1;
    while (TablaPrincipal.getRowCount() < b.length){TablaPrincipal.addRow();} 
    while (TablaPrincipal.getRowCount() > b.length){TablaPrincipal.removeRow(0);} 
    for (int i = 0; i < b.length;i++){TablaPrincipal.setInt(i,str(a),b[i]);}
  }
  void actualizarColumna(int a, float[] b){
    TipoDeColumna[a] = 2;
    while (TablaPrincipal.getRowCount() < b.length){TablaPrincipal.addRow();} 
    while (TablaPrincipal.getRowCount() > b.length){TablaPrincipal.removeRow(0);} 
    for (int i = 0; i < b.length;i++){TablaPrincipal.setFloat(i,str(a),b[i]);}
  }

  void asignarDatosForma(int a,int b,int c, int[] d){
  PosX = a; PosY = b; TamY = c;
  for (int i = 0; i < d.length;i++){
    TamanoColumna[i] = d[i];
  }
    actualizarPosTamColumnas();
  }
 
  void actualizarPosiciones(){
    if (Ordenar){
      TablaPrincipal.sort(ColumnaOrdenadora);
      if (MayorAMenor){
        Table TablaInvertida = new Table();
        for (int i = 0; i < TablaPrincipal.getRowCount();i++){
          for (int j = 0; j < Columnas+1;j++){
            TablaInvertida.addColumn();
            if (j == 0){
              TablaInvertida.setInt(i,j,TablaPrincipal.getInt(i,j));
            } else if (TipoDeColumna[j] == 0){
              TablaInvertida.setString(i,j,TablaPrincipal.getString(i,j));
            } else if (TipoDeColumna[j] == 1){
              TablaInvertida.setInt(i,j,TablaPrincipal.getInt(i,j));
            } else if (TipoDeColumna[j] == 2){
              TablaInvertida.setFloat(i,j,TablaPrincipal.getFloat(i,j));
            }
          }
        }
  
        for (int i = 0; i < TablaPrincipal.getRowCount();i++){
          for (int j = 0; j < TablaPrincipal.getColumnCount();j++){
            if (j == 0){
              TablaPrincipal.setInt(i,str(j),TablaInvertida.getInt(TablaPrincipal.getRowCount()-i-1,j));
            } else {
              if (TipoDeColumna[j] == 0){
                TablaPrincipal.setString(i,str(j),TablaInvertida.getString(TablaPrincipal.getRowCount()-i-1,j));
              } else if (TipoDeColumna[j] == 1){
                TablaPrincipal.setInt(i,str(j),TablaInvertida.getInt(TablaPrincipal.getRowCount()-i-1,j));
              } else if (TipoDeColumna[j] == 2){
              TablaPrincipal.setFloat(i,str(j),TablaInvertida.getFloat(TablaPrincipal.getRowCount()-i-1,j));
              }
            }
          }
        }
      }
    }
  }
  void verificarRuedaMouse(int a){
    if ((PosX < mouseX)&&(mouseX < PosX+TamX)&&(PosY < mouseY)&&(mouseY < PosY+TamY)){
      PosicionRuedaMouse += a;
      PosicionRuedaMouse = constrain(PosicionRuedaMouse,0,constrain(TablaPrincipal.getRowCount()+1 - TamY/AlturaTituloColumna,0,500));
    }  
  }
  void verificarMouse(){
    ColumnaTituloObservada = -1;
    if ((PosY*Escala < mouseY)&&(mouseY < Escala*(PosY+AlturaTituloColumna))){
      for (int i = 0; i < Columnas;i++){
        if (((PosX+PosicionColumna[i])*Escala < mouseX)&&(mouseX < (PosX+PosicionColumna[i]+TamanoColumna[i])*Escala)){
          ColumnaTituloObservada = i; 
          if (DelayClick < millis()){
            if (mousePressed){
              if (ColumnaOrdenadora == i+1){MayorAMenor = !MayorAMenor;}
              DelayClick = millis()+150;
              ColumnaOrdenadora = i+1;
              Ordenar = true;
              actualizarPosiciones();
            }
          }
        }
      }
    }  
    for (int i = 1; i < TablaPrincipal.getRowCount()+1;i++){
      if ((PosX*Escala < mouseX)&&(mouseX < (PosX+TamX)*Escala)&&((PosY+i*AlturaTituloColumna)*Escala < mouseY)&&(mouseY < (PosY+(i+1)*AlturaTituloColumna)*Escala)&&(mouseY < (PosY+TamY)*Escala)){
        MouseEncima = i-1;
        if (mousePressed){ElementoSeleccionado = MouseEncima+PosicionRuedaMouse;}
      }
    }   
  }
 
  void dibujar(){
    fill(#D8EEFF);
    stroke(0);rect(PosX-1,PosY-1,TamX+2,TamY+2);stroke(255);
    for (int i = 0; i < Columnas;i++){
      if (!TitulosColumnas[i].equals("")){
        line(PosX+PosicionColumna[i],PosY,PosX+PosicionColumna[i],PosY+TamY);
        for (int j = 0; (j < (TamY/AlturaTituloColumna))&&(j < TablaPrincipal.getRowCount()+1);j++){
          if (j == 0){
            fill(#94CEFC);
            if(ColumnaTituloObservada == i){fill(#4DA6ED);}
          } else {
            if (ElementoSeleccionado == j-1+PosicionRuedaMouse){
              fill(#B2DCFC);
            } else {
              fill(#D8EEFF);
            }
          }
          rect(PosX+PosicionColumna[i],PosY+j*AlturaTituloColumna,TamanoColumna[i],AlturaTituloColumna);
          
          if (j == 0){
            fill(#0E3FCB);
            text(TitulosColumnas[i],PosX+PosicionColumna[i]+5,PosY+(AlturaTituloColumna/1.5));
          } else {
            try {
              fill(30);
              text(TablaPrincipal.getString(j-1+PosicionRuedaMouse,i+1),PosX+PosicionColumna[i]+5,PosY+AlturaTituloColumna/1.5+j*AlturaTituloColumna);}
            catch(NullPointerException e) {
              System.out.println("NullPointerException - Problema en fila " + (j-1+PosicionRuedaMouse) + "/" + TablaPrincipal.getRowCount() + " de la columna " + (i+1));
              break;
            }
            catch(ArrayIndexOutOfBoundsException exception) {
              System.out.println("ArrayIndexOutOfBoundsException - Problema en fila " + (j-1+PosicionRuedaMouse) + "/" + TablaPrincipal.getRowCount() + " de la columna " + (i+1));
              break;
            }
          }
        }
      }
    }
  }

  int[] numeroArrayOrdenadoMayorAMenor(float[] ArrayFlotante){
    float Minimo = min(ArrayFlotante);
    int[] Respuesta = new int[ArrayFlotante.length];
    int MayorEncontrado = 0;
    for (int j = 0; j < ArrayFlotante.length;j++){
      MayorEncontrado =  mayorDelArray(ArrayFlotante);
      Respuesta[j] = MayorEncontrado;
      ArrayFlotante[MayorEncontrado] = Minimo;
    }
    return Respuesta;
  }
  int mayorDelArray(float[] ArrayFlotante){
    int Respuesta = 0;
    float ValorAnterior = ArrayFlotante[0];
    for (int j = 0; j < ArrayFlotante.length;j++){
      if (ValorAnterior < ArrayFlotante[j]){Respuesta = j;ValorAnterior=ArrayFlotante[j];}
    }
    return Respuesta;
  }  
}
