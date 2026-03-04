$PACKAGE AbcBi
SUBROUTINE ABC.BAN.INT.LIST.CTA.CTE(R.DATA)
*===============================================================================

    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING AC.AccountOpening
    $USING AbcTable
    
    GOSUB INIT 
    GOSUB PROCESS

    RETURN

INIT:

    FN.CTAS.DEST = "F.ABC.CUENTAS.DESTINO"
    F.CTAS.DEST = ""
    EB.DataAccess.Opf(FN.CTAS.DEST, F.CTAS.DEST)

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    EB.DataAccess.Opf(FN.ACC,F.ACC)

    Y.ARR = ''
    Y.TIP.CTA = ''
    Y.DEBIT.ACCT.NO = ''

    D.FIELDS              = EB.Reports.getDFields()
    D.RANGE.AND.VALUE     = EB.Reports.getDRangeAndValue()

    RETURN

PROCESS:

    LOCATE "TIPO.CTA" IN D.FIELDS<1> SETTING POS THEN
        Y.TIP.CTA = TRIM(D.RANGE.AND.VALUE<POS>)
        CHANGE "'" TO "" IN Y.TIP.CTA
        Y.TIP.CTA = Y.TIP.CTA * 1

        BEGIN CASE
        CASE Y.TIP.CTA EQ 1
            Y.TIP.CTA = 'CLABE'
        CASE Y.TIP.CTA EQ 2
            Y.TIP.CTA = 'CUENTA'
        CASE Y.TIP.CTA EQ 3
            Y.TIP.CTA = 'TARJETA DE CREDITO'
        CASE Y.TIP.CTA EQ 4
            Y.TIP.CTA = 'TARJETA DEBITO'
        CASE Y.TIP.CTA EQ 5
            Y.TIP.CTA = 'CELULAR'
        CASE 1
            Y.TIP.CTA = 'CLABE'
        END CASE
    END ELSE
        Y.TIP.CTA = 'CLABE'
    END

    LOCATE "NO.CUENTA" IN D.FIELDS<1> SETTING POS THEN
        Y.DEBIT.ACCT.NO = TRIM(D.RANGE.AND.VALUE<POS>)
        CHANGE "'" TO "" IN Y.DEBIT.ACCT.NO
    END
 
    Y.CTA = Y.DEBIT.ACCT.NO  


    EB.DataAccess.FRead(FN.ACC, Y.CTA, REC.ACC, F.ACC, Y.ERR.ACC)
    IF REC.ACC NE '' THEN
        Y.CTE = REC.ACC<AC.AccountOpening.Account.Customer>
    END ELSE
        Y.ARR = "CLIENTE LIGADO A LA CUENTA, NO EXISTE"
        RETURN
    END
  
    SEL.CTAS.DEST = "SELECT " : FN.CTAS.DEST : " WITH @ID LIKE " : DQUOTE(SQUOTE(Y.CTE):"...") : " AND STATUS EQ 'ACTIVA' AND BANCO NE '40138' AND TIPO.CTA MATCHES '":Y.TIP.CTA:"'"
    YLIST=''; YNO=''; YCO=''
    EB.DataAccess.Readlist(SEL.CTAS.DEST,YLIST,'',YNO,YCO)

    FOR IDX.CTAS.DEST = 1 TO YNO

        CIC.CTA = FIELD(YLIST<IDX.CTAS.DEST>, '.', 2)

        Y.ID.CTAS = YLIST<IDX.CTAS.DEST>
        EB.DataAccess.FRead(FN.CTAS.DEST, Y.ID.CTAS, R.CTAS.DEST, F.CTAS.DEST, Y.ERR.CTAS.DEST)
        IF R.CTAS.DEST NE '' THEN

            CIC.BEN = R.CTAS.DEST<AbcTable.AbcCuentasDestino.Beneficiario>

            CIC.EST.CTA = R.CTAS.DEST<AbcTable.AbcCuentasDestino.Status>

            CIC.TIP.CTA = R.CTAS.DEST<AbcTable.AbcCuentasDestino.TipoCta>

            CIC.BANCO =  R.CTAS.DEST<AbcTable.AbcCuentasDestino.Banco>

            IF CIC.EST.CTA EQ 'ACTIVA' AND CIC.TIP.CTA MATCHES Y.TIP.CTA AND CIC.BANCO NE '40138' THEN

                Y.ARR <-1> = CIC.CTA :'*': CIC.BEN :'*': CIC.TIP.CTA

            END

        END

    NEXT IDX.CTAS.DEST


    IF Y.ARR EQ '' THEN
        Y.ARR = "EL CLIENTE NO TIENE CUENTAS DESTINO ACTIVAS"
    END

    RETURN

END
