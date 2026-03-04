* @ValidationCode : MjotMTE2OTExNzgyMjpDcDEyNTI6MTc1NTAwNDM5MzcwODpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Aug 2025 10:13:13
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

$PACKAGE AbcAccount

SUBROUTINE PBS.GET.ADRESS.USO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING EB.ErrorProcessing

    $USING AbcTable
    $USING AbcAccount
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.SEP      = "|"
    Y.SEPA     = "-"

    Y.COD.POS = EB.SystemTables.getComi()
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getMessage() EQ 'VAL' THEN
        RETURN
    END ELSE

        Y.CADENA.DIRECCION = ''
        
        AbcAccount.PbsDireccionSepomex(Y.COD.POS, Y.CADENA.DIRECCION)

        Y.ESTADO    = FIELD(Y.CADENA.DIRECCION, Y.SEP, 1)
        Y.CD.DESC   = FIELD(Y.CADENA.DIRECCION, Y.SEP, 2)
        Y.CIUDAD    = FIELD(Y.CD.DESC,Y.SEPA,1)
        Y.MUNICIPIO = FIELD(Y.CADENA.DIRECCION, Y.SEP, 3)
        Y.COLONIA   = FIELD(Y.CADENA.DIRECCION, Y.SEP, 4)
        Y.PAIS      = FIELD(Y.CADENA.DIRECCION, Y.SEP, 5)

        IF Y.CADENA.DIRECCION EQ "" THEN
            ETEXT = 'El Codigo Postal que ingreso no existe, digite un Codigo Postal valido y presione la tecla de tabulador'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.CpFonTer, "")
            EB.Display.RebuildScreen()
            RETURN
        END
    
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.EstFonTer,Y.ESTADO)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.DelMunFonTer,Y.MUNICIPIO)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.ColFonTer,Y.COLONIA)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.CiudadFonTer,Y.CIUDAD)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.CpFonTer,Y.COD.POS)

        EB.Display.RebuildScreen()
*        CALL REFRESH.GUI.OBJECTS
    END
    
    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
END