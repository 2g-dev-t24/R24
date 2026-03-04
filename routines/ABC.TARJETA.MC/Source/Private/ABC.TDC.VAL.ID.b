* @ValidationCode : MjotMTc1Nzg0OTk1NTpDcDEyNTI6MTc1NTU2MzM5OTEyMjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Aug 2025 21:29:59
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
$PACKAGE AbcTarjetaMc

SUBROUTINE ABC.TDC.VAL.ID
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.LEN.ID = ''
    Y.ID.AC.FISERV = EB.SystemTables.getComi()
    Y.ID.GEN.PARAM = 'TDC.UALA'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS.PARAM = ''
    Y.ID.NUM = ''

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    GOSUB GET.GENERAL.PARAM

    Y.LEN.ID = LEN(Y.ID.AC.FISERV)

    IF Y.LEN.ID NE Y.ID.NUM THEN

        ETEXT = "ERROR DE LONGITUD"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()

    END

RETURN

*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM,Y.LIST.PARAMS,Y.LIST.VALUES)

    LOCATE 'NUM.ID' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.ID.NUM = Y.LIST.VALUES<Y.POS.PARAM>
    END

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------

RETURN

END

