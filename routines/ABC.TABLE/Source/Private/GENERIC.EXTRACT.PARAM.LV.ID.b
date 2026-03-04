* @ValidationCode : MjotMTcyNjk4NzYxOTpDcDEyNTI6MTc2MTYxNzY4MjkwMjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2025 23:14:42
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

SUBROUTINE GENERIC.EXTRACT.PARAM.LV.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* ======================================================================
* Nombre de Programa : GENERIC.EXTRACT.PARAM.LV.ID
* Parametros         :
* Objetivo           : Valida ID de registros creados dentro de la tabla
* Desarrollador      : Cristian Manriquez
* Compañia           : LARRAIN VIAL
* Fecha Creacion     : 2015-05-05
* Modificaciones     :
* ======================================================================
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    
    GOSUB INITIALIZE          ;*
    GOSUB VALIDATE.ID         ;*

RETURN

*-----------------------------------------------------------------------------

*** <region name= INITIALIZE>
INITIALIZE:
***
    COMI = EB.SystemTables.getComi()
    Y.ID        = COMI

    Y.ID        = FIELD(Y.ID, '-', 1)
    Y.ID        = FIELD(Y.ID, '$', 1)

    FN.STANDARD.SELECTION   = 'F.STANDARD.SELECTION'
    F.STANDARD.SELECTION    = ''
    EB.DataAccess.Opf(FN.STANDARD.SELECTION, F.STANDARD.SELECTION)

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= VALIDATE.ID>
VALIDATE.ID:
***

    EB.DataAccess.FRead(FN.STANDARD.SELECTION, Y.ID, Y.REG.SS, F.STANDARD.SELECTION, '')

    IF Y.REG.SS EQ '' THEN
        ETEXT        = 'ID erroneo, formato correcto: "APLICACION" o "APLICACION-TEXTO"'
        EB.SystemTables.setE(ETEXT)
    END

RETURN
*** </region>

END

