# WeatherApp
Aplicación que muestra el clima de tus ciudades favoritas!

## Contenido
  [Instalación y ejecución](#instalación-y-ejecución)<br>
  [Manual de uso](#manual-de-uso)
## Instalación y ejecución
Abre una terminal de sistema y escribe los siguientes comandos:

```
% git clone https://github.com/hlbr/WeatherApp.git
% cd WeatherApp
% pod install
% open WeatherAppHLBR.xcworkspace
```

Crea un esquema para ejecutar el simulador.
Elige un dispositivo iOS de tu agrado.
Utiliza `Command + R` para ejecutar la aplicación.

## Manual de uso
### 1. Acceso a ubicación
Al iniciar la aplicación, le será requerido al usuario acceso a los servicios de ubicación. **La aplicación requiere acceso a los servicios de ubicación y conexión a internet para funcionar correctamente.**

<img src="https://scontent.fpbc1-1.fna.fbcdn.net/v/t1.15752-9/99344089_587170771923500_4903480135103021056_n.jpg?_nc_cat=102&_nc_sid=b96e70&_nc_eui2=AeHIcDwgpISYCLdzNIiVQo-yKFjcmZOyDrUoWNyZk7IOtfxgphPKEXSgS2Td3bc_X6o&_nc_oc=AQnDJRvvsDUtC068PgvyA-D41ZBiq7i0eIbm_-2ud3I7VCO2dRhhBDaR2c6kxXeeI26EChX20EMLMDIf2XYBDgp_&_nc_ht=scontent.fpbc1-1.fna&oh=66d91b23fffb5c88f70db67e11171bcb&oe=5EF1EB1F" width="250"/>

### 2. Acceso a la ubicación denegado
Sin acceso a la ubicación, la pantalla principal sólo mostrará la advertencia al usuario. El usuario debe modificar el acceso a la ubicación desde los ajustes del sistema en `Privacidad > Servicios de ubicación > WeatherAppHLBR`.

<img src="https://scontent.fpbc1-1.fna.fbcdn.net/v/t1.15752-9/100670917_636867366901185_2802950998023208960_n.jpg?_nc_cat=102&_nc_sid=b96e70&_nc_eui2=AeFAOhCEiLussUAAkjDXCZGTE21O4xaqsPUTbU7jFqqw9Rueg5Jj3hwgbFGXa4x1eqw&_nc_oc=AQkJRBWZBFrGi4Oj0_eXyyTOP26IgV4_Mq2xy8C_I3R0d9IXt4_3aHi6Z6E8DKUYWXQmr0cnaqTg6sCsZXe4cRKO&_nc_ht=scontent.fpbc1-1.fna&oh=e42e86129e2d898a753b1827681f10e4&oe=5EF45DA1" width="250"/>

### 3. Clima en la ciudad actual
Si el usuario permite el acceso a los servicios de ubicación, la pantalla principal mostrará el clima en la ubicación actual por defecto. Deslizar horizontalmente permite ver las otras ciudades guardadas.

<img src="https://scontent.fpbc1-1.fna.fbcdn.net/v/t1.15752-9/99423990_246072773153129_2376410039146512384_n.jpg?_nc_cat=110&_nc_sid=b96e70&_nc_eui2=AeG1uXOFc04SXPL9qOU1MPdK-c6Z6VQ1E3z5zpnpVDUTfIxrN26w4S1tDaHyXs8zDAY&_nc_oc=AQlRis32j3uN5Lyc9MxK0biZ-IEMX4Hc-mqGwYYFJ-lDjJVJw1_C0clmf-ZRN77TFGD_3NWNLT-2uJuR-Q5m6G4q&_nc_ht=scontent.fpbc1-1.fna&oh=eb74c91aa3473fdbf02329dc331b4395&oe=5EF32347" width="250"/>

### 4. Barra de herramientas
En el inferior de la pantalla principal se encuentra la barra de herramientas.

<img src="https://scontent.fpbc1-1.fna.fbcdn.net/v/t1.15752-9/99073837_249537693022585_4380739193060458496_n.png?_nc_cat=105&_nc_sid=b96e70&_nc_eui2=AeHj44sWyavYW_iJgXMjq-ncx0ARAFfIFivHQBEAV8gWK_1GX7Xz-3rXbrgLW_oQzA4&_nc_oc=AQkW-uhyfhLDUrZ6z3wIEWCCWjyDUTYRFapOp1naCaVJaC90C2gRsvo9Xmto85L2q_UDaSn4phHf3ujczEnhKnjX&_nc_ht=scontent.fpbc1-1.fna&oh=fc0402e4f874bfe88c95396fb9c6316f&oe=5EF2DC9A" width="250"/>

```
1.- Botón de historial.

  Lleva a la pantalla que contiene el reporte del clima de los cinco días anteriores a la fecha actual. 
  Muestra los datos de la ciudad centrada en la pantalla principal.
  Arrastra desde la parte superior de la vista en dirección del inferior de la pantalla para cerrar.
  
2.- Indicador de navegación. 

  Muestra la posición del usuario conforme a todas las ciudades guardadas.
  
3.- Lista de ciudades guardadas. 

  Minimiza la visualización de todas las ciudades guardadas. 
  Permite cambiar más rápido entre ciudades.
  Toca una ciudad para verla en la pantalla principal.
```

### 5. Agregar ciudad
Selecciona el botón de **lista de ciudades guardadas** en la barra de herramientas. Al final de la lista de todas las ciudades guardadas, se encuentra el botón para agregar una ciudad.

<img src="https://scontent.fpbc1-1.fna.fbcdn.net/v/t1.15752-9/100556619_608115443393928_2458077665458913280_n.png?_nc_cat=108&_nc_sid=b96e70&_nc_eui2=AeGH0zE9OZML-vees_MXxvmgxy0Hg9-9DCrHLQeD370MKtN-XlwKnx1v7pCCRKEHufc&_nc_oc=AQlY7yiyrrVw6TDaMLLxLZc5h4LiTpIz1Zf5rEZQdmz7-Y95B9UJ803RAhO18hjX7GVsS9eHVP8uaeU0koo7g-r5&_nc_ht=scontent.fpbc1-1.fna&oh=fc3a13640a47b51884deef6a74686467&oe=5EF41F8D"/>

Escribe el nombre de la **ciudad** en el cuadro de texto.

<img src="https://scontent.fpbc1-1.fna.fbcdn.net/v/t1.15752-9/99252336_248940499854162_6700934574228111360_n.jpg?_nc_cat=100&_nc_sid=b96e70&_nc_eui2=AeHrl2H1Bwk5OVQTbbOnR_hxwAefNgqkI0jAB582CqQjSP7l8ySrZGTdUyDfo0w7kUE&_nc_oc=AQmeBVCUeokd2YB6PTWHNC-r-vOkci0LuPSAOXjCyD-ufbi_KW1YRQVSjIedy2hacHT22JfQQn_WeiRMUlXv_Y8I&_nc_ht=scontent.fpbc1-1.fna&oh=c710d382f1e59d35703edbf89f598847&oe=5EF480E9" width="250"/>

Toca una de las sugerencias y ya se agregará a tus ciudades favoritas. Volverás a la lista de ciudades guardadas.
