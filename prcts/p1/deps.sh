# UBICACIÓN DE TRABAJO
base() 
{
    SCRIPT=$(readlink -f $0);
    dir_base=`dirname $SCRIPT`;
    echo "El script se encuentra en $dir_base";
} 

# USAGE
usage() 
{
    echo "usage: sysinfo [-f file ] [-i] [-h]"
}

# OTRAS FUNCIONES 
system_info() 
{
    echo -e "\n${TEXT_UNLINE} ${TEXT_GREEN} ${TEXT_REVERSE}Versión del sistema${TEXT_RESET}"
    echo -e "\n- version resumida: $(uname -r)"
    echo -e "- versión extendida: $(uname -a)"
    echo
}

show_uptime() 
{
    echo -e "\n${TEXT_ULINE} ${TEXT_GREEN} ${TEXT_REVERSE}Tiempo de encendido del sistema${TEXT_RESET}\n"
    echo  $(uptime)
    echo
}

drive_space() 
{
    echo -e "\n${TEXT_ULINE} ${TEXT_GREEN} ${TEXT_REVERSE}Espacio ocupado en las particiones/discos duros del sistema:${TEXT_RESET}\n"
    echo "${TEXT_ULINE}Espacio en el sistema de archivos${TEXT_RESET}"
    echo
    df 
    echo
}

home_space() 
{
    echo -e "\n${TEXT_ULINE} ${TEXT_GREEN} ${TEXT_REVERSE}Espacio ocupado por directorios personales en /home:${TEXT_RESET}\n"
    
    # Sólo el superusuario puede obtener esta información
    if [ "$USER" = "root" ]; then
        echo "${TEXT_ULINE}Espacio en home por usuario${TEXT_RESET}"
        echo
        echo "Bytes Directorio"
        du -s /home/* | sort -nr
    fi
    echo
}


# WRITE INFO
write_page() 
{
    cat << _EOF_

    $TEXT_BOLD$TITLE$TEXT_RESET
    $TEXT_GREEN$(base)$TEXT_RESET

    $(system_info)
    $(show_uptime)
    $(drive_space $1 $2)
    $(home_space)

    $TEXT_GREEN$TIME_STAMP$TEXT_RESET

_EOF_
}

# MENU INTERACTIVO
menu() {
    selection=
    path_file=./
    until [ "$selection" = "0" ]; do
        clear
        echo "
        MENÚ DEL PROGRAMA
        1 - Introducir nombre del fichero (default: sysinfo.txt)
        2 - System info
        3 - Show uptime
        4 - Drive Space
        5 - Home Space
        6 - Exportar informe


        $TEXT_SQUARE[S] Salir del programa $TEXT_RESET
        "
        echo -n "Introduzca su elección: "
        read selection
        echo ""
        case $selection in
            1 ) 
                clear
                printf "Nuevo nombre: " && read -r filename 
                ;;
            2 ) 
                clear
                system_info 
                read getchar
                ;;
            3 ) 
                clear
                show_uptime 
                read getchar
                ;;
            4 ) 
                clear
                drive_space 
                read getchar
                ;;
            5 ) 
                clear
                home_space 
                read getchar
                ;;
            6 )
                clear
                
                if [ -f $path_file/$filename ]; then
                    printf "El fichero ya existe ¿Desea reemplazarlo? [S/N]: " && read -r confirm
                    if [ $confirm == 'S' ]; then
                    
                        {
                            write_page > "$path_file$filename"
                            echo -e "$TEXT_GREEN\n\tExportado con éxito\n$TEXT_RESET"
                        } || {
                            echo -e "$TEXT_GREEN\n\tError al exportar\n$TEXT_RESET"
                        } 
                        
                    elif [ $confirm == 'N' ]; then
                        echo -e "$TEXT_GREEN\n\tExportado anulado\n$TEXT_RESET"
                    else 
                        echo -e "$TEXT_GREEN\n\tEsa no es una opción válida\n$TEXT_RESET"
                    fi
                else 
                    {
                    write_page > "$path_file$filename"
                        echo -e "$TEXT_GREEN\n\tExportado con éxito\n$TEXT_RESET"
                    } || {
                        echo -e "$TEXT_GREEN\n\tError al exportar\n$TEXT_RESET"
                    } 
                fi
                
                read getchar
                ;;
            S ) exit ;;
            * ) echo "Por favor, introduzca 1, 2, 3, 4, 5 o 6"
        esac
    done
}
