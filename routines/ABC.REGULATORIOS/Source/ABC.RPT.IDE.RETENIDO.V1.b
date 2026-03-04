* @ValidationCode : MjotMTQxMDQ5NzU4MDpDcDEyNTI6MTc2MTg4MzU4NTU2ODpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 Oct 2025 01:06:25
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
$PACKAGE AbcRegulatorios

SUBROUTINE ABC.RPT.IDE.RETENIDO.V1
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*   Modificado por : Mauricio Ruiz
*   Fecha          : 12/02/2015
*   Descripcion    : Se modifco la rutina para que no mostrara los adeudos
*                    pendientes de meses anteriores dejando solo lo de cada mes
*-----------------------------------------------------------------------------
*   Creado por  : David Valdez
*   Fecha       : 04/2013
*   Descripcion : Rutina de enquiry para sacar el IDE retenido a clientes
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*   Modificado por : COLL-FYGSOLUTIONS
*   Fecha          : 18/02/2019
*   Descripcion    : Se modifico la rutina para trabajar como servicio y evitar
*                    el problema de timeout
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING ST.Customer
    
    GOSUB INIT
    GOSUB PROCESO
    GOSUB FINALIZE

RETURN

*----------------------------------------------------------------
INIT:

    F.ABC.IDE.SALDOS.CLIE = ''
    FN.ABC.IDE.SALDOS.CLIE = 'F.ABC.IDE.SALDOS.CLIE'
    EB.DataAccess.Opf(FN.ABC.IDE.SALDOS.CLIE, F.ABC.IDE.SALDOS.CLIE)

    F.ABC.GENERAL.PARAM = ''
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)

    F.CUS = ''
    FN.CUS = 'F.CUSTOMER'
    EB.DataAccess.Opf(FN.CUS,F.CUS)

    F.ACC = ''
    FN.ACC = 'F.ACCOUNT'
    EB.DataAccess.Opf(FN.ACC,F.ACC)

    SEL.PER = ''
    LISTA.PER = ''
    NO.PER = ''
    J.DATOS = ''
    DATOS.TEMP = ''
    DATOS.TEMP.2 = ''
*    J.SEP = CHAR(9)
    J.SEP = '*'
    PARAM.MTO.LIM = ""
    ID.LIM = "MX0010001"

    Y.TOT.CAT = 0
    Y.ARR.CATEGORY = ''
*    STR.LINEA = ''
*ITSS-SANGAVI-START
*    CALL DBR("ABC.IDE.PARAM":FM:ABC.IP.MTO.LIMITE,ID.LIM,PARAM.MTO.LIM)
    R.IDE.PARAM = '';
    EB.DataAccess.CacheRead("F.ABC.IDE.PARAM", ID.LIM, R.IDE.PARAM, IDE.ERR)
    PARAM.MTO.LIM =R.IDE.PARAM<AbcTable.AbcIdeParam.MtoLimite>
*ITSS-SANGAVI-END

    R.ABC.GENERAL.PARAM = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,ID.LIM,R.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM,Y.ERR.PARAM)
    IF R.ABC.GENERAL.PARAM THEN
        Y.ARR.NOM = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.ARR.DATO = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)

        LOCATE "CATEGORY" IN Y.ARR.NOM SETTING Y.POS.CAT THEN
            Y.ARR.CATEGORY = FIELD(Y.ARR.DATO,FM,Y.POS.CAT)
            CONVERT ',' TO @FM IN Y.ARR.CATEGORY
            Y.TOT.CAT = DCOUNT(Y.ARR.CATEGORY,@FM)
        END

        Y.CON.SEL = ''
        IF Y.TOT.CAT GE 1 THEN
            FOR Y.LOOP.CAT = 1 TO Y.TOT.CAT
                Y.CATEGORIA = ''
                Y.CATEGORIA = FIELD(Y.ARR.CATEGORY,FM,Y.LOOP.CAT)
                Y.CON.SEL := ' AND CATEGORY NE ':Y.CATEGORIA
            NEXT Y.LOOP.CAT
        END ELSE
            ETEXT = 'CATEGORIAS NO PARAMETRIZADAS'
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        ETEXT = 'NO EXISTE REGISTRO DE PARAMETROS'
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,'ABC.RPT.PARAMS.IDE',R.DATOS,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.PBS.GEN.PARAM.NOMB.PARAMETRO = R.DATOS<AbcTable.AbcGeneralParam.NombParametro>

    FIND 'PERIODO' IN Y.PBS.GEN.PARAM.NOMB.PARAMETRO SETTING AC, VC, SC THEN
        D.PERIODO = R.DATOS<AbcTable.AbcGeneralParam.DatoParametro,VC>
    END

    FIND 'ORIGEN' IN Y.PBS.GEN.PARAM.NOMB.PARAMETRO SETTING AC, VC, SC THEN
        D.ORIGEN = R.DATOS<AbcTable.AbcGeneralParam.DatoParametro,VC>
    END

    PATH = "../interfaces/IDE"

    FT.NOM.FILE = D.PERIODO : "_Reporte_IDE.RETENIDO.txt"
    FT.FILE = PATH : "/" : FT.NOM.FILE
*------Modificaci�n Archivo CL
    OPENSEQ FT.FILE TO FT.STR ELSE
        CREATE FT.STR ELSE NULL
    END

RETURN
*----------------------------------------------------------------
PROCESO:
    NO.PERIODO = DCOUNT(D.PERIODO,@SM)

    IF NO.PERIODO GT 1 THEN
        VAL.PERIODO = FIELD(D.PERIODO,@SM,1)
        VAL.PERIODO = LEN(VAL.PERIODO)
        FOR CNT.PER = 1 TO NO.PERIODO
            V.PER = FIELD(D.PERIODO,@SM,CNT.PER)
            V.PER = LEN(V.PER)
            IF VAL.PERIODO EQ V.PER ELSE
                TEXT = 'ESPECIFIQUE SOLO A�OS O SOLO MESES'
                CALL REM
                RETURN
            END
        NEXT
    END

    FOR CONT.PER = 1 TO NO.PERIODO
        J.PERIODO = FIELD(D.PERIODO,@SM,CONT.PER)

        IF LEN(J.PERIODO) EQ 6 THEN     ;** Por Mes
            NO.MESES = 1
            J.BAN = 'M'
        END ELSE
            IF LEN(J.PERIODO) EQ 4 THEN ;** Por A�o
                S.PERIODO = J.PERIODO
                NO.MESES = 12
                J.BAN = 'A'
            END
        END

        FOR NO.MES = 1 TO NO.MESES
            IF J.BAN EQ 'A' THEN
                J.MES = STR("0",2-LEN(NO.MES)):NO.MES
                J.PERIODO = S.PERIODO:J.MES
            END

            GOSUB CONV.PERIODO
            
            SEL.PER = "SELECT ": FN.ABC.IDE.SALDOS.CLIE :" WITH @ID LIKE ":DQUOTE("...":SQUOTE(J.PERIODO)):" BY-DSND IMPUESTO.CALC"  ; * ITSS - SANGAVI - Added DQUOTE / SQUOTE
*CALL EB.READLIST(SEL.PER, LISTA.PER, '', NO.PER, '')
******************************************************************************
            LISTA.AUX = ''
            LISTA.PER = ''
            REC.AUX = ''
            MES.ANTERIOR = ''
            EB.DataAccess.Readlist(SEL.PER, LISTA.AUX, '', NO.PER, '')
            FOR L=1 TO NO.PER
                READ REC.AUX FROM F.ABC.IDE.SALDOS.CLIE, LISTA.AUX<L> THEN
                    MES.ANTERIOR = REC.AUX<AbcTable.AbcIdeSaldosClie.TotDepMes>
                    IF MES.ANTERIOR EQ '' ELSE
                        LISTA.PER<-1> = LISTA.AUX<L>
                    END
                END
            NEXT

******************************************************************************

            IF LISTA.PER THEN
                FOR I.SC = 1 TO NO.PER
                    ID.SC = LISTA.PER<I.SC>
                    READ REC.SC FROM F.ABC.IDE.SALDOS.CLIE, ID.SC THEN
                        GOSUB OBT.DATOS
                    END
                NEXT
                NO.FM.DATOS = DCOUNT(DATOS.TEMP.GHOST.2,@FM)
                FOR CONT.FM = 1 TO NO.FM.DATOS
                    L.DATO = FIELD(DATOS.TEMP.GHOST.2,@FM,CONT.FM)
                    MTO.CALC.DATO = FIELD(L.DATO,J.SEP,10)
                    IMP.CALC.DATO = FIELD(L.DATO,J.SEP,11)
                    IMP.RECA.DATO = FIELD(L.DATO,J.SEP,12)
                    COB.PER.ANT.DATO = FIELD(L.DATO,J.SEP,13)
                    PEND.COBRAR.DATO = FIELD(L.DATO,J.SEP,14)
                    PERIODOS.ANT.DATO = FIELD(L.DATO,J.SEP,15)
                    T.MTO.CALC += MTO.CALC.DATO
                    T.IMP.CALC += IMP.CALC.DATO
                    T.IMP.RECA += IMP.RECA.DATO
                    T.COB.PER.ANT += COB.PER.ANT.DATO
                    T.PEND.COBRAR += PEND.COBRAR.DATO
                    T.PERIODOS.ANT += PERIODOS.ANT.DATO
                NEXT

                T.MTO.CALC.GHOST = T.MTO.CALC
                T.IMP.CALC.GHOST = T.IMP.CALC
                T.IMP.RECA.GHOST = T.IMP.RECA
                T.COB.PER.ANT.GHOST = T.COB.PER.ANT
                T.PEND.COBRAR.GHOST = T.PEND.COBRAR
                T.PERIODOS.ANT.GHOST = T.PERIODOS.ANT

                T.MTO.CALC.2 = FMT(T.MTO.CALC, "R2,& $#25")
                T.IMP.CALC.2 = FMT(T.IMP.CALC, "R2,& $#25")
                T.IMP.RECA.2 = FMT(T.IMP.RECA, "R2,& $#25")
                T.COB.PER.ANT.2 = FMT(T.COB.PER.ANT, "R2,& $#25")
                T.PEND.COBRAR.2 = FMT(T.PEND.COBRAR, "R2,& $#25")
                T.PERIODOS.ANT.2 = FMT(T.PERIODOS.ANT, "R2,& $#25")

                IF D.ORIGEN EQ 1 THEN
                    J.LINEA = NOM.PERIODO :J.SEP:J.SEP:J.SEP: 'TOTAL DEL MES' :J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP
                    J.LINEA := T.MTO.CALC.2 :J.SEP: T.IMP.CALC.2 :J.SEP: T.IMP.RECA.2 :J.SEP: T.COB.PER.ANT.2 :J.SEP: T.PEND.COBRAR.2 :J.SEP: T.PERIODOS.ANT.2
                    DATOS.TEMP.2 := J.LINEA:CHAR(10)
                END

*                J.DATOS<-1> = DATOS.TEMP.2
                STR.LINEA = DATOS.TEMP.2
                GOSUB ESCRIBE.ARCH

                IF D.ORIGEN EQ 1 THEN
*                    J.DATOS<-1> = J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP
                    STR.LINEA = J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:CHAR(10)
                    GOSUB ESCRIBE.ARCH
                END

                SUM.T.MTO.CALC += T.MTO.CALC.GHOST
                SUM.T.IMP.CALC += T.IMP.CALC.GHOST
                SUM.T.IMP.RECA += T.IMP.RECA.GHOST
                SUM.T.COB.PER.ANT += T.COB.PER.ANT.GHOST
                SUM.T.PEND.COBRAR += T.PEND.COBRAR.GHOST
                SUM.T.PERIODOS.ANT += T.PERIODOS.ANT.GHOST

                DATOS.TEMP.2 = ''
                DATOS.TEMP.GHOST.2 = ''
                T.MTO.CALC = ''
                T.IMP.CALC = ''
                T.IMP.RECA = ''
                T.COB.PER.ANT = ''
                T.PEND.COBRAR = ''
                T.PERIODOS.ANT = ''
                T.MTO.CALC.GHOST = ''
                T.IMP.CALC.GHOST = ''
                T.IMP.RECA.GHOST = ''
                T.COB.PER.ANT.GHOST = ''
                T.PEND.COBRAR.GHOST = ''
                T.PERIODOS.ANT.GHOST = ''
            END
        NEXT

        IF J.BAN EQ 'A' THEN
*            IF J.DATOS NE '' THEN
            IF STR.LINEA NE '' THEN
* DIF.IMP = SUM.T.IMP.CALC - SUM.T.IMP.RECA

                SUM.T.MTO.CALC.2 = FMT(SUM.T.MTO.CALC, "R2,& $#25")
                SUM.T.IMP.CALC.2 = FMT(SUM.T.IMP.CALC, "R2,& $#25")
                SUM.T.IMP.RECA.2 = FMT(SUM.T.IMP.RECA, "R2,& $#25")
                SUM.T.COB.PER.ANT.2 = FMT(SUM.T.COB.PER.ANT, "R2,& $#25")
                SUM.T.PEND.COBRAR.2 = FMT(SUM.T.PEND.COBRAR, "R2,& $#25")
                SUM.T.PERIODOS.ANT.2 = FMT(SUM.T.PERIODOS.ANT, "R2,& $#25")
* DIF.IMP.2 = FMT(DIF.IMP, "R2,& $#25")

                IF D.ORIGEN EQ 1 THEN
                    J.LINEA.2 = 'TOTAL IDE ENTERADO ':J.ANO :J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP
                    J.LINEA.2 := SUM.T.MTO.CALC.2 :J.SEP: SUM.T.IMP.CALC.2 :J.SEP: SUM.T.IMP.RECA.2 :J.SEP: SUM.T.COB.PER.ANT.2 :J.SEP: SUM.T.PEND.COBRAR.2 :J.SEP: SUM.T.PERIODOS.ANT.2
*                    J.DATOS<-1> = J.LINEA.2
                    STR.LINEA = J.LINEA.2:CHAR(10)
                    GOSUB ESCRIBE.ARCH

                    IF NO.PERIODO GT 1 AND CONT.PER LT NO.PERIODO THEN
*                        J.DATOS<-1> = J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP
                        STR.LINEA = J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:CHAR(10)
                        GOSUB ESCRIBE.ARCH
                    END
                END

                SUM.T.MTO.CALC = ''
                SUM.T.IMP.CALC = ''
                SUM.T.IMP.RECA = ''
                SUM.T.COB.PER.ANT = ''
                SUM.T.PEND.COBRAR = ''
                SUM.T.PERIODOS.ANT = ''
            END
        END

    NEXT

    IF J.BAN EQ 'M' THEN
* DIF.IMP = SUM.T.IMP.CALC - SUM.T.IMP.RECA

        SUM.T.MTO.CALC.2 = FMT(SUM.T.MTO.CALC, "R2,& $#25")
        SUM.T.IMP.CALC.2 = FMT(SUM.T.IMP.CALC, "R2,& $#25")
        SUM.T.IMP.RECA.2 = FMT(SUM.T.IMP.RECA, "R2,& $#25")
        SUM.T.COB.PER.ANT.2 = FMT(SUM.T.COB.PER.ANT, "R2,& $#25")
        SUM.T.PEND.COBRAR.2 = FMT(SUM.T.PEND.COBRAR, "R2,& $#25")
        SUM.T.PERIODOS.ANT.2 = FMT(SUM.T.PERIODOS.ANT, "R2,& $#25")
* DIF.IMP.2 = FMT(DIF.IMP, "R2,& $#25")

        IF D.ORIGEN EQ 1 THEN
            J.LINEA.2 = 'TOTAL IDE ENTERADO' :J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP:J.SEP
            J.LINEA.2 := SUM.T.MTO.CALC.2 :J.SEP: SUM.T.IMP.CALC.2 :J.SEP: SUM.T.IMP.RECA.2 :J.SEP: SUM.T.COB.PER.ANT.2 :J.SEP: SUM.T.PEND.COBRAR.2 :J.SEP: SUM.T.PERIODOS.ANT.2
*            J.DATOS<-1> = J.LINEA.2
            STR.LINEA = J.LINEA.2:CHAR(10)
            GOSUB ESCRIBE.ARCH
        END
    END

RETURN

*----------------------------
CONV.PERIODO:

    J.MES = J.PERIODO[5,2]
    J.ANO = J.PERIODO[1,4]

    BEGIN CASE
        CASE J.MES EQ '01'
            NOM.PERIODO = 'Ene-':J.ANO
        CASE J.MES EQ '02'
            NOM.PERIODO = 'Feb-':J.ANO
        CASE J.MES EQ '03'
            NOM.PERIODO = 'Mar-':J.ANO
        CASE J.MES EQ '04'
            NOM.PERIODO = 'Abr-':J.ANO
        CASE J.MES EQ '05'
            NOM.PERIODO = 'May-':J.ANO
        CASE J.MES EQ '06'
            NOM.PERIODO = 'Jun-':J.ANO
        CASE J.MES EQ '07'
            NOM.PERIODO = 'Jul-':J.ANO
        CASE J.MES EQ '08'
            NOM.PERIODO = 'Ago-':J.ANO
        CASE J.MES EQ '09'
            NOM.PERIODO = 'Sep-':J.ANO
        CASE J.MES EQ '10'
            NOM.PERIODO = 'Oct-':J.ANO
        CASE J.MES EQ '11'
            NOM.PERIODO = 'Nov-':J.ANO
        CASE J.MES EQ '12'
            NOM.PERIODO = 'Dic-':J.ANO
    END CASE

RETURN

*----------------------------------------------------------------
OBT.DATOS:

    ID.CTE = FIELD(ID.SC,'.',1)
    IF ID.CTE THEN
        READ REC.CUS FROM F.CUS, ID.CTE THEN
            NOM.CAMPOS = 'NOM.PER.MORAL#CLASSIFICATION'
            CALL GET.LOCAL.REFM("CUSTOMER",NOM.CAMPOS,POS.LOCAL)
            POS.DENOM.1 = FIELD(POS.LOCAL,'#',1)
            POS.CLASS = FIELD(POS.LOCAL,'#',2)

            J.CLASS = REC.CUS<ST.Customer.Customer.EbCusLocalRef,POS.CLASS>

            IF J.CLASS EQ 1 OR J.CLASS EQ 2 THEN
                AP.PAT = REC.CUS<ST.Customer.Customer.EbCusShortName>
                AP.MAT = REC.CUS<ST.Customer.Customer.EbCusNameOne>
                PRI.NOM = REC.CUS<ST.Customer.Customer.EbCusNameTwo>
                NOM.CLIENTE = AP.PAT:' ':AP.MAT:' ':PRI.NOM
                NOM.CLIENTE = TRIM(NOM.CLIENTE)
                RFC.CTE = REC.CUS<ST.Customer.Customer.EbCusTaxId>
                CONVERT @VM TO @FM IN RFC.CTE
                RFC.CTE=RFC.CTE<1>
            END ELSE
                IF J.CLASS EQ 3 THEN
                    DENOM.1 = REC.CUS<ST.Customer.Customer.EbCusLocalRef,POS.DENOM.1>
                    NOM.CLIENTE = DENOM.1
                    NOM.CLIENTE = TRIM(NOM.CLIENTE)
                    RFC.CTE = REC.CUS<ST.Customer.Customer.EbCusTaxId>
                    CONVERT @VM TO @FM IN RFC.CTE
                    RFC.CTE=RFC.CTE<1>
                END
            END

*SEL.ACC = "SELECT ": FN.ACC :" WITH CUSTOMER EQ ": ID.CTE: " AND CATEGORY NE 6605 AND CATEGORY NE 6606 AND CATEGORY NE 6607 AND CATEGORY NE 6608" ;**   :" AND POSTING.RESTRICT EQ '' AND CATEGORY NR 6605 6609"
            SEL.ACC = "SELECT ": FN.ACC :" WITH CUSTOMER EQ ": DQUOTE(ID.CTE:Y.CON.SEL)  ; * ITSS - SANGAVI - Added DQUOTE

            LISTA.ACC = '';     NO.ACC = ''
            EB.DataAccess.Readlist(SEL.ACC, LISTA.ACC, '', NO.ACC, '')
            ID.CTA = ''
            IF LISTA.ACC THEN
                FOR CONT.ACC = 1 TO NO.ACC
                    IF ID.CTA THEN
                        ID.CTA := '-':FIELD(LISTA.ACC,@FM,CONT.ACC)
                    END ELSE
                        ID.CTA = FIELD(LISTA.ACC,@FM,CONT.ACC)
                    END
                NEXT
            END

            MTO.DEPO.MES = REC.SC<AbcTable.AbcIdeSaldosClie.TotDepMes>
            MTO.LIM = PARAM.MTO.LIM
            MTO.EXEDE = MTO.DEPO.MES - MTO.LIM
            PAG.CRED = 0
            MTO.CALC = MTO.EXEDE
            IMP.CALC = REC.SC<AbcTable.AbcIdeSaldosClie.ImpuestoCalc>
            IF IMP.CALC EQ '' THEN
                IMP.CALC = 0
            END
            IMP.RECA = REC.SC<AbcTable.AbcIdeSaldosClie.ImpuestoReca>
            IF IMP.RECA EQ '' THEN
                IMP.RECA = 0
            END
            PEND.COBRAR = REC.SC<AbcTable.AbcIdeSaldosClie.ImpuestoPend>

            J.PER.ANT = REC.SC<AbcTable.AbcIdeSaldosClie.PeriodoAnt>
            J.MTO.ANT = REC.SC<AbcTable.AbcIdeSaldosClie.IdePerAnt>
            FOR CNT1 = 1 TO DCOUNT(J.PER.ANT,@VM)
                J.MTO.ANT1 = FIELD(J.MTO.ANT,@VM,CNT1)
                SUM.MTO.ANT += J.MTO.ANT1
            NEXT CNT1
            J.REF.PER.ANT = REC.SC<AbcTable.AbcIdeSaldosClie.RefPerIde>
            J.REF.MTO.ANT = REC.SC<AbcTable.AbcIdeSaldosClie.RefPagIde>

            CANT.VM = DCOUNT(J.REF.PER.ANT,@VM)
            FOR CONT.VM = 1 TO CANT.VM
                J.REF.PER.ANT1 = FIELD(J.REF.PER.ANT,@VM,CONT.VM)
                IF J.REF.PER.ANT1 LT J.PERIODO THEN
                    J.REF.MTO.ANT1 = FIELD(J.REF.MTO.ANT,@VM,CONT.VM)
                    SUM.REF.MTO.ANT += J.REF.MTO.ANT1
                END
            NEXT CONT.VM
            PERIODOS.ANT = SUM.MTO.ANT - SUM.REF.MTO.ANT
            COB.PER.ANT = SUM.REF.MTO.ANT
            SUM.MTO.ANT = ''
            SUM.REF.MTO.ANT = ''

            IF PERIODOS.ANT EQ '' THEN
                PERIODOS.ANT = 0
            END

            IF MTO.DEPO.MES EQ '' THEN
                MTO.DEPO.MES = 0
                MTO.EXEDE = 0
                MTO.CALC = 0
            END

            DATOS.TEMP.GHOST = NOM.PERIODO :J.SEP: ID.CTA :J.SEP: ID.CTE :J.SEP: NOM.CLIENTE :J.SEP: RFC.CTE :J.SEP: MTO.DEPO.MES :J.SEP
            DATOS.TEMP.GHOST := MTO.LIM :J.SEP: MTO.EXEDE :J.SEP: PAG.CRED :J.SEP: MTO.CALC :J.SEP
            DATOS.TEMP.GHOST := IMP.CALC :J.SEP: IMP.RECA :J.SEP: COB.PER.ANT :J.SEP: PEND.COBRAR :J.SEP: PERIODOS.ANT

            DATOS.TEMP.GHOST.2<-1> = DATOS.TEMP.GHOST

            DATOS.TEMP.GHOST = ''

            MTO.DEPO.MES = FMT(MTO.DEPO.MES, "R2,& $#25")
            MTO.LIM = FMT(MTO.LIM, "R2,& $#25")
            MTO.EXEDE = FMT(MTO.EXEDE, "R2,& $#25")
            PAG.CRED = FMT(PAG.CRED, "R2,& $#25")
            MTO.CALC = FMT(MTO.CALC, "R2,& $#25")
            IMP.CALC = FMT(IMP.CALC, "R2,& $#25")
            IMP.RECA = FMT(IMP.RECA, "R2,& $#25")
            COB.PER.ANT = FMT(COB.PER.ANT, "R2,& $#25")
            PEND.COBRAR = FMT(PEND.COBRAR, "R2,& $#25")
            PERIODOS.ANT = FMT(PERIODOS.ANT, "R2,& $#25")

            DATOS.TEMP = NOM.PERIODO :J.SEP: ID.CTA :J.SEP: ID.CTE :J.SEP: NOM.CLIENTE :J.SEP: RFC.CTE :J.SEP: MTO.DEPO.MES :J.SEP
            DATOS.TEMP := MTO.LIM :J.SEP: MTO.EXEDE :J.SEP: PAG.CRED :J.SEP: MTO.CALC :J.SEP
            DATOS.TEMP := IMP.CALC :J.SEP: IMP.RECA :J.SEP: COB.PER.ANT :J.SEP: PEND.COBRAR :J.SEP: PERIODOS.ANT

            DATOS.TEMP.2 := DATOS.TEMP:CHAR(10)

            DATOS.TEMP = ''
        END
    END

RETURN

*------------------------------
ESCRIBE.ARCH:
*------------------------------
    CHANGE @FM TO CHAR(10) IN STR.LINEA
    WRITESEQ STR.LINEA TO FT.STR ELSE NULL

RETURN

*************************
FINALIZE:
*************************

END

