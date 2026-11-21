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

alta_producto() {
    echo "Alta de producto: pendiente"
}

vender() {
    echo "Venta de producto: pendiente"
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
