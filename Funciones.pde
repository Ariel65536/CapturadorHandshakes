StringList AdaptadoresRedEncontrados = new StringList();
String AdaptadorRedSeleccionado = "";

int MillisObjetivo = 0;
int MillisDesautenticar = 0;
boolean AutoActualizarRouters = false;
boolean AutoDesautenticacionClientes = false;
boolean BuscandoAdaptadores = false;

  void actualizarAdaptadores(){
    FuncionesLinux.iwconfig();
    delay(3000);
    cargarAdaptadores();
    BuscandoAdaptadores = false;
  }
  
  void cargarAdaptadores(){
    String[] Lineas = loadStrings("data/iwconfig.log");
    if (Lineas != null){
      if ((Lineas.length > 0)&&(!Lineas[0].equals(""))){
        AdaptadoresRedEncontrados.clear();
        for (int i = 0; i < Lineas.length;i++){
          AdaptadoresRedEncontrados.append(split(Lineas[i], " ")[0]);
        }
      }
    }
    
    TablaAdaptadorRed.actualizarColumna(1, AdaptadoresRedEncontrados.array());
    TablaAdaptadorRed.actualizarColumnaID();
    TablaAdaptadorRed.actualizarPosiciones();      
  }

  void actualizarRedes(String Ruta){
    String[] Lineas;
    Lineas = loadStrings(Ruta);
    String ESSID = "Wifi 0";String BSSID = "00:00:00:00:00:00";String Canal = "0";String Potencia = "0";int UltimaConexion = 0;
    int LineaDeEstaciones = 0; 
    if (Lineas != null){
      if (Lineas.length > 2){
        for (int i = 2 ; i < Lineas.length; i++) {                // Revisar Routers
          if (Lineas[i].equals("")){LineaDeEstaciones = i+2;break;}
          String[] DatosLinea = split(Lineas[i], ", "); 
          if (DatosLinea.length > 13){
            BSSID = DatosLinea[0]; ESSID = DatosLinea[13]; Potencia = DatosLinea[8];UltimaConexion =  Redes.convertirAMinutos(DatosLinea[2]);
            if (split(DatosLinea[3]," ").length > 1){Canal = split(DatosLinea[3]," ")[1];} else {Canal = DatosLinea[3];}
            Redes.actualizarRed(BSSID,ESSID,Canal,Potencia,UltimaConexion);  //actualiza y si no existe, crea.
          }
        }
        for (int i = LineaDeEstaciones ; i < Lineas.length; i++) { // Revisar Clientes
          if (Lineas[i].equals("")){break;}
          String[] DatosLinea = split(Lineas[i], ", ");
          String[] DatosLinea5 = split(DatosLinea[5], ",");
          DatosLinea[5] = DatosLinea5[0];
          Redes.agregarCliente(DatosLinea[0],DatosLinea[3],DatosLinea[4],DatosLinea[5]); //MAC, Potencia, Paquetes, Router
        }
      actualizarTablaRouters();
      if (MenuActual.equals("SeleccionCliente"))actualizarTablaClientes(Redes.RouterSeleccionado);
      }
    }
     
  }
  void actualizarTablaRouters(){
    if (OcultarInactivos.Encendido){Redes.desactivarRedesInactivas();}
    int RoutersMostrar = 0;
    boolean OcultandoInactivos = OcultarInactivos.Encendido;
    if (OcultandoInactivos){
      for (int i = 0 ; i < Redes.RoutersEncontrados; i++) {
        if (!Redes.Router.get(i).Inactivo){
          RoutersMostrar++;
        }
      }
    } else {
      RoutersMostrar = Redes.RoutersEncontrados;
    }
    String[] Nombres = new String[RoutersMostrar];
    int[] Potencias = new int[RoutersMostrar];
    int[] CantidadClientes = new int[RoutersMostrar];
    int[] UltimaConexion = new int[RoutersMostrar];
    String[] BSSIDs = new String[RoutersMostrar];
    int RouterActualizado = 0;
    for (int i = 0 ; i < Redes.RoutersEncontrados; i++) {
      RedInalambrica RouterActual = Redes.Router.get(i);
      if (!OcultandoInactivos || !RouterActual.Inactivo){
        Nombres[RouterActualizado] = RouterActual.leerNombre();
        Potencias[RouterActualizado] = RouterActual.leerPotencia();
        CantidadClientes[RouterActualizado] = RouterActual.leerCantidadClientes();
        UltimaConexion[RouterActualizado] = Redes.convertirAMinutos("ahora") - RouterActual.leerUltimaConexion();
        BSSIDs[RouterActualizado] = RouterActual.leerBSSID();
        RouterActualizado++;
      }
    }
    
    TablaRouters.actualizarColumna(1, Nombres);
    TablaRouters.actualizarColumna(2, CantidadClientes);
    TablaRouters.actualizarColumna(3, Potencias);
    TablaRouters.actualizarColumna(4, UltimaConexion);
    TablaRouters.actualizarColumna(5, BSSIDs);
    TablaRouters.actualizarColumnaID();
    TablaRouters.actualizarPosiciones();       
  }

  void actualizarTablaClientes(RedInalambrica RouterActual){
    int CantidadClientes = RouterActual.leerCantidadClientes();
    String[] MAC = new String[CantidadClientes];
    int[] Paquetes = new int[CantidadClientes];
    int[] Potencias = new int[CantidadClientes];
    for (int i = 0 ; i < CantidadClientes; i++) {
      RedInalambrica.Clientes ClienteActual = RouterActual.Cliente.get(i);
      MAC[i] = ClienteActual.leerMAC();
      Potencias[i] = ClienteActual.leerPotencia();
      Paquetes[i] = ClienteActual.leerPaquetes();
    }
    TablaClientes.actualizarColumna(1, MAC);
    TablaClientes.actualizarColumna(2, Paquetes);
    TablaClientes.actualizarColumna(3, Potencias);
    TablaClientes.actualizarColumnaID();
    TablaClientes.actualizarPosiciones();       
  }
  
  boolean handshakesEncontrados(){
    boolean Respuesta = false;
    FuncionesLinux.aircrack();
    String[] Lineas = loadStrings("aircrack.log");
    if (Lineas != null){
      if (Lineas.length != 0){
        if (!Lineas[0].equals("")){
          String[] Lineas2={""};
          saveStrings("data/aircrack.log", Lineas2);
          Respuesta = true;
        }
      }
    }
    return Respuesta;
  }
  
