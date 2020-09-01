class Redes{
  ArrayList<RedInalambrica> Router = new ArrayList<RedInalambrica>();
  int RoutersEncontrados = 0;
  StringList CacheBSSIDs = new StringList();
  String[] RedesYaCapturadas={};
  int TiempoInactividad = 5;  //5 minutos
  RedInalambrica RouterSeleccionado;

  Redes(){
   RedesYaCapturadas = loadStrings("data/RedesCapturadas.log"); 
   RouterSeleccionado = new RedInalambrica("00:00:00:00:00:00", "Desconocido", "0","0",false,0);
  } 
  void desactivarRedesInactivas(){
    for (int i = 0 ; i < Redes.RoutersEncontrados; i++) {
      RedInalambrica RouterActual = Redes.Router.get(i);
      if ((Redes.convertirAMinutos("ahora") - RouterActual.leerUltimaConexion()) > TiempoInactividad){
        if (!RouterActual.Inactivo){
          RouterActual.inactividad(true);
        }
      }
    }
  }
  void actualizarEstadoHandshake(String BSSID){
    int NumeroRouter = 0;
    for (int i = 0 ; i < RoutersEncontrados; i++) {
      if (BSSID.equals(CacheBSSIDs.get(i))){NumeroRouter = i;break;}
    }
    RedInalambrica RouterActual = Router.get(NumeroRouter);
    String[] Lineas={};
    String NombreRed = RouterActual.leerNombre();
    Lineas = append(Lineas, "mv ./data/psk-01.cap \"./Handshakes/" + NombreRed + ".cap\"");
    saveStrings("data/GuardarHandshake.sh", Lineas);
    RedesYaCapturadas = append(RedesYaCapturadas, RouterActual.leerBSSID());
    saveStrings("data/RedesCapturadas.log", RedesYaCapturadas);
    RouterActual.colocarCapturado();
    Router.set(NumeroRouter, RouterActual);
    FuncionesLinux.abrirEnLinux("data/GuardarHandshake.sh");
  }
  
  void actualizarRed(String a,String b,String c,String d, int e){
    boolean Existe = false;
    int NumeroRouter = 0;
    for (int i = 0 ; i < RoutersEncontrados; i++) {
      if (a.equals(CacheBSSIDs.get(i))){Existe = true;NumeroRouter = i;break;}
    }
    if (Existe){
      RedInalambrica RouterActual = Router.get(NumeroRouter);
      RouterActual.actualizar(a,b,c,d,e);
      if (RouterActual.leerBSSID().equals(RouterSeleccionado.leerBSSID())){
        RouterSeleccionado.actualizar(a,b,c,d,e);
      }
      if ((Redes.convertirAMinutos("ahora") - RouterActual.leerUltimaConexion()) < TiempoInactividad){
        if (RouterActual.Inactivo){
          RouterActual.inactividad(false);
        }
      }
      Router.set(NumeroRouter, RouterActual);
    } else {
      CacheBSSIDs.append(a);
      boolean HandshakeYaCapturado = false;
      for (int i = 0; i < RedesYaCapturadas.length;i++){
        if (a.equals(RedesYaCapturadas[i])){HandshakeYaCapturado = true;break;}
      }
      Router.add(new RedInalambrica(a,b,c,d,HandshakeYaCapturado, e));
      RoutersEncontrados++;
    }
  }
  
  void agregarCliente(String a, String b, String c, String d){
    for (int i = 0 ; i < RoutersEncontrados; i++) {
      if (d.equals(CacheBSSIDs.get(i))){
        RedInalambrica RouterActual = Router.get(i);
        RouterActual.agregarCliente(a,b,c);
        if (RouterActual.leerBSSID().equals(RouterSeleccionado.leerBSSID())){
          RouterSeleccionado.agregarCliente(a,b,c);
        }
        Router.set(i,RouterActual);
        break;
      }
    }
  }
  
  int convertirAMinutos(String a){
    int Respuesta = 0; 
    if (a.equals("ahora")){
      Respuesta += 518400*(year()-2020) + 43200*month() + 1440*day();
      Respuesta += 60*hour() + minute(); 
    } else {
      String Fecha = split(a, " ")[0];
      String Hora = split(a, " ")[1];
      Respuesta += 518400*(int(split(Fecha, "-")[0])-2020) + 43200*(int(split(Fecha, "-")[1])) + 1440*(int(split(Fecha, "-")[2]));
      Respuesta += 60*(int(split(Hora, ":")[0])) + int(split(Hora, ":")[1]);
    }
    return Respuesta;
  }
}

class RedInalambrica{
  boolean HandshakeYaCapturado = false;
  String ESSID = "Nada";
  String BSSID = "00:00:00:00:00:00";
  int Canal = 0;
  int Potencia = 0;
  int CantidadClientes = 0;
  StringList CacheMACs = new StringList();
  ArrayList<Clientes> Cliente = new ArrayList<Clientes>();
  int UltimaConexionMinutos = 0;
  boolean Inactivo = false;

  RedInalambrica(String a,String b,String c,String d,boolean e,int f){
    BSSID = a; ESSID = b; Canal = int(c); Potencia = int(d); HandshakeYaCapturado = e; UltimaConexionMinutos=f;
    if (ESSID.equals("")){ESSID = "(Oculto)";}
    if (Potencia ==  -1){Potencia = -99;}
    if (Potencia ==  0){Potencia = -99;}
  }
 
  void actualizar(String a,String b,String c,String d,int e){
   BSSID = a; Canal = int(c); Potencia = int(d); UltimaConexionMinutos=e;
   if (b.equals("")&&(ESSID.equals(""))){ESSID = "(Oculto)";}
   if (!b.equals("")&&(ESSID.equals(""))){ESSID = b;}
   if (Potencia ==  -1){Potencia = -99;}
   if (Potencia ==  0){Potencia = -99;}
  }
 
  void inactividad(boolean a){
    Inactivo = a; 
  }
  void colocarCapturado(){
    HandshakeYaCapturado = true;
  }
  int leerUltimaConexion(){
    return UltimaConexionMinutos;  
  }
  boolean leerEstadoHandshake(){
    return HandshakeYaCapturado;
  }
  int leerCapturados(){
    int Respuesta = 0;
    if (HandshakeYaCapturado)Respuesta = 1;
    return Respuesta;
  }

  void agregarCliente(String a, String b, String c){
    boolean Existe = false;
    int NumeroCliente = 0; 
    for (int i = 0 ; i < CantidadClientes; i++) {
      if (a.equals(CacheMACs.get(i))){Existe = true; NumeroCliente = i;}
    }  
    if (Existe){
      Clientes ClienteActual = Cliente.get(NumeroCliente);
      ClienteActual.actualizar(a,b,c);
      Cliente.set(NumeroCliente,ClienteActual);
    } else {
      CantidadClientes++;
      CacheMACs.append(a);
      Cliente.add(new Clientes(a,b,c));
    }
  }
 
  String leerNombre(){return ESSID;}
  String leerBSSID(){return BSSID;}
  int leerPotencia(){return Potencia;}
  int leerCanal(){return Canal;}
  int leerCantidadClientes(){return CantidadClientes;}

  class Clientes{
    String MAC = "00:00:00:00:00:00";
    int Potencia = 0;
    int Paquetes = 0;
    Clientes(String a,String b, String c){
      MAC = a; Potencia = int(b); Paquetes = int(c);
    }
    void actualizar(String a,String b, String c){
      MAC = a; Potencia = int(b); Paquetes = int(c);
    }
    String leerMAC(){return MAC;}
    int leerPaquetes(){return Paquetes;}
    int leerPotencia(){return Potencia;}
  }

}
