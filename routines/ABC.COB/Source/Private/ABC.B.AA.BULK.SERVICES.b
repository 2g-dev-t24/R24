* @ValidationCode : MjoyNTY0NjU0MzE6Q3AxMjUyOjE3NjIwMjg5NDE0MjQ6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 01 Nov 2025 17:29:01
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
$PACKAGE AbcCob

SUBROUTINE ABC.B.AA.BULK.SERVICES(REC.ID)
*-----------------------------------------------------------------------------
*===============================================
* Nombre de Programa:   ABC.B.AA.BULK.SERVICES
* Objetivo:
* Desarrollador:        ISAIAS RODRIGUEZ - FYG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       2016-10-05
* Modificaciones:
*===============================================
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING AA.Framework
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.TransactionControl
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    theResponse = ""
    txnCommitted = ""
    options = ''
    options<1> = "AA.COB"
    options<4> = "HLD"

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
 


    OFS.REQ = FIELD (REC.ID , '~',1)    ;*OFS QUE MANDA ACTUALIZAR LA TASA
    EB.Interface.OfsCallBulkManager(options,OFS.REQ,theResponse,txnCommitted)

    OFS.REQ = FIELD (REC.ID , '~',2)    ;*OFS QUE MANDA AUTORIZAR LA INVERSION.
    EB.Interface.OfsCallBulkManager(options,OFS.REQ,theResponse,txnCommitted)



RETURN

*-----------------------------------------------------------------------------
FINALLY:
RETURN
*-----------------------------------------------------------------------------
END

