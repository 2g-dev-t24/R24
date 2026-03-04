* @ValidationCode : MjotMTQxMTkzNjcxNjpDcDEyNTI6MTc1NTg3NjQyNjk3NjpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Aug 2025 12:27:06
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

SUBROUTINE ABC.V.GET.CLABE
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
    $USING EB.Interface
*-----------------------------------------------------------------------------
    IF EB.Interface.getOfsOperation() EQ 'VALIDATE' THEN RETURN
    
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.ID.ACCT = FMT(EB.SystemTables.getIdNew(),"R%11")
    
    FN.ABC.PARAMETROS.BANXICO = 'F.ABC.PARAMETROS.BANXICO'
    F.ABC.PARAMETROS.BANXICO = ''
    EB.DataAccess.Opf(FN.ABC.PARAMETROS.BANXICO, F.ABC.PARAMETROS.BANXICO)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB GET.BANXICO
    
    Y.NUMBER.ACCT = Y.BANXICO.NUM.BANCO:Y.BANXICO.PLAZA:Y.ID.ACCT

    AbcAccount.AbcCalculaTes(Y.NUMBER.ACCT,Y.ERROR)

    IF Y.ERROR EQ 0 THEN
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Clabe, Y.NUMBER.ACCT)
    END ELSE
        EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
        ETEXT='ERROR EN LA GENERACION DE CUENTA CLABE'
*        EB.SystemTables.setE(ETEXT)
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN
*-----------------------------------------------------------------------------
GET.BANXICO:
*-----------------------------------------------------------------------------
    Y.BANXICO.NUM.BANCO = ''
    Y.BANXICO.PLAZA = ''

    EB.DataAccess.CacheRead(FN.ABC.PARAMETROS.BANXICO,'SYSTEM',R.REC.VAL,YERR)

    Y.BANXICO.NUM.BANCO = R.REC.VAL<AbcTable.AbcParametrosBanxico.BanxicoNumBanco>
    Y.BANXICO.PLAZA = R.REC.VAL<AbcTable.AbcParametrosBanxico.BanxicoPlaza>

RETURN
*-----------------------------------------------------------------------------
END