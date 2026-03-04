*-----------------------------------------------------------------------------
$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE NOFILE.GET.TRANSACCIONES(R.DATA)
*===============================================================================
* Nombre de Programa : NOFILE.GET.TRANSACCIONES
* Objetivo           : Rutina NOFILE para extraer datos de transacciones con el número de cta
* Desarrollador      : 
* Compania           : 
* Fecha Creacion     : 
* Modificaciones     :
*===============================================================================

    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING FT.Config
    $USING AbcTable
    $USING EB.Reports

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

    RETURN

*************
INITIALIZE:
*************

    Y.SEP = "|"
    R.DATA = ''
    Y.SEGUIR = 0

    Y.TIPO = 0
    DESCRIPCION = ''
    FECHA.BLOQUEO = ''
    MONTO.BLOQUEADO = ''

    F.ACCOUNT = ""
    FN.ACCOUNT = "F.ACCOUNT"
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    F.FUNDS.TRANSFER = ""
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER$NAU"
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    F.FT.TXN.TYPE.CONDITION = ""
    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    EB.DataAccess.Opf(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    F.AC.LOCKED.EVENTS = ""
    FN.AC.LOCKED.EVENTS = "F.AC.LOCKED.EVENTS"
    EB.DataAccess.Opf(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    F.ABC.AA.PRE.PROCESS = ""
    FN.ABC.AA.PRE.PROCESS = "F.ABC.AA.PRE.PROCESS$NAU"
    EB.DataAccess.Opf(FN.ABC.AA.PRE.PROCESS,F.ABC.AA.PRE.PROCESS)

    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    LOCATE "ACCOUNT.NUMBER" IN SEL.FIELDS<1> SETTING YPOS.CUENTA THEN
        CUENTA.CARGO = SEL.VALUES<YPOS.CUENTA>
    END

    RETURN

*************
PROCESS:
*************

    IF CUENTA.CARGO THEN
        Y.SLC.FT = 'SELECT ':FN.FUNDS.TRANSFER:' WITH DEBIT.ACCT.NO EQ ':DQUOTE(CUENTA.CARGO)  ; *ITSS - SUNDRAM - Added DQUOTE
        Y.SLC.ALE = 'SELECT ':FN.AC.LOCKED.EVENTS:' WITH ACCOUNT.NUMBER EQ ':DQUOTE(CUENTA.CARGO)  ; *ITSS - SUNDRAM - Added DQUOTE
        Y.SLC.APP = 'SELECT ':FN.ABC.AA.PRE.PROCESS:' WITH ACCOUNT.ID EQ ':DQUOTE(CUENTA.CARGO)  ; *ITSS - SUNDRAM - Added DQUOTE
        Y.LISTA.SLC = ''
        Y.NO.RECORDS = ''

        EB.DataAccess.Readlist(Y.SLC.FT,Y.LISTA.SLC,'',Y.NO.RECORDS,Y.ERR.SEL)
        Y.TIPO = 1  ;*FUNDS.TRANSFER
        FOR Y.CONT = 1 TO Y.NO.RECORDS  ;
            REFERENCIA = Y.LISTA.SLC<Y.CONT>      ;*ES UN ARREGLO QUE EXTRAE LOS ID´S Y LOS VA RECORRIENDO
            GOSUB ASIGNA ;
        NEXT Y.CONT
        EB.DataAccess.Readlist(Y.SLC.ALE,Y.LISTA.SLC,'',Y.NO.RECORDS,Y.ERR.SEL)
        Y.TIPO = 2  ;*AC.LOCKED.EVENTS
        FOR Y.CONT = 1 TO Y.NO.RECORDS  ;
            REFERENCIA = Y.LISTA.SLC<Y.CONT>      ;*ES UN ARREGLO QUE EXTRAE LOS ID´S Y LOS VA RECORRIENDO
            GOSUB ASIGNA ;
        NEXT Y.CONT
        EB.DataAccess.Readlist(Y.SLC.APP,Y.LISTA.SLC,'',Y.NO.RECORDS,Y.ERR.SEL)
        Y.TIPO = 3  ;*ABC.AA.PRE.PROCESS
        FOR Y.CONT = 1 TO Y.NO.RECORDS  ;
            REFERENCIA = Y.LISTA.SLC<Y.CONT>      ;*ES UN ARREGLO QUE EXTRAE LOS ID´S Y LOS VA RECORRIENDO
            GOSUB ASIGNA ;
        NEXT Y.CONT
    END

    RETURN

*************
ASIGNA:
*************

    BEGIN CASE
    CASE Y.TIPO = 1
        EB.DataAccess.FRead(FN.FUNDS.TRANSFER,REFERENCIA,Y.REC.FT,F.FUNDS.TRANSFER,Y.F.ERROR.FT)
        IF Y.REC.FT THEN
            CUENTA.CARGO = Y.REC.FT<FT.Contract.FundsTransfer.DebitAcctNo>
            DESCRIPCION = Y.REC.FT<FT.Contract.FundsTransfer.TransactionType>
            FECHA.BLOQUEO = Y.REC.FT<FT.Contract.FundsTransfer.DebitValueDate>
            MONTO.BLOQUEADO = Y.REC.FT<FT.Contract.FundsTransfer.AmountDebited>
            MONTO.BLOQUEADO = MONTO.BLOQUEADO[4,LEN(MONTO.BLOQUEADO)]
            EB.DataAccess.FRead(FN.FT.TXN.TYPE.CONDITION, DESCRIPCION, Y.REC.FTT, F.FT.TXN.TYPE.CONDITION, Y.F.ERROR.FTT)
            IF Y.REC.FTT THEN
                DESCRIPCION = Y.REC.FTT<FT.Config.TxnTypeCondition.FtSixDescription>
            END
            Y.SEGUIR = 1
        END
    CASE Y.TIPO = 2
        EB.DataAccess.FRead(FN.AC.LOCKED.EVENTS,REFERENCIA,Y.REC.LE,F.AC.LOCKED.EVENTS,Y.F.ERROR.LE)
        IF Y.REC.LE THEN
            CUENTA.CARGO = Y.REC.LE<AC.AccountOpening.LockedEvents.LckAccountNumber>
            DESCRIPCION = Y.REC.LE<AC.AccountOpening.LockedEvents.LckDescription>
            FECHA.BLOQUEO = Y.REC.LE<AC.AccountOpening.LockedEvents.LckFromDate>
            MONTO.BLOQUEADO = Y.REC.LE<AC.AccountOpening.LockedEvents.LckLockedAmount>
            Y.SEGUIR = 1
        END
    CASE Y.TIPO = 3
        EB.DataAccess.FRead(FN.ABC.AA.PRE.PROCESS,REFERENCIA,Y.REC.APP,F.ABC.AA.PRE.PROCESS,Y.F.ERROR.APP)
        IF Y.REC.APP THEN
            IF Y.REC.APP<AbcTable.AbcAaPreProcess.ArrangementId> NE '' THEN
                CUENTA.CARGO = Y.REC.APP<AbcTable.AbcAaPreProcess.AccountId>
                DESCRIPCION = 'APERTURA DE INVERSION'
                FECHA.BLOQUEO = Y.REC.APP<AbcTable.AbcAaPreProcess.EffectiveDate>
                MONTO.BLOQUEADO = Y.REC.APP<AbcTable.AbcAaPreProcess.Amount>
                Y.SEGUIR = 1
            END
        END
    END CASE

    IF Y.SEGUIR EQ 1 THEN
        YFECHA  = FECHA.BLOQUEO[3,8]
        FECHA.BLOQUEO= YFECHA[5,2]:"/":YFECHA[3,2]:"/20":YFECHA[1,2]
        R.DATA<-1> = REFERENCIA:Y.SEP:CUENTA.CARGO:Y.SEP:DESCRIPCION:Y.SEP:FECHA.BLOQUEO:Y.SEP:MONTO.BLOQUEADO
    END

    RETURN

*************
FINALIZE:
*************

    RETURN
END
