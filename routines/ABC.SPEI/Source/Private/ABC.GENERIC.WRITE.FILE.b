*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
*-----------------------------------------------------------------------------
*=============================================================================
    SUBROUTINE ABC.GENERIC.WRITE.FILE(Y.RUTA.ARCH,Y.NOM.ARCH,Y.ARR.ARCH)
*=============================================================================
*   Rutina Generica, Escribe en un Archivo.
*
*=============================================================================

    GOSUB INIT.VARS
    GOSUB PROCESS

    RETURN

**********
INIT.VARS:
**********
    Y.RUTA    = Y.RUTA.ARCH
    Y.ARREGLO  = Y.ARR.ARCH
    Y.NAME.ARCH = Y.NOM.ARCH

    RETURN

********
PROCESS:
********

    Y.PATH.ARCH.LINEA  = Y.RUTA:Y.NAME.ARCH

    DELETESEQ Y.PATH.ARCH.LINEA ELSE NULL

    OPENSEQ Y.PATH.ARCH.LINEA TO F.ARCHIVO.LINEA ELSE
        EXECUTE "mkdir -p " : Y.RUTA
        CREATE F.ARCHIVO.LINEA ELSE
            DISPLAY "Ruta o archivo inexistente" : Y.PATH.ARCH.LINEA
            ABORT
        END
    END

    WRITESEQ Y.ARREGLO APPEND TO F.ARCHIVO.LINEA ELSE
        DISPLAY "No se logro crear el archivo"
        ABORT
    END
    CLOSESEQ F.ARCHIVO.LINEA

    RETURN
END
