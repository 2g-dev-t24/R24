* @ValidationCode : MjoxOTQzMDI5NzMwOkNwMTI1MjoxNzU3MDM5MzEwMzk1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Sep 2025 23:28:30
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

SUBROUTINE ABC.CTA.ALT.CEL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING EB.Desktop

    $USING AbcTable
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.ALT.CTA = "F.ALTERNATE.ACCOUNT"
    F.ALT.CTA  = ""
    EB.DataAccess.Opf(FN.ALT.CTA,F.ALT.CTA)

    Y.CUENTA = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Celular)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF (LEN(Y.CUENTA) GE 1) AND (LEN(Y.CUENTA) LT 10) THEN
*Se eliminar la validacion debido a que la longitud del campo celular actualmente es 10.
        RETURN
**************
        ETEXT = "NO TIENE LA LONGITUD CORRECTA"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        EB.SystemTables.setComi("")
        EB.Display.RebuildScreen()
        RETURN
    END ELSE
*    AC.ALT.ACCT.TYPE = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.AltAcctType)
*    FIND "CELULAR" IN AC.ALT.ACCT.TYPE SETTING Fm,Vm,Sm THEN
*        Y.POS.ALT = Vm
*    END ELSE
*        ETEXT = "PARAMETRO CUENTA ALTERNA CELULAR NO EXISTE"
*        EB.SystemTables.setEtext(ETEXT)
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
*
*    AC.ALT.ACCT.ID.OLD = EB.SystemTables.getROld(AbcTable.AbcAcctLclFlds.AltAcctId)
*    IF AC.ALT.ACCT.ID.OLD<1,Y.POS.ALT> NE Y.CUENTA THEN
*        R.ALT.CTA = ''
*        EB.DataAccess.FRead(FN.ALT.CTA, Y.CUENTA, R.ALT.CTA, F.ALT.CTA, ERR.READ)
*
*        IF (R.ALT.CTA) THEN
*            ETEXT = "LA CUENTA ALTERNA YA EXISTE CON OTRO CLIENTE"
*            EB.SystemTables.setEtext(ETEXT)
*            EB.ErrorProcessing.StoreEndError()
*            EB.SystemTables.setComi("")
*            EB.Display.RebuildScreen()
*            RETURN
*        END ELSE
*            AC.ALT.ACCT.ID = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.AltAcctId)
*            AC.ALT.ACCT.ID<1,Y.POS.ALT> = Y.CUENTA
*            EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.AltAcctId, AC.ALT.ACCT.ID)
*
*            EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Celular, Y.CUENTA)
*        END
*    END
    END
    
RETURN
*-----------------------------------------------------------------------------
END