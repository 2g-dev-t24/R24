* @ValidationCode : MjoxMjAxNTUxNTU6Q3AxMjUyOjE3NTk3ODIxOTg4MTY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Oct 2025 17:23:18
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
$PACKAGE AbcCob
SUBROUTINE ABC.GENERA.SALDOS.PREC(ID.ACCOUNT)

    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING ST.Customer
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    
    GOSUB INITIALISATION      ;* file opening, variable set up
    GOSUB MAIN.PROCESS        ;* main subroutine processing

RETURN

***************
INITIALISATION:
***************

    FN.HELP.BLOQS = AbcCob.getFnHelpBloqs()
    F.HELP.BLOQS = AbcCob.getFHelpBloqs()
    FECHA.FIN = EB.SystemTables.getToday()
    EB.DataAccess.FRead(FN.HELP.BLOQS, FECHA.FIN, REG.CTS.BLOQS, F.HELP.BLOQS, ERR.J4)
    CLIENTES.CON.BLOQUEOS = REG.CTS.BLOQS
    R.ABC.FILE.EXPORT = AbcCob.getRAbcFileExport()

RETURN

*************
MAIN.PROCESS:
*************

    CUSTOMER.ID = ""
    RESULT = ""
    Y.CONCAT.ID = "" ; REG.SALDO = ""
    IF R.ABC.FILE.EXPORT THEN
        Y.ID.ACC = ''
        Y.ID.ACC = ID.ACCOUNT
        R.ACCOUNT = ''
        ERR.ACC = ''
        FN.ACCOUNT = AbcCob.getFnAccountSaldos()
        F.ACCOUNT = AbcCob.getFAccountSaldos()
        FN.CUSTOMER = AbcCob.getFnCustomerSaldos()
        F.CUSTOMER = AbcCob.getFCustomerSaldos()
        FN.ABC.CONCAT.SALDOS = AbcCob.getFnAbcConcatSaldos()
        F.ABC.CONCAT.SALDOS = AbcCob.getFAbcConcatSaldos()
        Y.SEP = AbcCob.getYSep()
        EB.DataAccess.FRead(FN.ACCOUNT, Y.ID.ACC, R.ACCOUNT, F.ACCOUNT, ERR.ACC)
        IF R.ACCOUNT THEN
            Y.ID.CUSTOMER = ''
            Y.ID.CUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
            R.CUSTOMER = ''
            ERR.CUS = ''
            EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUS)
            IF R.CUSTOMER THEN
                Y.POST.REST = ''
                Y.POST.REST = R.CUSTOMER<ST.Customer.Customer.EbCusPostingRestrict>
                IF Y.POST.REST NE '90' THEN
                    CUSTOMER.ID = Y.ID.CUSTOMER
                    Y.CONCAT.ID = CUSTOMER.ID : "." : FECHA.FIN
                    READ REG.SALDO FROM F.ABC.CONCAT.SALDOS, Y.CONCAT.ID THEN
                        PRINT Y.CONCAT.ID : " CLIENTE YA PROCESADO"
                    END ELSE
                        AbcCob.abcSaldoPreCompensado(CUSTOMER.ID,RESULT,VAL.POR.RET,VAL.POR.RET.INV,FECHA.INI,FECHA.FIN,CLIENTES.CON.BLOQUEOS,Y.SEP)

                        REG.SALDO<AbcTable.AbcConcatSaldos.Result> = RESULT
                        REG.SALDO<AbcTable.AbcConcatSaldos.Fecha> = FECHA.FIN
                        WRITE REG.SALDO TO F.ABC.CONCAT.SALDOS, Y.CONCAT.ID
                    END
                END
            END
        END
    END

RETURN

END
