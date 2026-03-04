* @ValidationCode : MjotNzc0ODY1NTYzOkNwMTI1MjoxNzcyNTAyNzg4Mjk5Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 Mar 2026 22:53:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcTeller
SUBROUTINE ABC.2BR.EXTRAE.EFECTIVO
   
    $USING ST.CompanyCreation
    $USING EB.DataAccess
    $USING AbcTable
    $USING TT.Config
    $USING EB.Security
    $USING EB.SystemTables
**************MAIN PROCESS

    GOSUB INICIALIZA

    GOSUB PROCESA.EFECTIVO

RETURN
**************

INICIALIZA:
	TODAY      = EB.SystemTables.getToday()
    ID.COMPANY = EB.SystemTables.getIdCompany()
    F.DEPT.ACCT.OFFICER = ""
    FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
    EB.DataAccess.Opf(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)

    F.TELLER.ID = ""
    FN.TELLER.ID = "F.TELLER.ID"
    EB.DataAccess.Opf(FN.TELLER.ID,F.TELLER.ID)

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

    F.VPM.2BR.EFECTIVO = ""
    FN.VPM.2BR.EFECTIVO = "F.ABC.2BR.EFECTIVO"
    EB.DataAccess.Opf(FN.VPM.2BR.EFECTIVO,F.VPM.2BR.EFECTIVO)

    F.CURRENCY = ""
    FN.CURRENCY = "F.CURRENCY"
    EB.DataAccess.Opf(FN.CURRENCY,F.CURRENCY)

    F.ACCOUNT = ""
    FN.ACCOUNT = "F.ACCOUNT"
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    F.TELLER.PARAMETER = ""
    FN.TELLER.PARAMETER = "F.TELLER.PARAMETER"
    EB.DataAccess.Opf(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

    Y.FECHA.DIA = TODAY

    Y.FECHA.HORA = TIMEDATE()

    Y.HORA = Y.FECHA.HORA[1,8]

    DELETE.CMD = "CLEAR.FILE ":FN.VPM.2BR.EFECTIVO
    EB.DataAccess.Readlist(DELETE.CMD,'','','','')

RETURN

PROCESA.EFECTIVO:

    GOSUB LEE.CURRENCY

    GOSUB LEE.DAO

    FOR Y.CONT.DAO = 1 TO Y.NUM.DAO STEP 2
        Y.REG.EFE = ""
        Y.LLAVE.DAO = Y.ID.DAO<Y.CONT.DAO>
        IF LEN(Y.LLAVE.DAO) EQ 1 THEN
            Y.REG.EFE<AbcTable.Abc2BrEfectivo.Tipo> = "R"
            Y.REG.EFE<AbcTable.Abc2BrEfectivo.Descripcion> = Y.ID.DAO<Y.CONT.DAO + 1>
            Y.REG.EFE<AbcTable.Abc2BrEfectivo.Moneda> = Y.ARR.CURR
            Y.REG.EFE<AbcTable.Abc2BrEfectivo.Saldo> = Y.ARR.SDO
            Y.REG.EFE<AbcTable.Abc2BrEfectivo.Fecha> = Y.FECHA.DIA
            Y.REG.EFE<AbcTable.Abc2BrEfectivo.Hora> = Y.HORA
        END
        ELSE
            IF LEN(Y.LLAVE.DAO) EQ 3 THEN
                Y.REG.EFE<AbcTable.Abc2BrEfectivo.Tipo> = "P"
                Y.REG.EFE<AbcTable.Abc2BrEfectivo.Descripcion> = Y.ID.DAO<Y.CONT.DAO + 1>
                Y.REG.EFE<AbcTable.Abc2BrEfectivo.Moneda> = Y.ARR.CURR
                Y.REG.EFE<AbcTable.Abc2BrEfectivo.Saldo> = Y.ARR.SDO
                Y.REG.EFE<AbcTable.Abc2BrEfectivo.Fecha> = Y.FECHA.DIA
                Y.REG.EFE<AbcTable.Abc2BrEfectivo.Hora> = Y.HORA
            END
            ELSE
                IF LEN(Y.LLAVE.DAO) EQ 5 THEN
                    Y.REG.EFE<AbcTable.Abc2BrEfectivo.Tipo> = "S"
                    Y.REG.EFE<AbcTable.Abc2BrEfectivo.Descripcion> = Y.ID.DAO<Y.CONT.DAO + 1>
                    Y.REG.EFE<AbcTable.Abc2BrEfectivo.Moneda> = Y.ARR.CURR
                    Y.REG.EFE<AbcTable.Abc2BrEfectivo.Saldo> = Y.ARR.SDO
                    Y.REG.EFE<AbcTable.Abc2BrEfectivo.Fecha> = Y.FECHA.DIA
                    Y.REG.EFE<AbcTable.Abc2BrEfectivo.Hora> = Y.HORA
                END
            END
        END
        IF Y.REG.EFE NE "" THEN
            WRITE Y.REG.EFE TO F.VPM.2BR.EFECTIVO, Y.LLAVE.DAO
        END
    NEXT Y.CONT.DAO

    Y.ID.PARAM = ID.COMPANY
    ST.CompanyCreation.EbReadParameter(FN.TELLER.PARAMETER,'N','',Y.REG.TELLER.PARAMETER,Y.ID.PARAM,F.TELLER.PARAMETER,Y.ERROR)
    IF NOT(Y.ERROR) THEN
        Y.CATEGORIA.EFE = Y.REG.TELLER.PARAMETER<TT.Config.TellerParameter.ParTranCategory, 1>
    END

    Y.TOTAL.BOVEDAS = DCOUNT(Y.REG.TELLER.PARAMETER<TT.Config.TellerParameter.ParVaultId>, @VM)

    GOSUB LEE.TELLER.ID

    FOR Y.CONT.T.ID = 1 TO Y.NUM.T.ID STEP 3
        Y.REG.EFE = ""
        Y.LLAVE.TELLER = Y.ID.T.ID<Y.CONT.T.ID>
        Y.LLAVE.USER = Y.ID.T.ID<Y.CONT.T.ID + 1>
        IF Y.ID.T.ID<Y.CONT.T.ID + 1> EQ "" THEN
            Y.DEP.CODE = Y.ID.T.ID<Y.CONT.T.ID + 2>
            FOR Y.IDX = 1 TO Y.TOTAL.BOVEDAS
                IF Y.REG.TELLER.PARAMETER<TT.Config.TellerParameter.ParVaultId, Y.IDX> EQ Y.LLAVE.TELLER THEN
                    Y.DESCRIPCION = Y.REG.TELLER.PARAMETER<TT.Config.TellerParameter.ParVaultDesc, Y.IDX>
                END
            NEXT Y.IDX
        END
        ELSE
            READ Y.REG.USER FROM F.USER, Y.LLAVE.USER THEN
                Y.DEP.CODE = Y.REG.USER<EB.Security.User.UseDepartmentCode>
                Y.DESCRIPCION = Y.REG.USER<EB.Security.User.UseUserName>
            END
        END
        Y.REG.EFE<AbcTable.Abc2BrEfectivo.Tipo> = "C"
        Y.REG.EFE<AbcTable.Abc2BrEfectivo.Descripcion> = Y.DESCRIPCION
        Y.REG.EFE<AbcTable.Abc2BrEfectivo.Moneda> = Y.ARR.CURR
        Y.REG.EFE<AbcTable.Abc2BrEfectivo.Saldo> = Y.ARR.SDO
        Y.REG.EFE<AbcTable.Abc2BrEfectivo.Fecha> = Y.FECHA.DIA
        Y.REG.EFE<AbcTable.Abc2BrEfectivo.Hora> = Y.HORA

        Y.LLAVE.CUENTA = Y.CATEGORIA.EFE:Y.LLAVE.TELLER

        GOSUB LEE.CTA.INT

        READ Y.REG.SUC FROM F.VPM.2BR.EFECTIVO, Y.DEP.CODE THEN
            READ Y.REG.PZA FROM F.VPM.2BR.EFECTIVO, Y.DEP.CODE[1,3] THEN
                READ Y.REG.REG FROM F.VPM.2BR.EFECTIVO, Y.DEP.CODE[1,1] THEN

                    FOR Y.CONT.ACCT = 1 TO Y.NUM.ACCT STEP 2
                        Y.MONEDA = Y.ID.ACCT<Y.CONT.ACCT>[1,3]
                        Y.SALDO = Y.ID.ACCT<Y.CONT.ACCT + 1>
                        Y.SALDO = Y.SALDO * -1
                        FOR Y.IDX = 1 TO Y.NUM.CURR
                            IF Y.ARR.CURR<1, Y.IDX> EQ Y.MONEDA THEN
                                Y.REG.EFE<AbcTable.Abc2BrEfectivo.Saldo, Y.IDX> = Y.SALDO
                                Y.REG.SUC<AbcTable.Abc2BrEfectivo.Saldo, Y.IDX> += Y.SALDO
                                Y.REG.PZA<AbcTable.Abc2BrEfectivo.Saldo, Y.IDX> += Y.SALDO
                                Y.REG.REG<AbcTable.Abc2BrEfectivo.Saldo, Y.IDX> += Y.SALDO
                            END
                        NEXT Y.IDX
                    NEXT Y.CONT.ACCT

                    Y.LLAVE.EFE = Y.DEP.CODE:".":Y.LLAVE.TELLER

                    WRITE Y.REG.EFE TO F.VPM.2BR.EFECTIVO, Y.LLAVE.EFE
                    WRITE Y.REG.SUC TO F.VPM.2BR.EFECTIVO, Y.DEP.CODE
                    WRITE Y.REG.PZA TO F.VPM.2BR.EFECTIVO, Y.DEP.CODE[1,3]
                    WRITE Y.REG.REG TO F.VPM.2BR.EFECTIVO, Y.DEP.CODE[1,1]
                END
            END
        END
    NEXT Y.CONT.T.ID


RETURN

LEE.DAO:

    SELECT.CMD = "SELECT ":FN.DEPT.ACCT.OFFICER:" WITH @ID LT '100000'" ; * ITSS - SANGAVI - Added '
    SELECT.CMD := " SAVING @ID SAVING NAME TO '1'"  ; * ITSS - SANGAVI - Added '
    LOG = ""
    EXECUTE SELECT.CMD CAPTURING LOG
    Y.NUM.DAO = 0
    READLIST Y.ID.DAO FROM 1 SETTING Y.NUM.DAO ELSE CRT "ERROR AL LEER DAO"

RETURN

LEE.CURRENCY:

    SELECT.CMD = "SELECT ":FN.CURRENCY
    EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
    Y.NUM.CURR = YLD.NO
    Y.ID.CURR = YLD.ID

    Y.ARR.CURR = ""
    FOR Y.CONT.CURR = 1 TO Y.NUM.CURR
        Y.ARR.CURR<1,Y.CONT.CURR> = Y.ID.CURR<Y.CONT.CURR>
        Y.ARR.SDO<1,Y.CONT.CURR> = 0
    NEXT Y.CONT.CURR

RETURN

LEE.TELLER.ID:

    SELECT.CMD = "SELECT ":FN.TELLER.ID
    SELECT.CMD := " SAVING @ID SAVING USER SAVING DEPT.CODE TO '2'"  ; * ITSS - SANGAVI - Added '
    LOG = ""
    EXECUTE SELECT.CMD CAPTURING LOG
    Y.NUM.T.ID = 0
    READLIST Y.ID.T.ID FROM 2 SETTING Y.NUM.T.ID ELSE RETURN

RETURN

LEE.CTA.INT:

    SELECT.CMD = "SELECT ":FN.ACCOUNT:" WITH @ID LIKE ":DQUOTE("...":SQUOTE(Y.LLAVE.CUENTA))  ; * ITSS - SANGAVI - Added DQUOTE / SQUOTE
    SELECT.CMD := " SAVING @ID SAVING WORKING.BALANCE TO '4'" ; * ITSS - SANGAVI - Added '
    LOG = ""
    EXECUTE SELECT.CMD CAPTURING LOG
    Y.NUM.ACCT = 0
    READLIST Y.ID.ACCT FROM 4 SETTING Y.NUM.ACCT ELSE RETURN

RETURN

END
