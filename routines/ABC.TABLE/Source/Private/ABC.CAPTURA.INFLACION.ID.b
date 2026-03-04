* @ValidationCode : Mjo2NDA4ODE1Mzg6Q3AxMjUyOjE3NTY5MDgxMDA0NzQ6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Sep 2025 11:01:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable


SUBROUTINE ABC.CAPTURA.INFLACION.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Display

*-----------------------------------------------------------------------------

    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
    ID.NEW = EB.SystemTables.getIdNew()
    TODAY = EB.SystemTables.getToday()

    V.FUNCT = EB.SystemTables.getVFunction()
    IF V.FUNCT EQ 'S' ELSE
        IF ID.NEW EQ TODAY[1,6] ELSE
            TEXT = 'AÑO MES INCORRECTOS, SE CAMBIARA POR ACTUAL ':TODAY[1,6]
            EB.SystemTables.setText(TEXT)
            EB.Display.Rem();
            EB.SystemTables.setIdNew(TODAY[1,6])
        END
    END

RETURN

END
