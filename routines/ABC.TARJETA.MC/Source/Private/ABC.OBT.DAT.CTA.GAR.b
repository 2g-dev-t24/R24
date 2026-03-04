* @ValidationCode : MjoxMDIyOTk4NDEwOkNwMTI1MjoxNzU4NDY0NTgwMjQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Sep 2025 11:23:00
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

SUBROUTINE ABC.OBT.DAT.CTA.GAR
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Template
    $USING EB.ErrorProcessing
    $USING AbcTable
*-----------------------------------------------------------------------------
*    Y.FUNCTION          = EB.SystemTables.getVFunction()
*    IF Y.FUNCTION  EQ 'I' THEN
    GOSUB INICIALIZA
    GOSUB LEER.PARAMETROS
    GOSUB OBTIENE.DATOS
*    END

RETURN

***********
INICIALIZA:
***********

    FN.EB.LOOKUP = 'F.EB.LOOKUP' ; F.EB.LOOKUP = '' ; EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)
    FN.ACCOUNT = 'F.ACCOUNT' ; F.ACCOUNT = '' ; EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)

    Y.CUENTA.ORI = EB.SystemTables.getComi()

    Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA.ORI

RETURN

*-----------------------------------------------------------------------------
LEER.PARAMETROS:
*-----------------------------------------------------------------------------

    Y.PARAM.ID = 'ABC.NIVEL.CUENTAS'
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
    IF R.ABC.GENERAL.PARAM THEN
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
    END ELSE
        ETEXT = 'No existe el parámetro ':Y.PARAM.ID:' en la tabla ABC.GENERAL.PARAM'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    
RETURN

**************
OBTIENE.DATOS:
**************

    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)
    IF R.EB.LOOKUP THEN
        Y.DESCRIPTION = R.EB.LOOKUP<EB.Template.Lookup.LuDescription>
        Y.CUENTA.EB = R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo>
        Y.DATA.NAME.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataName>
        Y.DATA.VALUE.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataValue>

        LOCATE "TARJGAR" IN Y.DATA.NAME.LIST SETTING POS THEN
            Y.DATA.VALUE = Y.DATA.VALUE.LIST<POS>
        END

    END

    EB.DataAccess.FRead(FN.ACCOUNT, Y.CUENTA.ORI, R.CUENTA, F.ACCOUNT, Y.ERR)

    IF R.CUENTA THEN
        Y.CUSTOMER = R.CUENTA<AC.AccountOpening.Account.Customer>
        Y.CURRENCY = R.CUENTA<AC.AccountOpening.Account.Currency>
        Y.ACCOUNT.OFFICER = R.CUENTA<AC.AccountOpening.Account.AccountOfficer>
        GOSUB OBTENER.NIVEL
        GOSUB LEER.LCL.FLDS
        LOCATE "CELULAR" IN R.CUENTA<AC.AccountOpening.Account.AltAcctType,1> SETTING Y.TYPE.POS THEN
            Y.CELULAR = R.CUENTA<AC.AccountOpening.Account.AltAcctId,Y.TYPE.POS>
        END
        
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Customer,Y.CUSTOMER)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Currency,Y.CURRENCY)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.AccountOfficer,Y.ACCOUNT.OFFICER)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Classification,Y.CLASSIFICATION)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Nivel,Y.NIVEL)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Canal,Y.CANAL)
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Celular,Y.CELULAR)

    END ELSE

        ETEXT = "La cuenta origen no existe: ":Y.CUENTA.ORI
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()

    END

RETURN
********************
OBTENER.NIVEL:
********************
    Y.ACCOUNT.CATEGORY  = R.CUENTA<AC.AccountOpening.Account.Category>
    
    Y.NO.VALORES = DCOUNT(Y.LIST.PARAMS,@FM)
    FOR Y.AA=1 TO Y.NO.VALORES
        Y.PARAM = Y.LIST.PARAMS<Y.AA>
        Y.CATEGORIA = Y.LIST.VALUES<Y.AA>
        CHANGE '|' TO @FM IN Y.CATEGORIA
        LOCATE Y.ACCOUNT.CATEGORY IN Y.CATEGORIA SETTING Y.POS THEN
            Y.NIVEL = Y.PARAM
        END
    NEXT Y.AA
RETURN

**********************
LEER.LCL.FLDS:
**********************
    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,ACC.ID.FLDS,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,Y.ABC.ACCT.LCL.FLDS.ERR)
    
    Y.CLASSIFICATION = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Classification>
    Y.CANAL          = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>

RETURN

END

