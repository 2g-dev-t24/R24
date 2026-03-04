* @ValidationCode : MjotMTc3NzM5NDAwMDpDcDEyNTI6MTc1ODY1MjI0NTg3MjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Sep 2025 15:30:45
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
SUBROUTINE ABC.VAL.BLOQUEO.TARJ.GAR
*======================================================================================
* Nombre de Programa : ABC.VAL.BLOQUEO.TARJ.GAR
* Objetivo           : Rutina que valida que el la cuenta no tenga un bloqueo de tarjeta
*                      garantizada existente.
*======================================================================================
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING EB.Template
    $USING AbcTable

    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'I' THEN
        GOSUB INICIALIZA
        GOSUB VALIDA.BLOQUEO
    END

RETURN

***********
INICIALIZA:
***********

    FN.CUENTA = 'F.ACCOUNT'
    F.CUENTA = ''
    EB.DataAccess.Opf(FN.CUENTA, F.CUENTA)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)
    
    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    
    Y.CUENTA = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
    Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA



RETURN

***************
VALIDA.BLOQUEO:
***************
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)

    IF R.EB.LOOKUP THEN
        Y.DESCRIPTION = R.EB.LOOKUP<EB.Template.Lookup.LuDescription>
        Y.CUENTA.EB = R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo>
        Y.DATA.NAME.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataName>
        Y.DATA.VALUE.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataValue>

        LOCATE "TARJGAR" IN Y.DATA.NAME.LIST SETTING POS THEN
            Y.DATA.VALUE = Y.DATA.VALUE.LIST<POS>
        END

        IF Y.DESCRIPTION EQ 'SOLICITADA' THEN
            EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber)
            ETEXT = "Ya existe bloqueo para tarjeta garantizada. ID: ":Y.DATA.VALUE
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END ELSE
            IF Y.DESCRIPTION EQ 'AUTORIZADA' THEN
                EB.DataAccess.FRead(FN.CUENTA,Y.CUENTA.EB,R.CUENTA,F.CUENTA,ERR.CUENTA)
                Y.ID.ARRAY = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
                EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
                IF R.ABC.ACCT.LCL.FLDS THEN
                    Y.CANAL = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
                    Y.CLABE = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Clabe>
                END
                EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber)
                ETEXT = "Ya existe cuenta garantizada: ":Y.CUENTA.EB:"|":Y.CLABE:"|":Y.CANAL
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                IF Y.DESCRIPTION EQ 'APLICADA' THEN
                    EB.DataAccess.FRead(FN.CUENTA,Y.CUENTA.EB,R.CUENTA,F.CUENTA,ERR.CUENTA)
                    Y.ID.ARRAY = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
                    EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
                    IF R.ABC.ACCT.LCL.FLDS THEN
                        Y.CANAL = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
                        Y.CLABE = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Clabe>
                    END
                    EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber)
                    ETEXT = "Ya se aplico traspaso a cuenta garantizada: ":Y.CUENTA.EB:"|":Y.CLABE:"|":Y.CANAL:"|":Y.DATA.VALUE
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END ELSE
                    IF Y.DESCRIPTION EQ 'CANCELADA' AND Y.CUENTA.EB NE '' THEN
                        EB.DataAccess.FRead(FN.CUENTA,Y.CUENTA.EB,R.CUENTA,F.CUENTA,ERR.CUENTA)
                        Y.ID.ARRAY = R.CUENTA<AC.AccountOpening.Account.ArrangementId>
                        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
                        IF R.ABC.ACCT.LCL.FLDS THEN
                            Y.CANAL = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Canal>
                            Y.CLABE = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.Clabe>
                            EB.SystemTables.setAf(AC.AccountOpening.LockedEvents.LckAccountNumber)
                            ETEXT = "Intente mas tarde, cierre de cuenta en proceso: ":Y.CUENTA.EB:"|":Y.CLABE:"|":Y.CANAL:"|":Y.DATA.VALUE
                            EB.SystemTables.setEtext(ETEXT)
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                    END
                END
            END
        END

    END

RETURN

END
