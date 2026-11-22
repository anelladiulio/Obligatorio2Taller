#!/bin/bash

ARCHIVO_USUARIOS="usuarios.txt"
ARCHIVO_PRODUCTOS="productos.txt"
USUARIO_LOGUEADO=""

registrar() {
    echo "Nombre de usuario:"
    read usuario
    if [ -z "$usuario" ]; then
        echo "El usuario no puede estar vacío"
        return
    fi
    case "$usuario" in
        *:*) echo "El usuario no puede contener el símbolo :" ; return ;;
    esac
    if grep -q "^$usuario:" "$ARCHIVO_USUARIOS"; then
        echo "Ese usuario ya existe"
        return
    fi

    echo "Contraseña:"
    read contrasena
    if [ -z "$contrasena" ]; then
        echo "La contraseña no puede estar vacía"
        return
    fi
    case "$contrasena" in
        *:*) echo "La contraseña no puede contener el símbolo :" ; return ;;
    esac

    echo "$usuario:$contrasena" >> "$ARCHIVO_USUARIOS"
    echo "Usuario registrado correctamente"
}

login() {
    echo "Nombre de usuario:"
    read usuario
    echo "Contraseña:"
    read contrasena
    if [ -z "$usuario" ] || [ -z "$contrasena" ]; then
        echo "Debe completar usuario y contraseña"
        return
    fi
    if grep -qxF "$usuario:$contrasena" "$ARCHIVO_USUARIOS"; then
        USUARIO_LOGUEADO="$usuario"
        echo "Bienvenida, $usuario"
    else
        echo "Usuario o contraseña incorrectos"
    fi
}
Alta_producto() {
    local nombre descripcion precio stock

    while true; do
        echo "Nombre del producto:"
        read nombre
        if [ -z "$nombre" ]; then
            echo "El nombre no puede estar vacio"
        elif [[ "$nombre" == *":"* ]]; then
            echo "El nombre no puede contener el símbolo :"
        elif [ -f "$ARCHIVO_PRODUCTOS" ] && cut -d ":" -f 1 "$ARCHIVO_PRODUCTOS" | grep -qxiF "$nombre"; then
            echo "Ese producto ya existe"
        else
            break
        fi
    done

    while true; do
        echo "Descripcion:"
        read descripcion
        if [ -z "$descripcion" ]; then
            echo "La descripcion no puede estar vacia"
        elif [[ "$descripcion" == *":"* ]]; then
            echo "La descripcion no puede contener el símbolo :"
        else
            break
        fi
    done

    while true; do
        echo "Precio:"
        read precio
        if ! [[ "$precio" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
            echo "Debe ingresar un precio valido"
        else
            break
        fi
    done

    while true; do
        echo "Stock:"
        read stock
        if ! [[ "$stock" =~ ^[0-9]+$ ]]; then
            echo "Debe ingresar un numero entero"
        else
            break
        fi
    done

    printf '%s:%s:%s:%s\n' "$nombre" "$descripcion" "$precio" "$stock" >> "$ARCHIVO_PRODUCTOS"
    echo "Producto agregado correctamente"
}


vender() {
    echo "Nombre del producto:"
read nombre_producto

    if [ -z "$nombre_producto" ]; then
        echo "El nombre no puede estar vacio"
        return
    fi
encontrado=0

while IFS=: read -r nombre descripcion precio stock; do

if [ "$(echo "$nombre" | tr '[:upper:]' '[:lower:]')" = "$(echo "$nombre_producto" | tr '[:upper:]' '[:lower:]')" ]; then
encontrado=1
break
fi
done < "$ARCHIVO_PRODUCTOS"

if [ "$encontrado" -eq 0 ]; then
echo "El producto no existe"
return
fi

echo "Cantidad que desea comprar:"
read cantidad

if ! [[ "$cantidad" =~ ^[1-9][0-9]*$ ]]; then
echo "Debe ingresar un numero entero positivo"
return
fi

if [ "$cantidad" -gt "$stock" ]; then
echo "Stock insuficiente. Unidades disponibles: $stock"
return
fi

nuevo_stock=$((stock - cantidad))

archivo_temporal=$(mktemp "${ARCHIVO_PRODUCTOS}.XXXXXX")

if [ -z "$archivo_temporal" ]; then
echo "Error al crear el archivo temporal"
return
fi

while IFS=: read -r nombre descripcion precio stock_actual || [ -n "$nombre" ]; do


if [ "$(echo "$nombre" | tr '[:upper:]' '[:lower:]')" = "$(echo "$nombre_producto" | tr '[:upper:]' '[:lower:]')" ]; then

        printf '%s:%s:%s:%s\n' "$nombre" "$descripcion" "$precio" "$nuevo_stock"
    else
        printf '%s:%s:%s:%s\n' "$nombre" "$descripcion" "$precio" "$stock_actual"
    fi

done < "$ARCHIVO_PRODUCTOS" > "$archivo_temporal"


if mv "$archivo_temporal" "$ARCHIVO_PRODUCTOS"; then
    echo "Venta realizada correctamente"
    echo "Producto: $nombre_producto"
    echo "Cantidad vendida: $cantidad"
    echo "Stock restante: $nuevo_stock"
else
    rm -f "$archivo_temporal"
    echo "Error al actualizar el archivo de productos"
    return
fi


}

touch "$ARCHIVO_USUARIOS" "$ARCHIVO_PRODUCTOS"

SALIR=0
while [ $SALIR -eq 0 ]; do
    if [ -z "$USUARIO_LOGUEADO" ]; then
        echo ""
        echo "===== SISTEMA DE VENTAS ====="
        echo "1) Registrarse"
        echo "2) Iniciar sesión"
        echo "3) Salir"
        echo "Opción:"
        read opcion
        case "$opcion" in
            1) registrar ;;
            2) login ;;
            3) SALIR=1 ;;
            *) echo "Opción inválida" ;;
        esac
    else
        echo ""
        echo "===== Usuario: $USUARIO_LOGUEADO ====="
        echo "1) Agregar producto"
        echo "2) Vender producto"
        echo "3) Cerrar sesión"
        echo "Opción:"
        read opcion
        case "$opcion" in
            1) alta_producto ;;
            2) vender ;;
            3) USUARIO_LOGUEADO="" ;;
            *) echo "Opción inválida" ;;
        esac
    fi
done
