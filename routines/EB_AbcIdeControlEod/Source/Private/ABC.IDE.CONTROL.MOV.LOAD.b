* @ValidationCode : MjotMzcwMTcyMTpDcDEyNTI6MTc2NTkyNzY2NDE2OTpFZGdhciBTYW5jaGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Dec 2025 17:27:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
******************************************************************
$PACKAGE EB.AbcIdeControlEod
SUBROUTINE ABC.IDE.CONTROL.MOV.LOAD
*----------------------------------------------------------------------------
* Autor         : Jesus Hernandez JHF - FyG
* Fecha         : 09/02/2017
* DESCRIPCION:    EXTRAE TODOS LOS MOVIMIENTOS DEL CLIENTE DURANTE EL MES
*                 POR CADA CUENTA EXISTENTE, Y COMPARA CONTRA LAS TRANSACCIONES
*                 VALIDAS PARA EL TIPO DE PERSONA (FISICA O MORAL) SEGUN LOS
*                 PARAMETROS ESTABLECIDOS Y EXCEPCIONES MARCADAS
*----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.API
    $USING EB.Updates
    $USING ABC.BP
    $USING EB.Display
    $USING AbcTable
    
    
    
    GOSUB OPEN.FILE
    GOSUB FINALLY
    
RETURN

*----------------------------------------------------------------------------
VALIDA.PARAM:
*----------------------------------------------------------------------------
    COMI =  EB.SystemTables.getComi()
    IF NOT(EB.SystemTables.getRunningUnderBatch()) THEN
        EB.Display.Txtinp("TECLEAR PERIODO DE CALCULO (--yyyymm--):", 6,6,6.6,"")
        IF NOT(COMI[1,4] > 2006) THEN
            TEXT = "FECHA NO VALIDA (-yyyy-)"
            EB.Display.Rem()
            RETURN
        END
        IF NOT(COMI[5,2] > 0 AND COMI[5,2] < 13) THEN
            TEXT = "FECHA NO VALIDA (-mm-)"
            EB.Display.Rem()
            RETURN
        END
        PARAM.FECHA = COMI
    END ELSE
        PARAM.FECHA = EB.SystemTables.getToday();*[1,6]
        PARAM.FECHA = PARAM.FECHA[1,6]
    END

    COMI = PARAM.FECHA:'01':'LMNTH'     ;* POR EJEMPLO : 2011-10-28 -> 2011-10-31
    EB.API.Cfq()
    Y.FEC.FIN = COMI[1,8]     ;* FECHA DEL ULTIMO DIA DEL MES
    Y.FEC.INI = Y.FEC.FIN[1,6]:'01'     ;* FECHA DEL PRIMER DIA DEL MES
    CAD.FECHAS = ''
    CAD.FECHAS<-1> = Y.FEC.INI
    Y.FEC.DIA = Y.FEC.INI
 
    FOR I.FEC = 1 TO 30
        EB.API.Cdt('', Y.FEC.DIA, '+1C')
        IF Y.FEC.DIA <= Y.FEC.FIN THEN
            CAD.FECHAS<-1> = Y.FEC.DIA
        END
    NEXT
    


    CAD.MSG.PROC<-1> = "SE CALCULARON LOS DIAS A CONSULTAR EN EL PERIODO, TOTAL DE DIAS DEL PERIODO #": DCOUNT(CAD.FECHAS, @FM)
    
*Se asignan valores a variables GLOBALES
    EB.AbcIdeControlEod.setCadFechas(CAD.FECHAS)
    EB.AbcIdeControlEod.setCadCateg(CAD.CATEG)
    EB.AbcIdeControlEod.setYTmpCta(Y.TMP.CTA)
    EB.AbcIdeControlEod.setCadTipo(CAD.TIPO)
    EB.AbcIdeControlEod.setCadExcp(CAD.EXCP)
    EB.AbcIdeControlEod.setPsDc(PS.DC)
    EB.AbcIdeControlEod.setMtoLimite(MTO.LIMITE)
    EB.AbcIdeControlEod.setCadCodTrans(CAD.COD.TRANS)
    EB.AbcIdeControlEod.setPorcImpto(PORC.IMPTO)

RETURN

*----------------------------------------------------------------------------
OPEN.FILE:
*----------------------------------------------------------------------------

    F.ABC.IDE.PARAM = ''
    
    FN.ABC.IDE.PARAM = 'F.ABC.IDE.PARAM'
    



    F.EB.CONTRACT.BALANCES = EB.AbcIdeControlEod.setFEbContractBalances('')
    FN.EB.CONTRACT.BALANCES = EB.AbcIdeControlEod.setFnEbContractBalances('FBNK.EB.CONTRACT.BALANCES')
*    EB.DataAccess.Opf(FN.EB.CONTRACT.BALANCES, F.EB.CONTRACT.BALANCES)

    F.ABC.IDE.SALDOS.CLIE = EB.AbcIdeControlEod.setFAbcIdeSaldosClie('')
    FN.ABC.IDE.SALDOS.CLIE =EB.AbcIdeControlEod.setFnAbcIdeSaldosClie('F.ABC.IDE.SALDOS.CLIE')
*    EB.DataAccess.Opf(FN.ABC.IDE.SALDOS.CLIE, F.ABC.IDE.SALDOS.CLIE)


    LISTA.CTA = ''
    NO.CTA = 0

    CAD.TOTAL.CLIENTES = ''
    CAD.TOTAL.CUENTAS = ''

*    CALL GET.LOC.REF("CUSTOMER", "CLASSIFICATION", PS.CLAS)
*    PS.CLAS = MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.SatTaxRegimeCode
    
*    CALL GET.LOC.REF("STMT.ENTRY","DEBIT.CREDIT", PS.DC)

    applications     = ""
    fields           = ""
    applications<1>  = "STMT.ENTRY"
    fields<1,1>      = "DEBIT.CREDIT"
    field_Positions  = ""
    EB.Updates.MultiGetLocRef(applications,fields,field_Positions)
    PS.DC = field_Positions<1,1>
    
    ID.PARAM = 'MX0010001'

    CAD.MSG.PROC = ""
    CAD.MSG.PROC<-1> = "INICIA PROCESO DE COBRO DE IDE - GLOBAL"
    Y.ERR = ''
*        READ REC.PARAM FROM F.ABC.IDE.PARAM, ID.PARAM THEN
    REC.PARAM = AbcTable.AbcIdeParam.Read(ID.PARAM, Y.ERROR)
    IF Y.ERROR EQ '' THEN
        RUTA.LOG = REC.PARAM<AbcTable.AbcIdeParam.RutaRep>
        MTO.LIMITE = REC.PARAM<AbcTable.AbcIdeParam.MtoLimite>
        PORC.IMPTO = REC.PARAM<AbcTable.AbcIdeParam.PorcCobro>
        CAD.COD.TRANS = REC.PARAM<AbcTable.AbcIdeParam.CodTrans>         ;* TRANSACCIONES VALIDAS
        CAD.TIPO = RAISE(REC.PARAM<AbcTable.AbcIdeParam.TipoPersona>)
        CAD.EXCP = RAISE(REC.PARAM<AbcTable.AbcIdeParam.ExcTrans>)
           
    
*            RUTA.LOG = REC.PARAM<ABC.IP.RUTA.REP>
*        MTO.LIMITE = REC.PARAM<ABC.IP.MTO.LIMITE>
*        PORC.IMPTO = REC.PARAM<ABC.IP.PORC.COBRO>
*        CAD.COD.TRANS = REC.PARAM<ABC.IP.COD.TRANS>         ;* TRANSACCIONES VALIDAS
*        CAD.TIPO = RAISE(REC.PARAM<ABC.IP.TIPO.PERSONA>)
*        CAD.EXCP = RAISE(REC.PARAM<ABC.IP.EXC.TRANS>)

        CAD.CATEG = '1004':@VM:'1006':@VM:'6001':@VM:'6002'
        CAD.CATEG = RAISE(CAD.CATEG)

        CAD.MSG.PROC<-1> = "EXISTEN PARAMETROS, CONTINUA PROCESO"
        
        GOSUB VALIDA.PARAM
    END ELSE
        CAD.MSG.PROC<-1> = "NO EXISTEN PARAMETROS, NO SE PUEDE CONTINUAR"
    END

    CAD.MSG.PROC<-1> = "FINALIZA PROCESO DE COBRO DE IDE - GLOBAL - PERIODO ": PARAM.FECHA[1,6]

RETURN

*----------------------------------------------------------------------------
FINALLY:
*----------------------------------------------------------------------------

END
