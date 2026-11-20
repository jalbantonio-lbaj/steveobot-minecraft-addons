# SteveoBot en Android / Termux

Esta rama mantiene el código original intacto y añade un instalador para Termux.

## Requisitos

- Termux actualizado.
- Node.js 24 o superior.
- Git.
- Espacio libre para dependencias y los packs de ejemplo.

## Instalación

```sh
pkg install -y git nodejs-lts
git clone --single-branch --branch integration/termux-setup https://github.com/jalbantonio-lbaj/steveobot-minecraft-addons.git
cd steveobot-minecraft-addons
bash termux-setup.sh
```

El script instala pnpm 10.33.0 si falta, instala dependencias, ejecuta validación, comprobación de tipos, pruebas, compilación y empaquetado.

## Notas Android

- Node 24 satisface el requisito declarado por el proyecto.
- La dependencia crítica de compilación es esbuild. La instalación puede fallar si el paquete nativo no es compatible con el entorno Android/Bionic de Termux; si ocurre, conserva el mensaje completo y no sustituyas binarios de Linux.
- El despliegue automático a carpetas privadas de Minecraft no se ejecuta: en Android se debe importar el archivo .mcaddon generado manualmente.
- El script no ejecuta los comandos deploy ni realm.
- Los paquetes de salida se guardan en `dist/_packages/`.

## Comprobaciones

`pnpm run check` corre las validaciones, el chequeo TypeScript, las pruebas y la compilación. Si termina correctamente, `node tools/package.ts` genera los archivos importables.
