* @ValidationCode : MjoxMDY4ODkzNTU0OkNwMTI1MjoxNzU5MjU3NDc1NzAyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 30 Sep 2025 15:37:55
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
SUBROUTINE ABC.TEMP.GENE.FT.AUTHORISE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
	$USING EB.DataAccess
	$USING EB.SystemTables
	$USING EB.ErrorProcessing
	$USING AC.AccountOpening
	$USING FT.Contract
	$USING EB.Display
	$USING EB.Updates
	$USING EB.Interface
    $USING EB.TransactionControl
    $USING EB.Foundation

    $USING AbcGetGeneralParam
	$USING AbcAccount
	$USING AbcTable
*-----------------------------------------------------------------------------
    DEFFUN System.getVariable()
	GOSUB INITIALISE

	GOSUB BEFORE.AUTH.WRITE
    
RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
	FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ''
    EB.DataAccess.Opf(FN.FT,F.FT)

    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FT.HIS = ''
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    FN.ACLK = "F.AC.LOCKED.EVENTS"
    F.ACLK = ''
    EB.DataAccess.Opf(FN.ACLK,F.ACLK)

    FN.ABC.PEND.GALILEO = "F.ABC.PENDIENTES.GALILEO"
    F.ABC.PEND.GALILEO = ""
    EB.DataAccess.Opf(FN.ABC.PEND.GALILEO, F.ABC.PEND.GALILEO)

    FN.ABC.CONCAT.GALILEO = "F.ABC.CONCAT.GALILEO"
    F.ABC.CONCAT.GALILEO = ""
    EB.DataAccess.Opf(FN.ABC.CONCAT.GALILEO, F.ABC.CONCAT.GALILEO)

    LREF.TABLE = "FUNDS.TRANSFER":@FM:"AC.LOCKED.EVENTS"
    LREF.FIELD = "ORIG.AMOUNT":@VM:"ORIG.CURRENCY":@VM:"COMISION":@VM:"TIPO.CAMB":@VM:"AUTH.ID":@VM:"PORC.FLUC":@VM:"MCC":@FM:"AT.UNIQUE.ID":@VM:"AT.AUTH.CODE":@VM:"ORIG.AMOUNT":@VM:"ORIG.CURRENCY":@VM:"TIPO.CAMB":@VM:"MCC":@VM:"COMISION"
    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)
    POS.ORIG.MONTO     = LREF.POS<1,1>
    POS.ORIG.CURRN     = LREF.POS<1,2>
    POS.COMI.CAJERO    = LREF.POS<1,3>
    POS.TIPO.CAMB      = LREF.POS<1,4>
    POS.AUTH.ID        = LREF.POS<1,5>
    POS.PORC.FLUC      = LREF.POS<1,6>
    POS.MCC.FT         = LREF.POS<1,7>
    POS.UNIQUE.ID      = LREF.POS<2,1>
    POS.AUTH.CODE      = LREF.POS<2,2>
    POS.ORIG.MONTO.AC  = LREF.POS<2,3>
    POS.ORIG.CURRN.AC  = LREF.POS<2,4>
    POS.TIPO.CAMB.AC   = LREF.POS<2,5>
    POS.MCC            = LREF.POS<2,6>
    POS.ACLK.COMIS     = LREF.POS<2,7>

    Y.ID.GEN.PARAM = 'ABC.CTAS.COMPENSACION'
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    CTA.COMPENSACION.POS = '' ; CTA.DEBITO.POS = '' ; CTA.COMPENSACION.ATM = '' ; CTA.DEBITO.ATM = ''

    LOCATE 'CUENTA.COMPENSACION.POS' IN Y.LIST.PARAMS SETTING POS.CTA.COM.POS THEN
        CTA.COMPENSACION.POS = Y.LIST.VALUES<POS.CTA.COM.POS>
    END

    LOCATE 'CUENTA.DEBITO.POS' IN Y.LIST.PARAMS SETTING POS.CTA.DEB.POS THEN
        CTA.DEBITO.POS = Y.LIST.VALUES<POS.CTA.DEB.POS>
    END

    IF CTA.DEBITO.POS EQ 'NA' THEN
        CTA.DEBITO.POS = ''
    END

    LOCATE 'CUENTA.COMPENSACION.ATM' IN Y.LIST.PARAMS SETTING POS.CTA.COM.ATM THEN
        CTA.COMPENSACION.ATM = Y.LIST.VALUES<POS.CTA.COM.ATM>
    END

    LOCATE 'CUENTA.DEBITO.ATM' IN Y.LIST.PARAMS SETTING POS.CTA.DEB.ATM THEN
        CTA.DEBITO.ATM = Y.LIST.VALUES<POS.CTA.DEB.ATM>
    END
    
    Y.AUTHID.NUEVO.REVE = System.getVariable('Y.AUTHID.NUEVO.REVE')
    AUTH.ID.ACLK = Y.AUTHID.NUEVO.REVE
    Y.AUTH.ID.ORIGINAL = Y.AUTHID.NUEVO.REVE
    REC.FT = '' ; REC.GENE = '' ; A.RESULT = ''
RETURN

*-----------------------------------------------------------------------------
BEFORE.AUTH.WRITE:
*-----------------------------------------------------------------------------
    
    GOSUB VALIDA.EXISTE.REVE
    IF Y.EXISTE.REVE EQ 1 THEN
        EB.SystemTables.setE("REVERSO DE BLOQUEO YA RECIBIDO")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        Y.GUARDA.AUTHID.REVE = "SI"
    END
    GOSUB VALIDA.EXISTE.ORIG.AUTHID
    GOSUB VALIDA.EXISTE.REVE.PAR.PEND
    IF (Y.EXISTE.AUTH.ID EQ 'NO') AND (Y.EXISTE.AUTH.ID.REVE.PAR EQ 'NO') THEN
        Y.SAVE.AUDIT.FLDS = 1
    END
    Y.OFS.SOURCE = "ATM.ONLINE"
    Y.FECHA.APL = OCONV(DATE(),'DY4'):FMT(OCONV(DATE(),"DM"),"2'0'R"):FMT(OCONV(DATE(),"DD"),"2'0'R")

    Y.VERSION.APL = EB.SystemTables.getPgmVersion()
    Y.VERSION.FT = ''
    A.AMOUNT = ''

    A.DEBIT.AMOUNT = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.DebitAmount)
    Y.COMISION = ''
    YOUT = ''

    A.ORIG.AMOUNT = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.OrigAmount)
    A.ORIG.CURRENCY = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.OrigCurrency)
    A.COMISION = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.Comision)
    TIPO.CAMBIO = ''

    A.MONTO.REV.PARCIAL = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.MontoRevParcial)

    Y.ORIG.AUTHID = EB.SystemTables.getRNew(AbcTable.AbcTempGeneFt.OrigAuthId)
    Y.VRSN.REVE.POS = ",REVERSO.COMPRA.MC"
    IF (Y.ORIG.AUTHID NE '') AND (Y.VERSION.APL NE Y.VRSN.REVE.POS) AND (A.MONTO.REV.PARCIAL EQ '') THEN
        GOSUB VALIDA.ORIG.AUTH.ID
        IF V$ERROR EQ 1 THEN
            EB.ErrorProcessing.Err()
            RETURN
        END
    END
    Y.MSG.REV.PREV.BLOQ = "REVERSO LLEGO ANTES QUE BLOQUEO"

    IF EB.SystemTables.getVFunction() EQ "S" ELSE
        BEGIN CASE
            CASE EB.SystemTables.getIdNew()[1,2] EQ 'FT'
                Y.FLAG.FT.REVERSADO = ''
                ID.FT.TXN = EB.SystemTables.getIdNew()
                GOSUB LEE.REC.FT
                IF REC.FT EQ '' THEN
                    ID.FT.TXN = EB.SystemTables.getIdNew() : ";1"
                    GOSUB LEE.REC.FT
                    IF REC.FT NE '' THEN
                        Y.FLAG.FT.REVERSADO = 1       ;* BANDERA PARA OMITIR REVERSO DE FT EN APLICACION
                    END
                END

            CASE EB.SystemTables.getIdNew()[1,4] EQ 'ACLK'
                Y.FLAG.ACLK.REVERSADO = ''
                ID.ACLK = EB.SystemTables.getIdNew()
                GOSUB LEE.REC.ACLK
                IF REC.ACLK EQ '' THEN      ;* SE LEE REGISTRO ACLK DESDE HIS AL YA ESTAR REVERSADO
                    ID.ACLK = EB.SystemTables.getIdNew() : ";1"
                    GOSUB LEE.REC.ACLK
                    IF REC.ACLK NE '' THEN
                        Y.FLAG.ACLK.REVERSADO = 1     ;* BANDERA PARA OMITIR REVERSO DE ACLK EN APLICACION
                    END
                END

        END CASE

        IF (REC.FT NE '') OR (REC.ACLK NE '') OR (Y.GUARDA.AUTHID.REVE EQ 'SI') THEN
            BEGIN CASE
                CASE Y.VERSION.APL EQ ",APLICA.COMPRA.MC"
                    Y.TIPO.MOVIMIENTO = "COMPRA"
                    Y.ACCION = "APLICADA"
                    GOSUB VALIDA.COMPRA.MC

                CASE Y.VERSION.APL EQ ",REVERSO.COMPRA.MC"
                    Y.TIPO.MOVIMIENTO = "COMPRA"
                    Y.CODI.MOVIMIENTO = "POS"
                    Y.ACCION = "REVERSADA"
                    TRANSACTION.TYPE = "ACTD"
                    GOSUB VALIDA.REVE.PARCIAL.TOTAL

                CASE Y.VERSION.APL EQ ",APLICA.RETIRO.ATM.MC"
                    Y.TIPO.MOVIMIENTO = "RETIRO"
                    Y.ACCION = "APLICADO"
                    GOSUB APLICACION.RETIRO.ATM.MC

                CASE Y.VERSION.APL EQ ",REVERSO.ATM.MC"
                    Y.TIPO.MOVIMIENTO = "RETIRO"
                    Y.CODI.MOVIMIENTO = "ATM"
                    Y.ACCION = "REVERSADO"
                    TRANSACTION.TYPE = "ACAT"
                    GOSUB REVE.BLOQ.GUARDA.AUTHID.REVE

                CASE Y.VERSION.APL EQ ",BA.ATM.CW.OWN.REV.PAR"  ;* VISA
                    GOSUB APL.COMPRA.RETIRO.VISA

            END CASE

            IF V$ERROR EQ 1 THEN
                EB.ErrorProcessing.Err()
                RETURN
            END
        END
    END

*BEGIN CASE
*CASE R.NEW(V-8)[1,3] = "INA"        ;* Record status
*REM > CALL XX.AUTHORISATION
*CASE R.NEW(V-8)[1,3] = "RNA"        ;* Record status
*REM > CALL XX.REVERSAL
*END CASE

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXISTE.REVE:
*-----------------------------------------------------------------------------
    
    Y.REG.REVE = ''
    EB.DataAccess.FRead(FN.ABC.PEND.GALILEO, AUTH.ID.ACLK, Y.REG.REVE, F.ABC.PEND.GALILEO, ERR.AUTHID.PEND)
    IF Y.REG.REVE THEN
        Y.EXISTE.REVE = 1
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXISTE.ORIG.AUTHID:
*-----------------------------------------------------------------------------

    Y.EXISTE.AUTH.ID = ''
    EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, Y.AUTH.ID.ORIGINAL, REC.AUTHID, F.ABC.CONCAT.GALILEO, ERR.AUTHID)
    IF REC.AUTHID EQ '' THEN
        Y.ERROR.EXISTE.ORIG.AUTHID = "NO EXISTE BLOQUEO PARA AUTH.ID " : Y.AUTH.ID.ORIGINAL
        Y.EXISTE.AUTH.ID = 'NO'
        RETURN
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXISTE.REVE.PAR.PEND:
*-----------------------------------------------------------------------------

    Y.EXISTE.AUTH.ID.REVE.PAR = '' ; REC.AUTHID.PEND = ''
    EB.DataAccess.FRead(FN.ABC.PEND.GALILEO, Y.AUTH.ID.ORIGINAL, REC.AUTHID.PEND, F.ABC.PEND.GALILEO, ERR.AUTHID.PEND)
    IF REC.AUTHID.PEND EQ '' THEN
        Y.EXISTE.AUTH.ID.REVE.PAR = 'NO'
        RETURN
    END

RETURN
*-------------------------------------
VALIDA.COMPRA.MC:
*-------------------------------------

    Y.TIPO.COMPRA.MC = ''     ;* NACIONAL O INTERNACIONAL
    PORC.FLUCTUACION = ''
    IF ACLK.ORIG.CURRENCY MATCHES "MXN" : @VM : "484" : @VM : "" THEN
        Y.TIPO.COMPRA.MC = "NAL"
    END ELSE
        Y.TIPO.COMPRA.MC = "INTERNAL"
    END
    A.AMOUNT = A.DEBIT.AMOUNT

    BEGIN CASE
        CASE Y.TIPO.COMPRA.MC EQ "NAL"
            TIPO.CAMBIO = ACLK.TIPO.CAMBIO
            PORC.FLUCTUACION = TIPO.CAMBIO / ACLK.TIPO.CAMBIO
            GOSUB GENERA.COMPRA.MC
            IF V$ERROR EQ 1 THEN
                RETURN
            END

        CASE Y.TIPO.COMPRA.MC EQ "INTERNAL"
            TIPO.CAMBIO = A.DEBIT.AMOUNT / A.ORIG.AMOUNT
            PORC.FLUCTUACION = TIPO.CAMBIO / ACLK.TIPO.CAMBIO
            IF A.ORIG.AMOUNT EQ ACLK.ORIG.AMOUNT THEN ;* MONTO.ORIG BLOQUEO Y MONTO.ORIG APLICACION SON IGUALES
                IF A.DEBIT.AMOUNT LE LOC.AMT THEN     ;*MONTO APLICACION < MONTO BLOQUEO ==> APLICAR
                    PORC.FLUCTUACION = DROUND(PORC.FLUCTUACION, 3)
                    GOSUB GENERA.COMPRA.MC
                END
                IF V$ERROR EQ 1 THEN
                    RETURN
                END

                IF A.DEBIT.AMOUNT GT LOC.AMT THEN     ;*MONTO APLICACION GT MONTO BLOQUEO ==> VALIDAR PORC.FLUCTUACION
                    IF PORC.FLUCTUACION GT 1.005 THEN
                        A.AMOUNT.PERDI = '' ; TIPO.CAMBIO.APLICADO = ''
                        TIPO.CAMBIO.APLICADO = (TIPO.CAMBIO * 1.005) / PORC.FLUCTUACION
                        A.AMOUNT.PERDI = A.DEBIT.AMOUNT
                        A.DEBIT.AMOUNT = A.ORIG.AMOUNT * TIPO.CAMBIO.APLICADO
                        A.DEBIT.AMOUNT = DROUND(A.DEBIT.AMOUNT, 2)
                        A.AMOUNT.PERDI = A.AMOUNT.PERDI - A.DEBIT.AMOUNT
                        PORC.FLUCTUACION = 1.005
                        A.AMOUNT = A.DEBIT.AMOUNT     ;* - LOC.AMT
                        GOSUB GENERA.COMPRA.MC
                    END ELSE      ;* PORCENTAJE FLUCTUACION MENOR < 1.005 ==> APLICAR POR MONTO
                        PORC.FLUCTUACION = DROUND(PORC.FLUCTUACION, 3)
                        GOSUB GENERA.COMPRA.MC
                    END
                    IF V$ERROR EQ 1 THEN
                        RETURN
                    END
                END
            END ELSE    ;* MONTO.ORIG BLOQUEO Y MONTO.ORIG APLICACION NO SON IGUALES
                A.AMOUNT = A.DEBIT.AMOUNT
                PORC.FLUCTUACION = DROUND(PORC.FLUCTUACION, 3)
                GOSUB GENERA.COMPRA.MC
                IF V$ERROR EQ 1 THEN
                    RETURN
                END
            END

    END CASE

RETURN
*-------------------------------------
APLICACION.RETIRO.ATM.MC:
*-------------------------------------

    Y.VERSION.FT = "FUNDS.TRANSFER,RETIRO.ATM.MC"
    COMMISSION.CODE = '' ; COMMISSION.TYPE = '' ; COMMISSION.AMT = ''
    DEBIT.ACCT.NO = '' ; DEBIT.CURRENCY = '' ; PAYMENT.DETAILS = '';EXTEND.INFO=''
    A.AMOUNT = A.DEBIT.AMOUNT

    IF A.DEBIT.AMOUNT EQ 0 THEN         ;* APLICACIONES POR 0 SE CONSIDERAN REVERSOS
        Y.CODI.MOVIMIENTO = "ATM"
        Y.ACCION = "REVERSADO"
        GOSUB REVE.BLOQ.GUARDA.AUTHID.REVE
        RETURN
    END

    IF ACLK.COMISION NE '' THEN
        ACLK.TIPO.CAMBIO = (LOC.AMT - ACLK.COMISION ) / ACLK.ORIG.AMOUNT
    END

    IF A.COMISION EQ '' THEN
        A.COMISION = 0
    END

    IF (A.DEBIT.AMOUNT NE '') AND (A.ORIG.AMOUNT NE '') THEN
        TIPO.CAMBIO = (A.DEBIT.AMOUNT - A.COMISION) / A.ORIG.AMOUNT
    END
    Y.SALDO.INSUFICIENTE = ''

    IF V$ERROR EQ 1 THEN
        RETURN
    END

    IF Y.SALDO.INSUFICIENTE EQ 1 THEN
        Y.AUTH.ID.PEND = ''
        Y.AUTH.ID.PEND = AUTH.ID.ACLK
        Y.ID.ACLK = EB.SystemTables.getIdNew()
        Y.ESTATUS.GUARDA.PEND = "PENDIENTE"
        Y.MSG.ERR = "SALDO INSUFICIENTE"
        GOSUB GUARDA.APLC.PENDIENTE
        EB.SystemTables.setE("Saldo Insuficiente")
        V$ERROR = 1
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        IF Y.FLAG.ACLK.REVERSADO EQ 1 THEN
            Y.RESULT = 1
        END ELSE
            GOSUB REVERSA.BLOQUEO.ACLK
        END
        IF Y.RESULT EQ 1 THEN

            DEBIT.ACCT.NO = ID.ACC
            DEBIT.CURRENCY = "MXN"
            PAYMENT.DETAILS = J.DESC
            EXTEND.INFO= J.DESC.DET
            GOSUB GENERA.FT.NUEVO.ATM
            IF A.RESULT NE 1 THEN
                EB.SystemTables.setE("ERROR AL GENERAR: " : ID.FT : " " : A.ERR.MSG)
                V$ERROR = 1
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END ELSE
            EB.SystemTables.setE("ERROR AL REVERSAR: " : EB.SystemTables.getIdNew())
            V$ERROR = 1
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

RETURN
*-------------------------------------
VALIDA.REVE.PARCIAL.TOTAL:
*-------------------------------------

    Y.MONTO.ORIGEN.REVE.PAR = '' ; Y.MONTO.REVERSO.PARCIAL = '' ; Y.MONTO.DEBIT = ''
    Y.MONTO.REVERSO.PARCIAL = A.MONTO.REV.PARCIAL
    Y.MONTO.ORIGEN.REVE.PAR = A.ORIG.AMOUNT
    Y.MONTO.DEBIT = A.DEBIT.AMOUNT

    IF Y.MONTO.REVERSO.PARCIAL EQ LOC.AMT THEN    ;* REVERSO TOTAL

        Y.ORIG.AUTHID = Y.AUTHID.NUEVO.REVE

        Y.AUTHID.REVERSO = Y.ORIG.AUTHID
        GOSUB REVE.BLOQ.GUARDA.AUTHID.REVE
        IF V$ERROR EQ 1 THEN
            RETURN
        END
        Y.AUTH.ID.CONCAT = Y.AUTHID.NUEVO.REVE
        Y.REVE.AUTHID = Y.ORIG.AUTHID
        Y.CONCAT.ESTATUS = "ASOCIADO A REVE"
        GOSUB GUARDA.AUTHID.CONCAT
    END ELSE        ;* REVERSO PARCIAL, MONTO.REV.PARCIAL MAYOR Y MENOR, ACTUALIZAR ACLK

        IF (Y.MONTO.ORIGEN.REVE.PAR NE '') AND (Y.MONTO.REVERSO.PARCIAL NE '0') THEN      ;* REVERSO PARCIAL

            AUTH.ID.ACLK.COMPRA = Y.ORIG.AUTHID
            AUTH.ID.CONCAT = AUTH.ID.ACLK.COMPRA
            Y.MONTO.ACTUALIZACION.ACLK = ''

            IF Y.MONTO.REVERSO.PARCIAL GT LOC.AMT THEN
                EB.SystemTables.setE("MONTO REVERSO PARCIAL EXCEDE BLOQUEO ORIGINAL")
                V$ERROR = 1
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

            IF Y.MONTO.REVERSO.PARCIAL LT LOC.AMT THEN
                Y.MONTO.ACTUALIZACION.ACLK = LOC.AMT - Y.MONTO.REVERSO.PARCIAL
                Y.MONTO.ORIGEN.ACTUALIZA.ACLK = ACLK.ORIG.AMOUNT - Y.MONTO.ORIGEN.REVE.PAR
            END

            A.DEBIT.AMOUNT = Y.MONTO.ACTUALIZACION.ACLK
            A.ORIG.AMOUNT = Y.MONTO.ORIGEN.ACTUALIZA.ACLK

            GOSUB ACTUALIZA.BLOQUEO.ACLK

            IF Y.RESULT EQ 1 THEN
                A.RESULT = Y.RESULT
                EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.DebitAmount, "")
                EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigAmount, Y.MONTO.ORIGEN.ACTUALIZA.ACLK)
                EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.AuthId, AUTH.ID.ACLK)
                EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigAuthId, Y.AUTHID.NUEVO.REVE)
                EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())
            END ELSE
                EB.SystemTables.setE("ERROR AL ACTUALIZAR: " : EB.SystemTables.getIdNew())
                V$ERROR = 1
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            Y.AUTH.ID.CONCAT = Y.AUTHID.NUEVO.REVE
            Y.REVE.AUTHID = Y.ORIG.AUTHID
            Y.CONCAT.ESTATUS = "REVERSO PARCIAL"
            GOSUB GUARDA.AUTHID.CONCAT
        END
    END

RETURN
*-------------------------------------
REVE.BLOQ.GUARDA.AUTHID.REVE:
*-------------------------------------
    
    IF Y.GUARDA.AUTHID.REVE EQ "SI" THEN
        Y.AUTH.ID.CONCAT = AUTH.ID.ACLK
        Y.REVE.AUTHID = Y.ORIG.AUTHID
        Y.CONCAT.ESTATUS = "REVERSADO SIN BLOQ"
        GOSUB GUARDA.AUTHID.CONCAT
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Status, "REVERSADO")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.AuthId, AUTH.ID.ACLK)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigAuthId, Y.ORIG.AUTHID)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.MsgError, Y.MSG.REV.PREV.BLOQ)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())
        A.RESULT = 1
        RETURN
    END

    Y.AUTHID.REVERSO = Y.ORIG.AUTHID
    Y.FECHA.MODIFICACION = ''
    Y.FECHA.MODIFICACION = Y.FECHA.APL
    GOSUB REVERSA.BLOQUEO.ACLK

    IF Y.RESULT EQ 1 THEN
        Y.TIPO.MOVIMIENTO = "BLOQUEO " : Y.CODI.MOVIMIENTO
        Y.ACCION = "REVE"
        GOSUB UPDATE.AUTHID.FT
        A.RESULT = Y.RESULT
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.AuthId, AUTH.ID.ACLK)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigAuthId, Y.AUTHID.REVERSO)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Status, "REVERSADO")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())
    END ELSE
        EB.SystemTables.setE("ERROR AL REVERSAR: " : EB.SystemTables.getIdNew())
        V$ERROR = 1
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN
*------------------------------------- ;*CAJERO COMPRAS VISA
APL.COMPRA.RETIRO.VISA:
*-------------------------------------
*
    IF EB.SystemTables.getIdNew()[1,2] EQ 'FT' THEN
        Y.VERSION.FT = "FUNDS.TRANSFER,BA.ATM.CW.OWN"
        IF Y.FLAG.FT.REVERSADO EQ '' THEN
            GOSUB VALIDA.FMT.FT
            IF V$ERROR EQ 1 THEN
                RETURN
            END
            GOSUB REVERSA.FT.ATM
            IF Y.RESULT EQ 1 THEN
                GOSUB GENERA.FT.NUEVO.ATM
            END ELSE
                EB.SystemTables.setE("ERROR AL REVERSAR :":Y.ERR.MSG)
                V$ERROR = 1
                RETURN
            END
        END ELSE
            GOSUB VALIDA.FMT.FT
            IF V$ERROR EQ 1 THEN
                RETURN
            END
            AbcAccount.SapCheckBalCashWthd(DEBIT.ACCT.NO,A.DEBIT.AMOUNT,Y.COMISION,YOUT)
            IF YOUT THEN
                EB.SystemTables.setE(YOUT)
                V$ERROR = 1
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            GOSUB GENERA.FT.NUEVO.ATM
        END
    END

    IF EB.SystemTables.getIdNew()[1,4] EQ 'ACLK' THEN
        Y.VERSION.FT = "FUNDS.TRANSFER,ABC.POS"
        GOSUB VALIDA.FMT.ACLK
        IF V$ERROR EQ 1 THEN
            RETURN
        END
        IF (LOC.AMT EQ A.DEBIT.AMOUNT) OR (FLAG.APLICA.INTERNACL EQ 1) THEN     ;* COMPRAS VISA
            IF Y.FLAG.ACLK.REVERSADO EQ 1 THEN
                Y.RESULT = 1
            END ELSE
                GOSUB REVERSA.BLOQUEO.ACLK
            END
            IF Y.RESULT EQ 1 THEN
                AbcAccount.SapCheckBalCashWthd(ID.ACC, A.AMOUNT, Y.COMISION, YOUT)
                IF YOUT THEN
                    EB.SystemTables.setE(YOUT)
                    V$ERROR = 1
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
                GOSUB GENERA.FT.COMPRA
                IF V$ERROR EQ 1 THEN
                    RETURN
                END
            END ELSE
                EB.SystemTables.setE("ERROR AL REVERSAR :":Y.ERR.MSG)
                V$ERROR = 1
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END ELSE
            EB.SystemTables.setAf(AbcTempGeneFt.DebitAmount)
            EB.SystemTables.setE("ERROR DE MONTO: EL MONTO NO CORRESPONDE AL MONTO DEL BLOQUEO ":LOC.AMT)
            V$ERROR = 1
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

RETURN
*-------------------------------------
VALIDA.FMT.FT:
*-------------------------------------
*
    IF (FT.ORIG.AMOUNT NE '') AND (FT.ORIG.CURRENCY NE '') THEN
        IF (A.ORIG.AMOUNT NE '') AND (A.ORIG.CURRENCY NE '') THEN
            IF FT.COMISION.CAJ EQ '' THEN
                IF A.COMISION NE '' THEN
                    EB.SystemTables.setAf(AbcTempGeneFt.Comision)
                    EB.SystemTables.setE("NO APLICA COMISION")
                    V$ERROR = 1
                    RETURN
                END ELSE
                    TIPO.CAMBIO = (A.DEBIT.AMOUNT) / A.ORIG.AMOUNT
                    TIPO.CAMBIO = DROUND(TIPO.CAMBIO, 2)
                END
            END
            IF FT.COMISION.CAJ NE '' THEN
                IF A.COMISION EQ '' THEN
                    EB.SystemTables.setAf(AbcTempGeneFt.Comision)
                    EB.SystemTables.setE("NO SE INGRESO COMISION")
                    V$ERROR = 1
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
                TIPO.CAMBIO = (A.DEBIT.AMOUNT - A.COMISION) / A.ORIG.AMOUNT
                TIPO.CAMBIO = DROUND(TIPO.CAMBIO, 2)
            END
        END ELSE
            IF (A.ORIG.AMOUNT EQ '') OR (A.ORIG.CURRENCY EQ '') THEN
                EB.SystemTables.setAf(AbcTempGeneFt.OrigAmount)
                EB.SystemTables.setE("NO SE INGRESO MONEDA Y MONTO ORIGEN")
                V$ERROR = 1
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END ELSE
        IF (FT.ORIG.AMOUNT EQ '') AND (FT.ORIG.CURRENCY EQ '') AND (FT.TIPO.CAMBIO EQ '') THEN
            IF (A.ORIG.AMOUNT NE '') OR (A.ORIG.CURRENCY NE '') OR (A.COMISION NE '') THEN
                EB.SystemTables.setAf(AbcTempGeneFt.OrigAmount)
                EB.SystemTables.setE("RETIRO ORIGINAL NO CONTIENE MONEDA Y MONTO ORIGEN")
                V$ERROR = 1
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END

RETURN
*-------------------------------------
VALIDA.FMT.ACLK:
*-------------------------------------
*
    IF (ACLK.ORIG.AMOUNT NE '') AND (ACLK.ORIG.CURRENCY NE '') THEN
        IF (A.ORIG.AMOUNT NE '') AND (A.ORIG.CURRENCY NE '') THEN
            FLAG.APLICA.INTERNACL = ''
            TIPO.CAMBIO = A.DEBIT.AMOUNT / A.ORIG.AMOUNT
            PORC.FLUCTUACION = TIPO.CAMBIO / ACLK.TIPO.CAMBIO

            IF PORC.FLUCTUACION GT 1.005 THEN
                A.AMOUNT.PERDI = '' ; TIPO.CAMBIO.APLICADO = ''

                TIPO.CAMBIO.APLICADO = (TIPO.CAMBIO * 1.005) / PORC.FLUCTUACION
                A.AMOUNT.PERDI = A.DEBIT.AMOUNT
                A.DEBIT.AMOUNT = A.ORIG.AMOUNT * TIPO.CAMBIO.APLICADO
                A.DEBIT.AMOUNT = DROUND(A.DEBIT.AMOUNT, 2)
                A.AMOUNT.PERDI = A.AMOUNT.PERDI - A.DEBIT.AMOUNT
                PORC.FLUCTUACION = 1.005
                FLAG.APLICA.INTERNACL = 1
            END ELSE
                FLAG.APLICA.INTERNACL = 1
            END
            PORC.FLUCTUACION = DROUND(PORC.FLUCTUACION, 3)
        END ELSE
            IF (A.ORIG.AMOUNT EQ '') OR (A.ORIG.CURRENCY EQ '') THEN
                EB.SystemTables.setAf(AbcTempGeneFt.OrigAmount)
                EB.SystemTables.setE("NO SE INGRESO MONEDA Y MONTO ORIGEN")
                V$ERROR = 1
                RETURN
            END
        END
    END ELSE
        IF (ACLK.ORIG.AMOUNT EQ '') AND (ACLK.ORIG.CURRENCY EQ '') THEN
            IF (A.ORIG.AMOUNT NE '') OR (A.ORIG.CURRENCY NE '') THEN
                EB.SystemTables.setAf(AbcTempGeneFt.OrigAmount)
                EB.SystemTables.setE("BLOQUEO ORIGINAL NO CONTIENE MONEDA Y MONTO ORIGEN")
                V$ERROR = 1
                RETURN
            END
        END
    END

RETURN
*-------------------------------------
GENERA.COMPRA.MC:
*-------------------------------------

    Y.VERSION.FT = "FUNDS.TRANSFER,ABC.POS"
    FINDSTR "nan" IN PORC.FLUCTUACION SETTING POS THEN
        PORC.FLUCTUACION = 0
    END
    Y.SALDO.INSUFICIENTE = ''


    IF V$ERROR EQ 1 THEN
        RETURN
    END

    IF Y.SALDO.INSUFICIENTE EQ 1 THEN
        Y.AUTH.ID.PEND = ''
        IF A.DEBIT.AMOUNT NE LOC.AMT THEN         ;* PARA EVITAR RESPUESTA -1 DEL OFS
            GOSUB ACTUALIZA.BLOQUEO.ACLK
        END
        Y.AUTH.ID.PEND = AUTH.ID.ACLK
        Y.ID.ACLK = EB.SystemTables.getIdNew()
        Y.ESTATUS.GUARDA.PEND = "PENDIENTE"
        Y.MSG.ERR = "SALDO INSUFICIENTE"
        GOSUB GUARDA.APLC.PENDIENTE
        EB.SystemTables.setE("Saldo Insuficiente")
        V$ERROR = 1
    END ELSE
        IF Y.FLAG.ACLK.REVERSADO EQ 1 THEN
            Y.RESULT = 1
        END ELSE
            GOSUB REVERSA.BLOQUEO.ACLK
        END
        IF Y.RESULT EQ 1 THEN
            GOSUB GENERA.FT.COMPRA
            IF A.RESULT NE 1 THEN
                EB.SystemTables.setE("ERROR AL GENERAR: " : ID.FT : " " : A.ERR.MSG)
                V$ERROR = 1
                RETURN
            END
        END ELSE
            EB.SystemTables.setE("ERROR AL REVERSAR: " : EB.SystemTables.getIdNew())
            V$ERROR = 1
            RETURN
        END
    END

RETURN
*------------------FRAGMENTOS DE USO GRAL-------------------
*-------------------------------------
LEE.REC.FT:
*-------------------------------------
*
	EB.DataAccess.FRead(FN.FT, ID.FT.TXN, REC.FT, F.FT, ERR.FT)
    IF REC.FT THEN
        TRANSACTION.TYPE  = REC.FT<FT.Contract.FundsTransfer.TransactionType>
        COMMISSION.CODE = REC.FT<FT.Contract.FundsTransfer.CommissionCode>
        COMMISSION.TYPE = REC.FT<FT.Contract.FundsTransfer.CommissionType>
        COMMISSION.AMT = REC.FT<FT.Contract.FundsTransfer.CommissionAmt>
        DEBIT.ACCT.NO = REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
        DEBIT.AMOUNT = REC.FT<FT.Contract.FundsTransfer.DebitAmount>
        DEBIT.CURRENCY = REC.FT<FT.Contract.FundsTransfer.DebitCurrency>
        PAYMENT.DETAILS = REC.FT<FT.Contract.FundsTransfer.PaymentDetails,1>

        FT.ORIG.AMOUNT = REC.FT<FT.Contract.FundsTransfer.LocalRef, POS.ORIG.MONTO>
        FT.ORIG.CURRENCY = REC.FT<FT.Contract.FundsTransfer.LocalRef, POS.ORIG.CURRN>
        FT.TIPO.CAMBIO = REC.FT<FT.Contract.FundsTransfer.LocalRef, POS.TIPO.CAMB>
        FT.COMISION.CAJ = REC.FT<FT.Contract.FundsTransfer.LocalRef, POS.COMI.CAJERO>
    END

RETURN
*-------------------------------------
LEE.REC.ACLK:
*-------------------------------------
	
	EB.DataAccess.FRead(FN.ACLK, ID.ACLK, REC.ACLK, F.ACLK, ERR.ACLK)
    IF REC.ACLK THEN

        TRANSACTION.TYPE = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.UNIQUE.ID>
        Y.TIPO.BLOQUEO = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.AUTH.CODE>
        ID.ACC = REC.ACLK<AC.AccountOpening.LockedEvents.LckAccountNumber>
        J.DESC = REC.ACLK<AC.AccountOpening.LockedEvents.LckDescription>
        LOC.AMT = REC.ACLK<AC.AccountOpening.LockedEvents.LckLockedAmount>


        ACLK.ORIG.AMOUNT = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ORIG.MONTO.AC>
        ACLK.ORIG.CURRENCY = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ORIG.CURRN.AC>
        ACLK.TIPO.CAMBIO = LOC.AMT / ACLK.ORIG.AMOUNT       ;*SE VUELVE A CALCULAR TIPO DE CAMBIO DE BLOQUEO
        ACLK.MCC = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.MCC>


        ACLK.COMISION = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ACLK.COMIS>

        ACLK.DATE=REC.ACLK<AC.AccountOpening.LockedEvents.LckFromDate>
        J.DESC=EREPLACE (J.DESC,CHAR(34),"")
        J.DESC.DET= J.DESC:"*FECHA OPERACION*":ACLK.DATE
        J.DESC=J.DESC[1,35]


    END
RETURN
*-------------------------------------
VALIDA.ORIG.AUTH.ID:
*-------------------------------------

    REC.ORIG.AUTH.ID = ''
    IF Y.ORIG.AUTHID EQ AUTH.ID.ACLK THEN
        EB.SystemTables.setE("ORIG.AUTH.ID Y AUTH.ID RECIBIDOS SON IGUALES: " : Y.ORIG.AUTHID)
        V$ERROR = 1
        RETURN
    END
    EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, Y.ORIG.AUTHID, REC.ORIG.AUTH.ID, F.ABC.CONCAT.GALILEO, ERR.AUTHID)
    IF REC.ORIG.AUTH.ID THEN
        EB.SystemTables.setE("AUTH.ID DE REVERSO YA REGISTRADO")
        V$ERROR = 1
        RETURN
    END

    Y.AUTH.ID.CONCAT = Y.ORIG.AUTHID
    Y.REVE.AUTHID = ''
    Y.CONCAT.ESTATUS = "ASOCIADO A REVE"
    GOSUB GUARDA.AUTHID.CONCAT

RETURN
*-------------------------------------
GUARDA.AUTHID.CONCAT:
*-------------------------------------

    REC.AUTH.ID = ''
    REC.AUTH.ID<AbcTable.AbcConcatGalile.Fecha> = Y.FECHA.APL
    REC.AUTH.ID<AbcTable.AbcConcatGalile.ReveId> = Y.REVE.AUTHID
    REC.AUTH.ID<AbcTable.AbcConcatGalile.Estatus> = Y.CONCAT.ESTATUS
    EB.DataAccess.FWrite(FN.ABC.CONCAT.GALILEO,Y.AUTH.ID.CONCAT,REC.AUTH.ID)

RETURN
*-------------------------------------
ACTUALIZA.BLOQUEO.ACLK:
*-------------------------------------

    Y.APLICACION.OFS = 'AC.LOCKED.EVENTS'
    Y.APL.OFSFUNCTION = 'I'
    Y.PROCESS = 'PROCESS'
    Y.VERSION = ',COMPRA.MC'
    Y.ID            = ''
    Y.ID.TRANSACTION  = ID.ACLK
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    R.ACLK = ''
    R.ACLK<AC.AccountOpening.LockedEvents.LckLockedAmount>  = A.DEBIT.AMOUNT
    R.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ORIG.MONTO.AC> = A.ORIG.AMOUNT
    
    
    
    
    EB.Foundation.OfsBuildRecord(Y.APLICACION.OFS,Y.APL.OFSFUNCTION,Y.PROCESS,Y.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.TRANSACTION,R.ACLK,Y.OFS.REQUEST)
    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
*    EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)

    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
*EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)

*   Y.RESULT = FIELD(theResponse,",",1)
*   Y.RESULT = FIELD(Y.RESULT,"/",3)
*   Y.ERR.MSG = FIELD(theResponse,",",2)
    Y.ERR.MSG = Error
    IF Y.ERR.MSG EQ '' THEN
        Y.RESULT = 1
    END


RETURN
*-------------------------------------
GUARDA.APLC.PENDIENTE:
*-------------------------------------

    Y.ID.PENDIENTE = '' ; Y.TIPO.TRANS = '' ; Y.DESC.TRANS = '' ; Y.ID.BLOQUEO = ''
    Y.FECHA.SYS = '' ; Y.HORA.SYS = '' ; REC.PEND.GALI = '' ; Y.ESTATUS.PENDIENTE = ''
    Y.MENSAJE.ERROR = ''
    Y.ID.BLOQUEO = Y.ID.ACLK
    Y.ID.PENDIENTE = Y.AUTH.ID.PEND
    Y.ESTATUS.PENDIENTE = Y.ESTATUS.GUARDA.PEND
    Y.MENSAJE.ERROR = Y.MSG.ERR
    Y.FECHA.SYS = Y.FECHA.APL
    Y.HORA.SYS = OCONV(TIME(), 'MTS')

    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.TipoTrans> = TRANSACTION.TYPE
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.Descripcion> = Y.TIPO.BLOQUEO
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.CuentaCliente> = ID.ACC
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.MontoLocal> = A.DEBIT.AMOUNT
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.Comision> = A.COMISION
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.MontoOrig> = A.ORIG.AMOUNT
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.MonedaOrig> = A.ORIG.CURRENCY
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.AclkId> = Y.ID.BLOQUEO
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.FechaIngreso> = Y.FECHA.SYS
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.HoraIngreso> = Y.HORA.SYS
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.Estatus> = Y.ESTATUS.PENDIENTE
    REC.PEND.GALI<AbcTable.AbcPendientesGalileo.MsgError> = Y.MENSAJE.ERROR

    IF Y.SAVE.AUDIT.FLDS EQ 1 THEN
        YTIME = TIMEDATE()
        YTODAY = EB.SystemTables.getToday()
        REC.PEND.GALI<AbcTable.AbcPendientesGalileo.CurrNo> = "1"
        REC.PEND.GALI<AbcTable.AbcPendientesGalileo.Inputter> = EB.SystemTables.getOperator():"_REVPAR"        ;*"23_USERFYG03__OFS_BROWSERTC"
        REC.PEND.GALI<AbcTable.AbcPendientesGalileo.DateTime> = YTODAY[3,6]:YTIME[1,2]:YTIME[4,2]
        REC.PEND.GALI<AbcTable.AbcPendientesGalileo.Authoriser> = EB.SystemTables.getOperator():"_REVPAR"      ;*"23_USERFYG03_OFS_BROWSERTC"
        REC.PEND.GALI<AbcTable.AbcPendientesGalileo.CoCode> = "MX0010001"
        REC.PEND.GALI<AbcTable.AbcPendientesGalileo.DeptCode> = "901031003002003"
    END

    EB.DataAccess.FWrite(FN.ABC.PEND.GALILEO, Y.ID.PENDIENTE, REC.PEND.GALI)
    EB.TransactionControl.JournalUpdate("")

RETURN
*-------------------------------------
GENERA.FT.NUEVO.ATM:
*-------------------------------------
*
    Y.APLICACION.OFS = 'FUNDS.TRANSFER'
    Y.APL.OFSFUNCTION = 'I'
    Y.PROCESS = 'PROCESS'
    Y.VERSION = Y.VERSION.FT
    Y.ID            = ''
    Y.ID.TRANSACTION  = ''
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    R.FT = ''
    R.FT<FT.Contract.FundsTransfer.TransactionType> = TRANSACTION.TYPE
    R.FT<FT.Contract.FundsTransfer.DebitAcctNo> = DEBIT.ACCT.NO
    R.FT<FT.Contract.FundsTransfer.DebitAmount> = A.DEBIT.AMOUNT
    R.FT<FT.Contract.FundsTransfer.DebitCurrency> = DEBIT.CURRENCY
    R.FT<FT.Contract.FundsTransfer.PaymentDetails,1> = PAYMENT.DETAILS
    R.FT<FT.Contract.FundsTransfer.ExtendInfo> = J.DESC.DET

    IF (A.ORIG.AMOUNT EQ '') AND (A.ORIG.CURRENCY EQ '') THEN
        R.FT<FT.Contract.FundsTransfer.PaymentDetails,4> = "MX"
    END
    R.FT<FT.Contract.FundsTransfer.CommissionCode> = COMMISSION.CODE
    R.FT<FT.Contract.FundsTransfer.CommissionType> = COMMISSION.TYPE
    R.FT<FT.Contract.FundsTransfer.CommissionAmt> = COMMISSION.AMT

    IF TIPO.CAMBIO NE '' THEN
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.ORIG.MONTO> = A.ORIG.AMOUNT
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.ORIG.CURRN> = A.ORIG.CURRENCY
    END

    IF A.COMISION NE '' THEN
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.COMI.CAJERO> = A.COMISION
    END

    IF AUTH.ID.ACLK NE '' THEN
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.AUTH.ID> = AUTH.ID.ACLK
    END
    GOSUB OBTENER.ID.FT
    
    Y.ID.TRANSACTION = Y.ID.FT
    EB.Foundation.OfsBuildRecord(Y.APLICACION.OFS,Y.APL.OFSFUNCTION,Y.PROCESS,Y.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.TRANSACTION,R.FT,Y.OFS.REQUEST)
    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
*  EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
*EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)

*   Y.RESULT = FIELD(theResponse,",",1)
*   Y.RESULT = FIELD(Y.RESULT,"/",3)
*   Y.ERR.MSG = FIELD(theResponse,",",2)
    A.ERR.MSG = Error
    IF A.ERR.MSG EQ '' THEN
        A.RESULT = 1
    END
*   A.RESULT = FIELD(theResponse,",",1)
    ID.FT = Y.ID.FT
*   A.RESULT = FIELD(A.RESULT,"/",3)
*   A.ERR.MSG = FIELD(theResponse,",",2)

    IF A.RESULT EQ 1 THEN
        IF AUTH.ID.ACLK NE '' THEN
            ID.FT.AUTH.ID = ID.FT
            ID.ACLK.AUTH  = EB.SystemTables.getIdNew()
            GOSUB UPDATE.AUTHID.FT
        END

        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FtGenerado, ID.FT)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Status, "GENERADO")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())

        IF AUTH.ID.ACLK NE '' THEN
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.AuthId, AUTH.ID.ACLK)
        END

        IF TIPO.CAMBIO NE '' THEN
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigAmount, A.ORIG.AMOUNT)
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigCurrency, A.ORIG.CURRENCY)
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.TipoCamb, DROUND(TIPO.CAMBIO, 2))
        END

        IF A.COMISION NE '' THEN
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Comision, A.COMISION)
        END

        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.MsgError, "")
    END ELSE
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Status, "REVERSADO")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.MsgError, A.ERR.MSG)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FtGenerado, "")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.DebitAmount, "")
    END

RETURN
*-------------------------------------;*
GENERA.FT.COMPRA:
*-------------------------------------
    
    Y.APLICACION.OFS = 'FUNDS.TRANSFER'
    Y.APL.OFSFUNCTION = 'I'
    Y.PROCESS = 'PROCESS'
    Y.VERSION = Y.VERSION.FT
    Y.ID            = ''
    Y.ID.TRANSACTION  = ''
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    R.FT = ''
    R.FT<FT.Contract.FundsTransfer.TransactionType> = TRANSACTION.TYPE
    R.FT<FT.Contract.FundsTransfer.DebitAcctNo> = ID.ACC
    R.FT<FT.Contract.FundsTransfer.DebitAmount> = A.DEBIT.AMOUNT
    R.FT<FT.Contract.FundsTransfer.DebitCurrency> = "MXN"
    R.FT<FT.Contract.FundsTransfer.PaymentDetails,1> = J.DESC
    R.FT<FT.Contract.FundsTransfer.ExtendInfo> = J.DESC.DET

    IF (A.ORIG.AMOUNT EQ '') AND (A.ORIG.CURRENCY EQ '') THEN
        R.FT<FT.Contract.FundsTransfer.PaymentDetails,4> = "MX"
    END
    R.FT<FT.Contract.FundsTransfer.CommissionCode> = "DEBIT PLUS CHARGES"

    IF TIPO.CAMBIO NE '' THEN
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.ORIG.MONTO> = A.ORIG.AMOUNT
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.ORIG.CURRN> = A.ORIG.CURRENCY
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.PORC.FLUC> = PORC.FLUCTUACION
    END

    IF ACLK.MCC NE '' THEN
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.MCC.FT> = ACLK.MCC
    END

    IF AUTH.ID.ACLK NE '' THEN
        R.FT<FT.Contract.FundsTransfer.LocalRef, POS.AUTH.ID> = AUTH.ID.ACLK
    END

    GOSUB OBTENER.ID.FT
    
    Y.ID.TRANSACTION = Y.ID.FT
    EB.Foundation.OfsBuildRecord(Y.APLICACION.OFS,Y.APL.OFSFUNCTION,Y.PROCESS,Y.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.TRANSACTION,R.FT,Y.OFS.REQUEST)
    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
    

*    EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
*EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)

*   Y.RESULT = FIELD(theResponse,",",1)
*   Y.RESULT = FIELD(Y.RESULT,"/",3)
*   Y.ERR.MSG = FIELD(theResponse,",",2)
    A.ERR.MSG = Error
    IF A.ERR.MSG EQ '' THEN
        A.RESULT = 1
    END
*  A.RESULT = FIELD(theResponse,",",1)
    ID.FT = Y.ID.FT
*  A.RESULT = FIELD(A.RESULT,"/",3)
*  A.ERR.MSG = FIELD(theResponse,",",2)

    IF A.RESULT EQ 1 THEN
        IF AUTH.ID.ACLK NE '' THEN
            ID.FT.AUTH.ID = ID.FT
            ID.ACLK.AUTH  = EB.SystemTables.getIdNew()
            Y.AUTHID.REVERSO = Y.ORIG.AUTHID
            GOSUB UPDATE.AUTHID.FT
        END

        IF (CTA.DEBITO.POS NE '') AND (A.AMOUNT.PERDI NE '' ) THEN
            Y.APLICACION.OFS = 'FUNDS.TRANSFER'
            Y.APL.OFSFUNCTION = 'I'
            Y.PROCESS = 'PROCESS'
            Y.VERSION = ',ABC.POS'
            Y.ID            = ''
            Y.ID.TRANSACTION  = ''
            Y.NO.OF.AUTH    = 0
            Y.GTSMODE       = ''
            R.FT = ''
            R.FT<FT.Contract.FundsTransfer.CreditAcctNo> = CTA.COMPENSACION.POS
            R.FT<FT.Contract.FundsTransfer.ChargeCode> = "WAIVE"
            R.FT<FT.Contract.FundsTransfer.OrderingBank,1> = "MX0010001"
            R.FT<FT.Contract.FundsTransfer.DebitAcctNo> = CTA.DEBITO.POS
            R.FT<FT.Contract.FundsTransfer.DebitAmount> = A.AMOUNT.PERDI
            R.FT<FT.Contract.FundsTransfer.DebitCurrency> = "MXN"
            R.FT<FT.Contract.FundsTransfer.PaymentDetails,1> = "PERDIDA " : EB.SystemTables.getIdNew()
            R.FT<FT.Contract.FundsTransfer.LocalRef, POS.PORC.FLUC> = PORC.FLUCTUACION
            
            GOSUB OBTENER.ID.FT
    
            Y.ID.TRANSACTION = Y.ID.FT
            EB.Foundation.OfsBuildRecord(Y.APLICACION.OFS,Y.APL.OFSFUNCTION,Y.PROCESS,Y.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.TRANSACTION,R.FT,Y.OFS.REQUEST)
            theResponse = ""
            txnCommitted = ""
            options<1> = Y.OFS.SOURCE
* EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)
            EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
*EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)

*   Y.RESULT = FIELD(theResponse,",",1)
*   Y.RESULT = FIELD(Y.RESULT,"/",3)
*   Y.ERR.MSG = FIELD(theResponse,",",2)
            PER.A.ERR.MSG = Error
            IF PER.A.ERR.MSG EQ '' THEN
                PER.A.RESULT = 1
            END
*          PER.RESULT = FIELD(theResponse,",",1)
            PER.ID.FT = Y.ID.FT
*          PER.A.RESULT = FIELD(PER.RESULT,"/",3)
*          PER.A.ERR.MSG = FIELD(theResponse,",",2)

            IF PER.A.RESULT EQ 1 THEN
                ID.FT := "/PER:" : PER.ID.FT
            END ELSE
                IF PER.A.ERR.MSG NE '' THEN
                    ID.FT := "/PER:" : PER.A.ERR.MSG
                END
            END
        END

        IF AUTH.ID.ACLK NE '' THEN
            Y.AUTH.ID = AUTH.ID.ACLK
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.AuthId, Y.AUTH.ID)
        END

        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FtGenerado, ID.FT)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Status, "GENERADO")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())

        IF TIPO.CAMBIO NE '' THEN
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigAmount, A.ORIG.AMOUNT)
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.OrigCurrency, A.ORIG.CURRENCY)
            EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.TipoCamb, DROUND(TIPO.CAMBIO, 2))

            IF PORC.FLUCTUACION NE '' THEN
                EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.PorcFluc, PORC.FLUCTUACION)
            END

            IF A.AMOUNT.PERDI NE '' THEN
                EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.MontoPerdida, DROUND(A.AMOUNT.PERDI, 2))
            END
        END

        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.MsgError, "")
    END ELSE
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.Status, "REVERSADO")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.MsgError, A.ERR.MSG)
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FecReversa, TIMEDATE())
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.FtGenerado, "")
        EB.SystemTables.setRNew(AbcTable.AbcTempGeneFt.DebitAmount, "")
    END

RETURN
*-------------------------------------
REVERSA.BLOQUEO.ACLK:
*-------------------------------------
    Y.APLICACION.OFS = 'AC.LOCKED.EVENTS'
    Y.APL.OFSFUNCTION = 'R'
    Y.PROCESS = 'PROCESS'
    Y.VERSION = 'AC.LOCKED.EVENTS,BA.POS.LOCK'
    Y.ID            = ''
    Y.ID.TRANSACTION  = EB.SystemTables.getIdNew()
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    R.ACLK = ''
    EB.Foundation.OfsBuildRecord(Y.APLICACION.OFS,Y.APL.OFSFUNCTION,Y.PROCESS,Y.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.TRANSACTION,R.ACLK,Y.OFS.REQUEST)
    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
*    EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)

*   Y.RESULT = FIELD(theResponse,",",1)
*   Y.RESULT = FIELD(Y.RESULT,"/",3)
*   Y.ERR.MSG = FIELD(theResponse,",",2)
    Y.ERR.MSG = Error
    IF Y.ERR.MSG EQ '' THEN
        Y.RESULT = 1
    END

RETURN
*-------------------------------------
REVERSA.FT.ATM:
*-------------------------------------
*
    Y.APLICACION.OFS = 'FUNDS.TRANSFER'
    Y.APL.OFSFUNCTION = 'R'
    Y.PROCESS = 'PROCESS'
    Y.VERSION = Y.VERSION.FT
    Y.ID            = ''
    Y.ID.TRANSACTION  = EB.SystemTables.getIdNew()
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    R.FT = ''
    GOSUB OBTENER.ID.FT
    
    Y.ID.TRANSACTION = Y.ID.FT
    
    EB.Foundation.OfsBuildRecord(Y.APLICACION.OFS,Y.APL.OFSFUNCTION,Y.PROCESS,Y.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.TRANSACTION,R.FT,Y.OFS.REQUEST)
    theResponse = ""
    txnCommitted = ""
    options<1> = Y.OFS.SOURCE
    
    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
*EB.Interface.OfsCallBulkManager(options,Y.OFS.REQUEST,theResponse,txnCommitted)

*   Y.RESULT = FIELD(theResponse,",",1)
*   Y.RESULT = FIELD(Y.RESULT,"/",3)
*   Y.ERR.MSG = FIELD(theResponse,",",2)
    Y.ERR.MSG = Error
    IF Y.ERR.MSG EQ '' THEN
        Y.RESULT = 1
    END


RETURN
*-------------------------------------
UPDATE.AUTHID.FT:
*-------------------------------------

    Y.AUTH.ID = '' ; Y.FT.ID = '' ; Y.TIPO.APLI = '' ; Y.ACCION.APLI = ''
    Y.ESTATUS = '' ; Y.REVE.ID = '' ; Y.FECHA.MODF = ''

    Y.AUTH.ID = AUTH.ID.ACLK
    Y.FT.ID = ID.FT.AUTH.ID
    Y.REVE.ID = Y.AUTHID.REVERSO
    Y.TIPO.APLI = Y.TIPO.MOVIMIENTO
    Y.ACCION.APLI = Y.ACCION
    Y.FECHA.MODF = Y.FECHA.MODIFICACION

    Y.ESTATUS = Y.TIPO.APLI : " " : Y.ACCION.APLI

    IF Y.AUTH.ID NE '' THEN
    	EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, Y.AUTH.ID, REC.AUTH, F.ABC.CONCAT.GALILEO, ERR.AUTHID)
        IF REC.AUTH THEN
            REC.AUTH<AbcTable.AbcConcatGalile.FtGenerado> = Y.FT.ID
            REC.AUTH<AbcTable.AbcConcatGalile.Estatus> = Y.ESTATUS
            REC.AUTH<AbcTable.AbcConcatGalile.ReveId> = Y.REVE.ID
            IF Y.FECHA.MODF NE '' THEN
                REC.AUTH<AbcTable.AbcConcatGalile.Fecha> = Y.FECHA.MODF
            END
            EB.DataAccess.FWrite(FN.ABC.CONCAT.GALILEO, Y.AUTH.ID, REC.AUTH)
        END
    END

RETURN

*-----------------------------------------------------------------------------
OBTENER.ID.FT:
*** <desc>Genera un nuevo id de AA.ARRANGEMENT para poder  guardarlo en la tabla como resultado </desc>
*-----------------------------------------------------------------------------


    Y.FULL.NAME     = EB.SystemTables.getFullFname()
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    Y.PGM           = EB.SystemTables.getPgmType()
    Y.ID.CONCATFILE = EB.SystemTables.getIdConcatfile()
    Y.SAVE.COMI     = EB.SystemTables.getComi()
    Y.APPLICATION   = EB.SystemTables.getApplication()
    
    EB.SystemTables.setFullFname('FBNK.FUNDS.TRANSFER')
    EB.SystemTables.setVFunction('I')
    EB.SystemTables.setPgmType('.IDA')
    EB.SystemTables.setIdConcatfile('')
    EB.SystemTables.setComi('')
    EB.SystemTables.setApplication('FUNDS.TRANSFER')
    
    EB.TransactionControl.GetNextId('','F')

    Y.ID.FT        = EB.SystemTables.getComi()

    EB.SystemTables.setFullFname(Y.FULL.NAME)
    EB.SystemTables.setVFunction(Y.V.FUNCTION)
    EB.SystemTables.setPgmType(Y.PGM)
    EB.SystemTables.setIdConcatfile(Y.ID.CONCATFILE)
    EB.SystemTables.setApplication(Y.APPLICATION)

RETURN



END