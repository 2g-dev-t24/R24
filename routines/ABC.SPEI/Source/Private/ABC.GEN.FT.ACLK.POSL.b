* @ValidationCode : Mjo1NjM1MTk1NTE6Q3AxMjUyOjE3NTY5MDg4OTYzOTc6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Sep 2025 11:14:56
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
$PACKAGE AbcSpei

SUBROUTINE ABC.GEN.FT.ACLK.POSL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AbcTable
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING EB.ErrorProcessing
    $USING EB.Foundation
    $USING EB.Interface
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.GENE.PARAM = 'ABC.AC.COMERCIO.POSL'
    Y.ACC.ABONO = ''
    Y.TXN.TYPE = ''
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.POS.PARAM = ''
    OFS.MSG = ''
    Y.POS.FLAG.POSL = ''      ;* AAR.20230720 - S
    EB.Updates.MultiGetLocRef("AC.LOCKED.EVENTS","FLAG.POSL",Y.POS.FLAG.POSL)


RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------

    GOSUB GET.GENERAL.PARAM

    Y.CTA.CLIENTE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.MONTO.BLOQ = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)

    NEW.REC.ID = ''
    R.ACLK = ''
    R.ACLK<AC.AccountOpening.LockedEvents.LckAccountNumber> = Y.CTA.CLIENTE
    R.ACLK<AC.AccountOpening.LockedEvents.LckDescription>    = EB.SystemTables.getIdNew()
    R.ACLK<AC.AccountOpening.LockedEvents.LckLockedAmount>  = Y.MONTO.BLOQ
    R.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef,Y.POS.FLAG.POSL> = 'POSL'       ;* AAR.20230720 S-E
    EB.Foundation.OfsBuildRecord(APP.NAME,FUNCT,OFS.PROCESS,OFSVERSION,"",NO.OF.AUTH,NEW.REC.ID,R.ACLK,OFS.MSG)
* Finaliza MADM

    Y.RTN.ERR = ''
    EB.Interface.OfsAddlocalrequest(OFS.MSG, "add", Y.RTN.ERR)

    IF Y.RTN.ERR THEN
        ETEXT = "NO SE PUDO REALIZAR EL BLOQUEO DE SALDO: ":Y.RTN.ERR
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN

*-------------------------------------------------------------------------------
GET.GENERAL.PARAM:
*-------------------------------------------------------------------------------

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GENE.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
* Cambio MADM, Se agregan nuevos parámetros
    LOCATE "OFS.APP.NAME" IN Y.LIST.PARAMS SETTING POS THEN
        APP.NAME = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.VERSION" IN Y.LIST.PARAMS SETTING POS THEN
        OFSVERSION = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.FUNCTION" IN Y.LIST.PARAMS SETTING POS THEN
        FUNCT = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.NO.OF.AUTH" IN Y.LIST.PARAMS SETTING POS THEN
        NO.OF.AUTH = Y.LIST.VALUES<POS>
    END

    LOCATE "OFS.PROCESS" IN Y.LIST.PARAMS SETTING POS THEN
        OFS.PROCESS = Y.LIST.VALUES<POS>
    END
* Fin MADM

RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
RETURN

END

