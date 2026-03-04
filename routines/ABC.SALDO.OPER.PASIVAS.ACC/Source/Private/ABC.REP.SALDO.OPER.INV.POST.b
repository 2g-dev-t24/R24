* @ValidationCode : MjoxNjE2NTY0ODI6Q3AxMjUyOjE3Njk0NzM4NDA1MzA6RWRnYXIgU2FuY2hlejotMTotMTowOjA6ZmFsc2U6Ti9BOlVuZGVmaW5lZDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Jan 2026 18:30:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : Undefined
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSaldoOperPasivasAcc
 
SUBROUTINE ABC.REP.SALDO.OPER.INV.POST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.Utility
    $USING AC.AccountOpening
*-----------------------------------------------------------------------------
    GOSUB INICIALIZACION
    GOSUB ABRIR.ARCHIVO
    GOSUB PROCESO

RETURN
**************
INICIALIZACION:
**************
    FN.INF  = 'F.TMP.REP.SAL.OP'
    F.INF   = ''
    EB.DataAccess.Opf(FN.INF, F.INF)
    
    FN.ABC.PROM.ENLACE  = 'F.ABC.PROM.ENLACE'
    F.ABC.PROM.ENLACE   = ''
    EB.DataAccess.Opf(FN.ABC.PROM.ENLACE, F.ABC.PROM.ENLACE)

    FN.ACCOUNT  = "F.ACCOUNT"
    F.ACCOUNT   = ""
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    
    FN.ABC.ACCT.LCL.FLDS    = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS     = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
    
    FN.DATES = 'F.DATES'
    F.DATES = ''
    EB.DataAccess.Opf(FN.DATES,F.DATES)

    INF.NO.OF.REC   = 0
    INF.RET.CODE    = ''
    INF.ERR1        = ''
    INF.RS          = ''
    INF.SEL.LIST    = ''
    INF.SEL.CMD     = ''

    RES.SEP.INI = '*'
    RES.SEP.FIN = ','
    Y.DIA.ANT   = ''

    Y.ID.GEN.PARAM  = 'ABC.REPROC.SAL.OP.PAS'
    Y.LIST.PARAMS   = ''
    Y.LIST.VALUES   = ''
    Y.SEP           = '|'
    
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.GEN.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'FECHA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.TODAY = Y.LIST.VALUES<Y.POS.PARAM>
    END
    LOCATE 'RUTA' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<Y.POS.PARAM>
    END
    LOCATE 'INV.NOM.FILE' IN Y.LIST.PARAMS SETTING Y.POS.PARAM THEN
        INV.NOM.FILE = Y.LIST.VALUES<Y.POS.PARAM>
    END

RETURN
**************
ABRIR.ARCHIVO:
**************
    ID.COMPANY  = EB.SystemTables.getIdCompany()
    EB.DataAccess.FRead(FN.DATES,ID.COMPANY,YREC.DATES,F.DATES,YF.ERR)
    
    IF Y.TODAY EQ "!TODAY" THEN
        Y.TODAY = YREC.DATES<EB.Utility.Dates.DatLastWorkingDay>
    END

    Y.DIA.ANT = Y.TODAY

    PATH = Y.RUTA

*    INV.NOM.FILE = "ReprocesoInversiones.csv"
*   INV.FILE = PATH : "/" : TODAY : ".SaldosOperativos" : INV.NOM.FILE
*
    INV.NOM.FILE = EREPLACE(INV.NOM.FILE,"AAAAMMDD",Y.DIA.ANT)
    INV.FILE = PATH : "/" : INV.NOM.FILE
    
    Y.CMD.RM = 'SH -c rm ' : INV.FILE
    EXECUTE Y.CMD.RM CAPTURING Y.RESPONSE.RM
    
    OPENSEQ INV.FILE TO INV.STR ELSE
        CREATE INV.STR ELSE NULL
    END

    GOSUB ENC.INV

RETURN
**************
PROCESO:
**************
    LD.CAPITAL  = 0
    LD.INTERES  = 0
    CTA.SALDO   = 0
    LINEA.VACIA = ''
    INF.SEL.CMD = "SELECT ":FN.INF:" BY @ID"

    EB.DataAccess.Readlist(INF.SEL.CMD,INF.SEL.LIST,'',INF.NO.OF.REC, INF.RET.CODE)
    FOR CONTADOR.INF = 1 TO INF.NO.OF.REC
        ID.INF          = ''
        INF.RS          = ''
        INF.ERR1        = ''
        Y.PROM.ENLACE   = ''
        REC.PROM        = ''
        Y.PROM.NOMB     = ''
        ID.INF = INF.SEL.LIST<CONTADOR.INF>
        EB.DataAccess.FRead(FN.INF,ID.INF,INF.RS,F.INF,INF.ERR1)
        PRODUCTO.ACTUAL = SUBSTRINGS(INF.SEL.LIST<CONTADOR.INF>, 1, 3)
**  GENERA TOTALES
        IF PRODUCTO.ANTERIOR NE PRODUCTO.ACTUAL THEN
            IF PRODUCTO.ANTERIOR EQ '002' THEN
                STR.TOTALES = 'TOTAL CEDES':RES.SEP.INI:RES.SEP.INI:RES.SEP.INI:RES.SEP.INI:RES.SEP.INI:RES.SEP.INI:RES.SEP.INI:LD.CAPITAL:RES.SEP.INI:LD.INTERES: RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI
                WRITESEQF LINEA.VACIA TO INV.STR ELSE NULL
                CONVERT RES.SEP.FIN TO '' IN STR.TOTALES
                CONVERT RES.SEP.INI TO RES.SEP.FIN IN STR.TOTALES
                WRITESEQF STR.TOTALES TO INV.STR ELSE NULL
                WRITESEQF LINEA.VACIA TO INV.STR ELSE NULL
                LD.CAPITAL = 0
                LD.INTERES = 0
            END
            CTA.SALDO = 0
            PRODUCTO.ANTERIOR = PRODUCTO.ACTUAL
        END

        IF PRODUCTO.ACTUAL EQ '001' OR PRODUCTO.ACTUAL EQ '002' OR PRODUCTO.ACTUAL EQ '003' THEN
            Y.CADENA = INF.RS<AbcTable.TmppRepSalOp.InfoReg>
            Y.CUENTA = FIELD(Y.CADENA, RES.SEP.FIN, 1)
            
            EB.DataAccess.FRead(FN.ACCOUNT, Y.CUENTA,REC.ACC,F.ACCOUNT,ERR.ACC)
            
            ACC.ID.FLDS = REC.ACC<AC.AccountOpening.Account.ArrangementId>
            EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, ACC.ID.FLDS, R.INFO.ACC, F.ABC.ACCT.LCL.FLDS, ERROR.ACC)
            
            Y.PROM.ENLACE = R.INFO.ACC<AbcTable.AbcAcctLclFlds.PromEnlace>
            
            EB.DataAccess.FRead(FN.ABC.PROM.ENLACE,Y.PROM.ENLACE,REC.PROM,F.ABC.PROM.ENLACE,PROM.ERR)
            Y.PROM.NOMB = REC.PROM<AbcTable.AbcPromEnlace.Promotr>

            WRITESEQF Y.CADENA:RES.SEP.FIN:Y.PROM.NOMB TO INV.STR ELSE NULL
            LD.CAPITAL += FIELD(INF.RS<AbcTable.TmppRepSalOp.InfoReg>, RES.SEP.FIN, 8)
            LD.INTERES += FIELD(INF.RS<AbcTable.TmppRepSalOp.InfoReg>, RES.SEP.FIN, 9)
            IF CONTADOR.INF EQ INF.NO.OF.REC THEN
                STR.TOTALES = 'TOTAL PAGARES' : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : LD.CAPITAL : RES.SEP.INI : LD.INTERES : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI : RES.SEP.INI
                WRITESEQF LINEA.VACIA TO INV.STR ELSE NULL
                CONVERT RES.SEP.FIN TO '' IN STR.TOTALES
                CONVERT RES.SEP.INI TO RES.SEP.FIN IN STR.TOTALES
                WRITESEQF STR.TOTALES TO INV.STR ELSE NULL
                WRITESEQF LINEA.VACIA TO INV.STR ELSE NULL
                LD.CAPITAL = 0
                LD.INTERES = 0
            END
        END
    NEXT CONTADOR.INF
    CLOSESEQ INV.STR
RETURN
**************
ENC.INV:
**************
    TMP.RES  = 'CUENTA' : RES.SEP.INI
    TMP.RES := 'NO. CLIENTE' : RES.SEP.INI
    TMP.RES := 'SUCURSAL' : RES.SEP.INI
    TMP.RES := 'NO. INVERSION' : RES.SEP.INI
    TMP.RES := 'NOMBRE DE CLIENTE' : RES.SEP.INI
    TMP.RES := 'FECHA DE INICIO' : RES.SEP.INI
    TMP.RES := 'FECHA DE VENCIMIENTO' : RES.SEP.INI
    TMP.RES := 'CAPITAL' : RES.SEP.INI
    TMP.RES := 'INT. DEV. NO PAG.' : RES.SEP.INI
    TMP.RES := 'PUNTOS PORCENTUALES' : RES.SEP.INI
    TMP.RES := 'PLAZO' : RES.SEP.INI
    TMP.RES := 'TASA' : RES.SEP.INI
    TMP.RES := 'EJECUTIVO' : RES.SEP.INI
    TMP.RES := 'GRUPO' : RES.SEP.INI
    TMP.RES := 'PRODUCTO' : RES.SEP.INI
    TMP.RES := 'PROM. ENLACE'

    CONVERT RES.SEP.FIN TO '' IN TMP.RES
    CONVERT RES.SEP.INI TO RES.SEP.FIN IN TMP.RES

    WRITESEQF TMP.RES TO INV.STR ELSE NULL
    
RETURN
**************
END

