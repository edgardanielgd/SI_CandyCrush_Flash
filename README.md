## Candy crush
### Instalación
El juego solo es compatible con el sistema opeartivo Windows, se requiere de 
un gestor de paquetes y proveedor de herramientas de compilación como MSYS2.

Se requiere de la instalación de la librería OPENCV, instalación en MSYS2:
`pacman -S mingw-w64-x86_64-opencv`

[OPCIONAL] Se requiere de la instalación de Make, instalación en MSYS2:
`pacman -S make`

### Compilación
Se provee un archivo Makefile con las herramientas de compilación y testeo necesarias

#### Compilación del juego
`make`

#### Ejecución del juego
`make exec`

#### Testeo de movimiento dada percepción
`make agentTest`
`make agent`

### Notas Importantes
El jugador autónomo se encargará de abrir el juego antes de empezar, SE BLOQUEARÁ
el uso del ratón a fin de mantener la pantalla del juego en primer plano y evitar
que el jugador autónomo se equivoque de ventana. (Por tanto, no se podrá
interactuar con el ordenador mientras el jugador autónomo esté en funcionamiento)
El juegador finalizará tras 4:45 minutos de ejecución.