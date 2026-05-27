# VentasCasaNodeAngular

## Ejecutar todo con 1 click

### Linux (Pop!_OS / Ubuntu)
1. Dar permisos una sola vez:
   ```bash
   chmod +x run.sh
   ```
2. Ejecutar:
   - Doble click en `run.sh` y elegir **Run**.
   - o por terminal:
     ```bash
     cd /home/ronaldo/capo/Ofael-de-mrd/VentasCasaNodeAngular
     ./run.sh
     ```

Esto levanta:
- Backend: `http://localhost:3500`
- Frontend: `http://localhost:4300`

### Windows
- Doble click en `iniciar-entorno.bat`.

## Notas
- Si es primera ejecución, instalará dependencias automáticamente.
- Para detener ambos servicios en Linux, presiona `Ctrl + C` en la terminal donde corre `run.sh`.
- `run.sh` desactiva prompts interactivos de Angular CLI (analytics) para que no se corte el arranque.
