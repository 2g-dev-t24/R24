* @ValidationCode : MjoyOTI5Mjc4NDQ6Q3AxMjUyOjE3NTg2NDc5NTEwMDI6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Sep 2025 14:19:11
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
*-----------------------------------------------------------------------------
SUBROUTINE ABC.VAL.TARJ.GAR
*======================================================================================
* Nombre de Programa : ABC.VAL.TARJ.GAR
* Objetivo           : Rutina que valida que la cuenta no tenga una tarjeta
*                      garantizada existente.
*======================================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Template
    $USING EB.ErrorProcessing
    $USING AbcTable

    V.FUNCTION = EB.SystemTables.getVFunction()
    IF V.FUNCTION EQ 'I' THEN
        GOSUB INICIALIZA
        GOSUB VALIDA.TARJETA
    END

RETURN

***********
INICIALIZA:
***********

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)

    Y.CUENTA = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.IntLiquAcct)
    Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA

RETURN

***************
VALIDA.TARJETA:
***************
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)

    IF R.EB.LOOKUP THEN
        Y.DESCRIPTION = R.EB.LOOKUP<EB.Template.Lookup.LuDescription, 1>
        Y.CUENTA.EB = R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo>
        Y.DATA.NAME.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataName>
        Y.DATA.VALUE.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataValue>

        LOCATE "TARJGAR" IN Y.DATA.NAME.LIST SETTING POS THEN
            Y.DATA.VALUE = Y.DATA.VALUE.LIST<POS>
        END

        IF Y.DESCRIPTION EQ 'AUTORIZADA' THEN
            EB.DataAccess.FRead(FN.ACCOUNT, Y.CUENTA.EB, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
            Y.ID.ARRAY = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
            EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
            IF R.ABC.ACCT.LCL.FLDS THEN
                Y.CANAL = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
                Y.CLABE = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Clabe>
            END
            EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
            ETEXT = "Ya existe cuenta garantizada: ":Y.CUENTA.EB:"|":Y.CLABE:"|":Y.CANAL
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            IF Y.DESCRIPTION NE 'SOLICITADA' OR Y.DATA.VALUE EQ '' THEN
                EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
                ETEXT = "No existe bloqueo para tarjeta garantizada."
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END

    END ELSE
        EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
        ETEXT = "No existe bloqueo para tarjeta garantizada."
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN

END
