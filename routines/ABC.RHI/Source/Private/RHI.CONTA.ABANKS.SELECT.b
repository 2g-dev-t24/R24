* @ValidationCode : MjozODQ2MDgwODg6Q3AxMjUyOjE3NzIzMTg0OTMzNTY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Feb 2026 19:41:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcRhi

SUBROUTINE RHI.CONTA.ABANKS.SELECT
*************************************************************
* Extractor Routine - Contable24
********************************
*
* Created By: Rhino Systems
* Created Date: 2024/03
* Programer: Nims.
*
* Notes:
* For details consider the documentation
*
* Modifiction History
*************************************************************
* 20240430 - Nims(Rhino Systems)
*          - Moved totals to the msg log file from the main contable file
* 20240614 - Nims(Rhino Systems)
*            CAS-39076-Q2L8G1 posible incidencia en el extractor
*            solution:
*            comment(*) STMT.CLOSED.AC.SELECT: entire coding block is not needed, as it duplicates some stmt for closed account
*************************************************************
* Fecha Modificacion:  05-03-2025  ABCCORE-3798
* Desarrollador:        Edgar Aguilar - FyG Solutions
* Req. Jira:            ABCCORE-3798 - T24 - Contabilidad -Cliente Cta Garantia
* Compania:             UALA
* Descripcion:          SE AGREGA LOGICA PARA OBTENER MOVIMIENTOS DE STMT.ENTRY DE CUENTAS CON ESTADO CERRADO
*********************************************************************************
* Fecha Modificacion:  05-05-2025  ABCCORE-3798
* Desarrollador:        C�sar Miranda - FyG Solutions
* Req. Jira:            ABCCORE-3798 - T24 - Contabilidad -Cliente Cta Garantia
* Compania:             UALA
* Descripcion:          SE AGREGA LOGICA PARA EVITAR MOVIMIENTOS DUPLICADOS DE CUENTAS CON ESTADO CERRADO.
*********************************************************************************
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.DataAccess
    $USING AC.AccountStatement
    
    GOSUB VARIABLES.COMMON


    IF NOT(CONTROL.LIST) THEN
        CONTROL.LIST = 'ST'
        CONTROL.LIST<-1> = 'RE'
        CONTROL.LIST<-1> = 'CAT'
    END
    AbcRhi.setControlList(CONTROL.LIST)
    IF CONTROL.LIST THEN      ;*Check again the control list
        Y.LIST.FINAL = ''

        BEGIN CASE
            CASE CONTROL.LIST<1,1> = 'ST'
                GOSUB STMT.SELECT
                GOSUB STMT.CLOSED.AC.SELECT
            CASE CONTROL.LIST<1,1> = 'RE'
                GOSUB SPEC.SELECT
            CASE CONTROL.LIST<1,1> = 'CAT'
                GOSUB CATEG.SELECT
        END CASE

        IF Y.LIST.FINAL THEN
            EB.Service.BatchBuildList('',Y.LIST.FINAL)
        END
    END

RETURN

STMT.CLOSED.AC.SELECT:

    TODAY   = EB.SystemTables.getToday()
    SEL.CMD = 'SELECT ':FN.ACCOUNT.CLOSED:' WITH ACCT.CLOSE.DATE EQ ':DQUOTE(Y.DATES.LWKDAY)
    EB.DataAccess.Readlist(SEL.CMD,Y.CLOSE.ACCT,'',Y.CLOSE.ACCT.CNT,Y.ERROR.AC)

    LOOP
        REMOVE YCUENTA.CLOSED FROM Y.CLOSE.ACCT SETTING CUENTA.POS
    WHILE YCUENTA.CLOSED:CUENTA.POS
        ACCOUNT.NUMBER = YCUENTA.CLOSED
        FROM.DATE = Y.DATES.LWKDAY
        END.DATE = TODAY
        YID.LIST = ''
        OPENING.BAL = ''
        STMTER = ''
        AC.AccountStatement.EbAcctEntryList(ACCOUNT.NUMBER,FROM.DATE,END.DATE,YID.LIST,OPENING.BAL,STMTER)

******************************* INICIO CMB 20250505 *******************************
        IF YID.LIST THEN
            LOOP
                REMOVE YID.STMT FROM YID.LIST SETTING ID.STMT.POS
            WHILE YID.STMT:ID.STMT.POS
                FIND YID.STMT IN Y.LIST.FINAL SETTING YNOFM, YNOVM, YNOSM ELSE
                    Y.LIST.FINAL<-1> = YID.LIST
                END
            REPEAT
        END
******************************** FIN CMB 20250505 ********************************

    REPEAT

RETURN

STMT.SELECT:

    SEL.CMD = 'SELECT ': FN.ACCT.ENT.LWORK.DAY
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.STMT,'',Y.CNT.STMT,Y.ERROR.STMT)

    FOR SKEY = 1 TO Y.CNT.STMT
        READ Y.RE.KEY.REC FROM F.ACCT.ENT.LWORK.DAY, Y.LIST.STMT<SKEY> ELSE CONTINUE
        Y.LIST.FINAL<-1> = Y.RE.KEY.REC
    NEXT SKEY
RETURN

CATEG.SELECT:

    SEL.CMD = 'SELECT ':FN.CATEG.ENT.ACTIVITY:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(Y.DATES.LWKDAY):'...')
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.CATEG,'',Y.CNT.CATEG,Y.ERROR.CATEG)

    FOR CKEY = 1 TO Y.CNT.CATEG
        READ Y.CATEG.REC FROM F.CATEG.ENT.ACTIVITY, Y.LIST.CATEG<CKEY> ELSE CONTINUE
        IF Y.CATEG.REC THEN
            Y.LIST.FINAL<-1> = Y.CATEG.REC
        END
    NEXT CKEY
RETURN

SPEC.SELECT:

    SEL.CMD = 'SELECT ':FN.RE.CONSOL.SPEC.ENT.KEY:' WITH @ID LIKE ':DQUOTE('...':SQUOTE(Y.DATES.LWKDAY):'...')
    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.SPEC,'',Y.CNT.SPEC,Y.ERROR.SPEC)

    FOR SKEY = 1 TO Y.CNT.SPEC
        READ Y.SPEC.KEY.REC FROM F.RE.CONSOL.SPEC.ENT.KEY, Y.LIST.SPEC<SKEY> ELSE CONTINUE
        IF Y.SPEC.KEY.REC THEN
            Y.LIST.FINAL<-1> = Y.SPEC.KEY.REC
        END
    NEXT SKEY
RETURN


VARIABLES.COMMON:
    
    FN.ACCOUNT.CLOSED = AbcRhi.getFnAccountClosed();
    F.ACCOUNT.CLOSED = AbcRhi.getFAccountClosed();
    
    FN.ACCT.ENT.LWORK.DAY = AbcRhi.getFnAcctEntLworkDay();
    F.ACCT.ENT.LWORK.DAY = AbcRhi.getFAcctEntLworkDay();

    FN.CATEG.ENT.ACTIVITY = AbcRhi.getFnCategEntActivity();
    F.CATEG.ENT.ACTIVITY = AbcRhi.getFCategEntActivity();
    
    FN.RE.CONSOL.SPEC.ENT.KEY = AbcRhi.getFnReConsolSpecEntKey();
    F.RE.CONSOL.SPEC.ENT.KEY = AbcRhi.getFReConsolSpecEntKey();


    Y.BASE.FILE.DIRECTORY = AbcRhi.getFileDirectory();
    Y.BASE.DATAFILE.NAME = AbcRhi.getDatafileName();
    Y.BASE.DATAFILE.EXT = AbcRhi.getDatafileExt();
    Y.BASE.LOGFILE.NAME = AbcRhi.getLogfileName();
    Y.BASE.LOGFILE.EXT = AbcRhi.getLogfileExt();
    Y.DATAFILE.TMP = AbcRhi.getYDatafileTmp();
    Y.DATAFILE.TMP.F = AbcRhi.getYDatafileTmpF();
    Y.LOGFILE.TMP.F = AbcRhi.getYLogfileTmpF();
    Y.LOGFILE.TMP = AbcRhi.getYLogfileTmp();
    Y.DATES.LWKDAY = AbcRhi.getYDatesLwkday()
    
RETURN

END

