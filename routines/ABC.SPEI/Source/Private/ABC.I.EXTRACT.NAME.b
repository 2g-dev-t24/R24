* @ValidationCode : MjoxNjE3OTk4NTI4OkNwMTI1MjoxNzYyODY5ODAyNTE5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Nov 2025 11:03:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcSpei

SUBROUTINE ABC.I.EXTRACT.NAME(Y.NOMBRE,Y.TIPO.CU,Y.APELLIDO.P,Y.APELLIDO.M,Y.NOMBRE.1,Y.NOMBRE.2,Y.NOM.PER.MORAL)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ESPACIO = " "

*    FECHA.FILE = FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4")
*    str_filename = "ABC.I.EXTRACT.NAME." : FECHA.FILE : ".log"
*    SEQ.FILE.NAME = "../interfaces/LOGS"
*    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
*        CREATE FILE.VAR1 ELSE
*        END
*    END

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*    MENSAJE = "INICIO"
*    GOSUB BITACORA

*    MENSAJE = Y.NOMBRE:", ":Y.TIPO.CU:", ":Y.APELLIDO.P:", ":Y.APELLIDO.M:", ":Y.NOMBRE.1:", ":Y.NOMBRE.2:", ":Y.NOM.PER.MORAL
*    GOSUB BITACORA

    Y.CLASSIFICATION = Y.TIPO.CU[1,1]

    Y.NAME = ''
    Y.NOMBRE = ''
    BEGIN CASE
        CASE Y.CLASSIFICATION = 1
            Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1
        CASE Y.CLASSIFICATION = 2
            Y.NAME = Y.APELLIDO.P:Y.ESPACIO:Y.APELLIDO.M:Y.ESPACIO:Y.NOMBRE.1
        CASE Y.CLASSIFICATION = 3
*        Y.NAME = Y.NOM.PER.MORAL
            Y.NAME = Y.APELLIDO.P ;*AAR-20220210
        CASE Y.CLASSIFICATION = 4
*        Y.NAME = Y.NOM.PER.MORAL
            Y.NAME = Y.APELLIDO.P ;*AAR-20220210
        CASE Y.CLASSIFICATION = 5
*        Y.NAME = Y.NOM.PER.MORAL
            Y.NAME = Y.APELLIDO.P ;*AAR-20220210
    END CASE

*    MENSAJE = "Y.NAME: ":Y.NAME
*    GOSUB BITACORA

    IF LEN(Y.NAME) < 40 THEN
*-- CD2060428.001 - changing X to blank
*--      Y.NOMBRE = FMT(Y.NAME,"40'X'L")
        Y.NOMBRE = FMT(Y.NAME,"40' 'L")
    END ELSE
        Y.NOMBRE = Y.NAME[1,40]
    END

RETURN
*-----------------------------------------------------------------------------
BITACORA:
*-----------------------------------------------------------------------------

*    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR1 ELSE
*    END
*    MENSAJE = ''
*    RETURN
*-----------------------------------------------------------------------------
END
