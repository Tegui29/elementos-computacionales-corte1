#!/bin/bash

# Verifica si el directorio fue proporcionado y si existe
if [ -z "$1" ] || [ ! -d "$1" ]; then
    echo "Error: El directorio no existe o no se proporcionó un argumento válido."
    exit 1
fi

# Guarda la fecha del sistema en formato YYYY-MM-DD
FECHA=$(date +%Y-%m-%d)

# Define y crea la subcarpeta de backup dentro del directorio dado
DIRECTORIO_BACKUP="$1/backup_$FECHA"
mkdir -p "$DIRECTORIO_BACKUP"

# Inicializa el contador de archivos
CONTADOR=0
ARCHIVO_LOG="$DIRECTORIO_BACKUP/resumen.log"

# Inicia el archivo resumen.log
echo "Listado de archivos copiados:" > "$ARCHIVO_LOG"

# Recorre todos los archivos con extensión .txt en el directorio especificado
for archivo in "$1"/*.txt; do
    # Verifica que el archivo exista (para evitar errores si no hay ningún .txt)
    if [ -e "$archivo" ]; then
        # Extrae el nombre del archivo sin la ruta completa
        nombre_base=$(basename "$archivo")
        
        # Genera el nuevo nombre con la fecha al inicio
        nuevo_nombre="${FECHA}_${nombre_base}"
        
        # Copia el archivo a la carpeta de backup con el nuevo nombre
        cp "$archivo" "$DIRECTORIO_BACKUP/$nuevo_nombre"
        
        # Registra el archivo en el log
        echo "- $nuevo_nombre" >> "$ARCHIVO_LOG"
        
        # Incrementa el contador
        CONTADOR=$((CONTADOR + 1))
    fi
done

# Añade el conteo total de archivos al resumen.log
echo "-----------------------------------" >> "$ARCHIVO_LOG"
echo "Conteo total de archivos .txt: $CONTADOR" >> "$ARCHIVO_LOG"

echo "Proceso finalizado. Se han respaldado $CONTADOR archivos en $DIRECTORIO_BACKUP"
