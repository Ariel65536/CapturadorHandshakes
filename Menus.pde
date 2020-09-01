void dibujarSeleccionAdaptador(){
TablaAdaptadorRed.funcionar();
noFill();rect(17,240,604,100);fill(255);

if (!BuscandoAdaptadores){
  if (TablaAdaptadorRed.cantidadFilas() > 0){
    text("Seleccione un adaptador de red para continuar.", 25,260);
  } else {
    text("No se han encontrado adaptadores de red.", 25,260);
  }
} else {
  text("Buscando adaptadores...", 25,260);
}

noFill();stroke(255);rect(17,345,220,40);fill(255);
text("Buscar redes 5GHz", 22,370);
Modo5Ghz.dibujar();

  if(SeleccionarAdaptador.apretado()){
    if (TablaAdaptadorRed.cantidadFilas() > 0){
      AdaptadorRedSeleccionado = AdaptadoresRedEncontrados.get(TablaAdaptadorRed.obtenerElementoSeleccionado());
      MenuActual = "SeleccionRouter";
    }
  }

  if(ActualizarAdaptadores.apretado() && !BuscandoAdaptadores){thread("actualizarAdaptadores");BuscandoAdaptadores = true;}
}


void dibujarSeleccionRouter(){
  TablaRouters.funcionar(); 
  if ((Redes.Router.size() > 0) && (Redes.CacheBSSIDs.size() > 0)){
    String BSSIDseleccionado = TablaRouters.leerCelda(TablaRouters.obtenerElementoSeleccionado2(),5);
    if (BSSIDseleccionado != null){
      for (int i = 0; i < Redes.CacheBSSIDs.size();i++){
        if (BSSIDseleccionado.equals(Redes.CacheBSSIDs.get(i))){
          Redes.RouterSeleccionado = Redes.Router.get(i);
          break;
        }
      }
    }
  }
  if (Redes.RouterSeleccionado.leerEstadoHandshake()){fill(0,190,0);} else {noFill();}
  rect(17,240,604,100);fill(255);
  text("Redes encontradas: " + Redes.RoutersEncontrados, 420,260);
  text("Redes seleccionada: " + Redes.RouterSeleccionado.leerNombre(), 25,260);
  if (Redes.RouterSeleccionado.leerEstadoHandshake()){text("Handshake ya capturado", 25,280);} else {text("Handshake sin capturar", 25,280);}

  noFill();stroke(255);rect(17,345,220,40);fill(255);
  text("Escanear redes", 22,370);
  EscanearRouters.dibujar();

  noFill();stroke(255);rect(17,390,220,40);fill(255);
  text("Ocultar Inactivos", 22,415);
  OcultarInactivos.dibujar();

  if(EscanearRouters.cambioDisponible()){
    if (EscanearRouters.Encendido){
      TemporizadorImportarDatosRouters.esperar(500);
      FuncionesLinux.airoDump(AdaptadorRedSeleccionado);
    } else {
      FuncionesLinux.cerrarAiroDump();
    }
  }

  if (EscanearRouters.Encendido){
    if (TemporizadorImportarDatosRouters.ejecutar()){
      actualizarRedes("data/DatosAiroDump-01.csv");
      TemporizadorImportarDatosRouters.esperar(1000);
    }
  }

  if (SeleccionarRouter.apretado()){
    MenuActual = "SeleccionCliente";
    TemporizadorRevisarHandshake.esperar(50);
    EscanearRouters.Encendido = false;
    if (!Redes.RouterSeleccionado.leerEstadoHandshake()){
    FuncionesLinux.airoDump(AdaptadorRedSeleccionado, Redes.RouterSeleccionado.leerCanal(), Redes.RouterSeleccionado.leerBSSID());
    } else {
    FuncionesLinux.cerrarAiroDump();
    }
  }

  if (VolverAdaptadores.apretado()){
    MenuActual = "SeleccionAdaptador";
    if (EscanearRouters.Encendido){
      FuncionesLinux.cerrarAiroDump();
      EscanearRouters.Encendido = false;
    }
  }

  if (OcultarInactivos.cambioDisponible() && OcultarInactivos.Encendido){TemporizadorRedesInactivas.esperar(100);}
  
  if (OcultarInactivos.Encendido){
    if (TemporizadorRedesInactivas.ejecutar()){
      Redes.desactivarRedesInactivas();
      TemporizadorRedesInactivas.esperar(5000);
    }
  }

  if(ResetearRouters.apretado()){
    Redes.Router.clear();
    Redes.RoutersEncontrados = 0;
    Redes.CacheBSSIDs.clear(); 
    TablaRouters.ElementoSeleccionado = 0;
    actualizarTablaRouters();
  }

}


void dibujarSeleccionCliente(){
  TablaClientes.funcionar(); 
  if (!Redes.RouterSeleccionado.leerEstadoHandshake()){
    noFill();rect(17,240,604,100);fill(255);
    text("Red Seleccionada: " + Redes.RouterSeleccionado.leerNombre(), 25,260);
    text("Esperando handshake...", 25,280);
    text("Desautenticacion automatica cada: " + int(DelayDesautenticar.ValorActual) + " minutos", 25,300);
  
    noFill();stroke(255);rect(17,345,220,40);fill(255);
    text("Auto Desauth", 22,370);
    AutoDesautenticacion.dibujar();
  
    noFill();stroke(255);rect(17,390,220,40);fill(255);
    DelayDesautenticar.dibujar();
  } else {
    fill(0,190,0);rect(17,240,604,100);fill(255);
    text("Handshake Capturado y Guardado", 25,260);
  } 

  if(VolverRouters.apretado()){
    MenuActual = "SeleccionRouter";
    FuncionesLinux.cerrarAiroDump();
    AutoDesautenticacion.Encendido = false;
  }

  if (AutoDesautenticacion.cambioDisponible()){
    if(AutoDesautenticacion.Encendido){
      TemporizadorAutoDesautenticar.esperar(100);
    }
  }

  if ((TemporizadorRevisarHandshake.ejecutar())&&(!Redes.RouterSeleccionado.leerEstadoHandshake())){
    if (AutoDesautenticacion.Encendido){
      if (TemporizadorAutoDesautenticar.ejecutar()){
        if (Redes.RouterSeleccionado.leerCantidadClientes() > 0){
          String[] ClientesDesautenticar = new String[Redes.RouterSeleccionado.leerCantidadClientes()];
          for (int i = 0 ; i < ClientesDesautenticar.length; i++) {
            RedInalambrica.Clientes ClienteActual = Redes.RouterSeleccionado.Cliente.get(i);
            ClientesDesautenticar[i] = ClienteActual.leerMAC();
          }
          FuncionesLinux.aireplay(Redes.RouterSeleccionado.leerBSSID(),ClientesDesautenticar,AdaptadorRedSeleccionado);
          TemporizadorAutoDesautenticar.esperar(int(DelayDesautenticar.ValorActual)*60000);
        }
      }
    }
    actualizarRedes("data/psk-01.csv");
    TemporizadorRevisarHandshake.esperar(1000);
    if (handshakesEncontrados()){
      FuncionesLinux.cerrarAiroDump();
      Redes.actualizarEstadoHandshake(Redes.RouterSeleccionado.leerBSSID());
    } 
  }
  if (!Redes.RouterSeleccionado.leerEstadoHandshake()){
    if(DesautenticarUsuario.apretado()){
      if (Redes.RouterSeleccionado.leerCantidadClientes() > 0){
        RedInalambrica.Clientes ClienteActual = Redes.RouterSeleccionado.Cliente.get(TablaClientes.obtenerElementoSeleccionado());
        FuncionesLinux.aireplay(Redes.RouterSeleccionado.leerBSSID(),ClienteActual.leerMAC(),AdaptadorRedSeleccionado);
      }
    }
  }
}
