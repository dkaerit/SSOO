#!/bin/bash
clear

# DEPENDENCIAS
source ./consts.sh
source ./deps.sh

# PROGRAMA PRINCIPAL
# flags y variables
interactive=
confirmar=
path_out=./
filename=sysinfo.txt

# Procesar la línea de comandos del script para leer las opciones
while [ "$1" != "" ]; do
   case $1 in
       -f | --file )
            shift
            filename=$1
            ;;

       -i | --interactive )
            interactive=1
            ;;

       -h | --help )
            usage
            exit
            ;;

       * )
            usage
            exit 1
   esac
   shift
done

# Generar el informe del sistema y guardarlo en el archivo indicado
# en $filename
if [ $interactive ]; then 
    menu
fi

write_page > "$path_out$filename"
