#!/bin/bash

ARCHIVO_USUARIOS="usuarios.txt"
ARCHIVO_PRODUCTOS="productos.txt"
USUARIO_LOGUEADO=""

registrar() {
    echo "Registro: pendiente"
}

login() {
    echo "Inicio de sesión: pendiente"
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
