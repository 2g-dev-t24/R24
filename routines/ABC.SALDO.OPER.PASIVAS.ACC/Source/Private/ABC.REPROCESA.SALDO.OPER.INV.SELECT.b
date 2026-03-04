* @ValidationCode : MjotMTc5NjI1OTAwMDpDcDEyNTI6MTc2OTYxNTEwMjcxNTpFZGdhciBTYW5jaGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Jan 2026 09:45:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE ABC.REPROCESA.SALDO.OPER.INV.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcSaldoOperPasivasAcc
    $USING EB.Service
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    CTA.NO.OF.REC   = 0
    CTA.RET.CODE    = ''
    CTA.SEL.LIST    = ''
    CTA.SEL.CMD     = ''
    Y.SEL.AA.LIST   = ''
***LOG
    Y.MSG   = ''
    
    FN.ARR      = AbcSaldoOperPasivasAcc.getFnArr()
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*    GOSUB CREATE.LOG
    
*    CTA.SEL.CMD = "SELECT ":FN.ARR:" WITH PRODUCT EQ 'DEPOSIT.FIXED.INT' "
    CTA.SEL.CMD     = "SELECT ":FN.ARR:" WITH PRODUCT EQ 'ABC.DEPOSIT.FIXED.INT' "
    CTA.SEL.LIST    = ''
    EB.DataAccess.Readlist(CTA.SEL.CMD,CTA.SEL.LIST, '', CTA.NO.OF.REC, CTA.RET.CODE)
    IF (CTA.SEL.LIST) THEN
        Y.SEL.AA.LIST = CTA.SEL.LIST
	END
***LOG
    Y.MSG<-1>= 'SEL.ABC.DEPOSIT.FIXED.INT -->':CTA.SEL.LIST

    CTA.SEL.CMD     = "SELECT ":FN.ARR:" WITH PRODUCT EQ 'DEPOSIT.REVIEW.INT' "
    CTA.SEL.LIST    = ''
    EB.DataAccess.Readlist(CTA.SEL.CMD,CTA.SEL.LIST, '', CTA.NO.OF.REC, CTA.RET.CODE)
    IF (CTA.SEL.LIST) THEN
        IF (Y.SEL.AA.LIST) THEN
            Y.SEL.AA.LIST := @FM:CTA.SEL.LIST
        END ELSE
            Y.SEL.AA.LIST = CTA.SEL.LIST
        END
    END
***LOG
    Y.MSG<-1>= 'SEL.DEPOSIT.REVIEW.INT -->':CTA.SEL.LIST

    CTA.SEL.CMD     = "SELECT ":FN.ARR:" WITH PRODUCT EQ 'DEPOSIT.VAR.INT' "
    CTA.SEL.LIST    = ''
    EB.DataAccess.Readlist(CTA.SEL.CMD,CTA.SEL.LIST, '', CTA.NO.OF.REC, CTA.RET.CODE)
    IF (CTA.SEL.LIST) THEN
        IF (Y.SEL.AA.LIST) THEN
            Y.SEL.AA.LIST := @FM:CTA.SEL.LIST
        END ELSE
            Y.SEL.AA.LIST = CTA.SEL.LIST
        END
    END
***LOG
    Y.MSG<-1>= 'SEL.DEPOSIT.VAR.INT -->':CTA.SEL.LIST
    
    CTA.SEL.CMD     = "SELECT ":FN.ARR:" WITH PRODUCT EQ 'DEPOSIT.PROMISSORY' "
    CTA.SEL.LIST    = ''
    EB.DataAccess.Readlist(CTA.SEL.CMD,CTA.SEL.LIST, '', CTA.NO.OF.REC, CTA.RET.CODE)
    IF (CTA.SEL.LIST) THEN
        IF (Y.SEL.AA.LIST) THEN
            Y.SEL.AA.LIST := @FM:CTA.SEL.LIST
        END ELSE
            Y.SEL.AA.LIST = CTA.SEL.LIST
        END
    END
***LOG
    Y.MSG<-1>= 'SEL.DEPOSIT.PROMISSORY -->':CTA.SEL.LIST
    
***LOG
    Y.MSG<-1>= 'SEL.ALL -->':Y.SEL.AA.LIST
    
*    GOSUB SAVE.LOG

    LIST.PARAMETER = ''
    EB.Service.BatchBuildList(LIST.PARAMETER, Y.SEL.AA.LIST)
    
RETURN
*-----------------------------------------------------------------------------
*CREATE.LOG:
*-----------------------------------------------------------------------------
**    str_path = Y.RUTA.INFORMES.APP
*    str_path = '/shares/log'
*    str_filename = "ABC.REPROCESA.SALDO.OPER.INV.SELECT":RND(2000000):TIME():".txt"
*    TEMP.FILE = str_path : "/" : str_filename
*
*    OPENSEQ TEMP.FILE TO ARCHIVO.LOG ELSE
*        CREATE ARCHIVO.LOG ELSE
*        END
*    END
    
*RETURN
*-----------------------------------------------------------------------------
*SAVE.LOG:
*-----------------------------------------------------------------------------
*    WRITESEQ Y.MSG APPEND TO ARCHIVO.LOG ELSE
*        Y.MENSAJE = "No se Consiguio Escribir el Archivo de log "
*        DISPLAY Y.MENSAJE
*    END
*
*RETURN
*-----------------------------------------------------------------------------
END