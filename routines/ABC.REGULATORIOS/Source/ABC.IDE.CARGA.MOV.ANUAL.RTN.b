* @ValidationCode : MjotODEwODMxMTA4OkNwMTI1MjoxNzY0MTMxNjU1MzQ5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Nov 2025 01:34:15
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

SUBROUTINE ABC.IDE.CARGA.MOV.ANUAL.RTN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Security

*-----------------------------------------------------------------------------

    GOSUB INICIO
    GOSUB PROCESO
RETURN



*==========
PROCESO:
*==========
    TODAY   = EB.SystemTables.getToday()
    IF NOT(EB.SystemTables.getRunningUnderBatch()) THEN
        EB.Display.Txtinp("TECLEAR PERIODO DE COBRO IDE (--yyyy--):", 4,4,4.4,"")
        IF NOT(COMI[1,4] > 2006) THEN
            TEXT = "FECHA NO VALIDA (-yyyy-)"
            EB.Display.Rem()
            RETURN
        END

        Y.FEC.PER = EB.SystemTables.getComi()
    END ELSE
        
        Y.FEC.PER = TODAY[1,4]
        CAD.LOG<-1> = "INICIA PROCESO DE MIGRACION DE MOVIMIENTOS MENSUAL A ANUAL PARA EL PERIODO ": Y.FEC.PER
    END

    SEL.MOV = "SELECT ": FN.ABC.IDE.TRANS.MENSUAL :" WITH @ID LIKE ":DQUOTE("...": SQUOTE(Y.FEC.PER) :"..."):" BY @ID"  ; * ITSS - BINDHU - Added DQUOTE / SQUOTE
    EB.DataAccess.Readlist(SEL.MOV, LISTA.MOV, '', NO.MOV, '')
    IF LISTA.MOV THEN
        FOR I.MOV = 1 TO DCOUNT(LISTA.MOV, FM)
            ID.MOV = LISTA.MOV<I.MOV>
            READ REC.MOV FROM F.ABC.IDE.TRANS.MENSUAL, ID.MOV THEN
                Y.CLI.MES = FIELD(ID.MOV, '.', 1)
                Y.FEC.MES = FIELD(ID.MOV, '.', 2)
                IF (Y.FEC.MES[1,4] = Y.FEC.PER) THEN
                    Y.FEC.MES = Y.FEC.MES[5,2]

                    Y.MONEDA = REC.MOV<AbcTable.AbcIdeTransMensual.Moneda>
                    Y.STR.COD.TRANS = REC.MOV<AbcTable.AbcIdeTransMensual.CodTrans>
                    Y.STR.NO.TRANS  = REC.MOV<AbcTable.AbcIdeTransMensual.NoTrans>
                    Y.STR.MTO.TRANS = REC.MOV<AbcTable.AbcIdeTransMensual.MtoTrans>

                    Y.STR.COD.TRANS.LN = REC.MOV<AbcTable.AbcIdeTransMensual.CodTransLn>
                    Y.STR.MTO.TRANS.LN = REC.MOV<AbcTable.AbcIdeTransMensual.MtoTransLn>
                    Y.STR.FOL.TRANS.LN = REC.MOV<AbcTable.AbcIdeTransMensual.FolTransLn>
                    Y.STR.FEC.TRANS.LN = REC.MOV<AbcTable.AbcIdeTransMensual.FecTransLn>

*--------------------------------------------------------------------------------
                    Y.STR.MOV.DEP = REC.MOV<AbcTable.AbcIdeTransMensual.MovDep>
*--------------------------------------------------------------------------------

                    Y.CURR.NO = 0
                    Y.CNT.MES = 0
                    READ REC.MOV.ANUAL FROM F.ABC.IDE.TRANS.ANUAL, Y.FEC.PER THEN
                        Y.CURR.NO = REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.CurrNo>
                        Y.STR.MES = RAISE(AbcTable.AbcIdeTransAnual.Mes)
                        Y.CNT.MES = DCOUNT(Y.STR.MES, FM)
                        Y.CNT.MES += 1
                        LOCATE Y.FEC.MES IN Y.STR.MES SETTING PS.MES ELSE
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.Mes, Y.CNT.MES>          = Y.FEC.MES
                            FOR I.DEP = 1 TO DCOUNT(Y.STR.COD.TRANS, VM)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.CodTrans, Y.CNT.MES, -1>    = FIELD(Y.STR.COD.TRANS, VM, I.DEP)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.NoTrans, Y.CNT.MES, -1>     = FIELD(Y.STR.NO.TRANS, VM, I.DEP)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.MtoTrans, Y.CNT.MES, -1>    = FIELD(Y.STR.MTO.TRANS, VM, I.DEP)
                            NEXT
*----------------------------------
                            FOR I.MOV.DEP = 1 TO DCOUNT(Y.STR.MOV.DEP, VM)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.MovDep, Y.CNT.MES, -1>    = FIELD(Y.STR.MOV.DEP, VM, I.MOV.DEP)
                            NEXT
*----------------------------------
                            FOR I.DEP.LN = 1 TO DCOUNT(Y.STR.COD.TRANS.LN, VM)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.CodTransLn, Y.CNT.MES, -1> = FIELD(Y.STR.COD.TRANS.LN, VM, I.DEP.LN)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.MtoTransLn, Y.CNT.MES, -1> = FIELD(Y.STR.MTO.TRANS.LN, VM, I.DEP.LN)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.FolTransLn, Y.CNT.MES, -1> = FIELD(Y.STR.FOL.TRANS.LN, VM, I.DEP.LN)
                                REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.FecTransLn, Y.CNT.MES, -1> = FIELD(Y.STR.FEC.TRANS.LN, VM, I.DEP.LN)
                            NEXT
                        END
                    END ELSE
                        REC.MOV.ANUAL = ''
                        REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.Currency>             = Y.MONEDA
                        REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.Mes, 1>             = Y.FEC.MES
                        FOR I.DEP = 1 TO DCOUNT(Y.STR.COD.TRANS, VM)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.CodTrans, 1, -1>    = FIELD(Y.STR.COD.TRANS, VM, I.DEP)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.NoTrans, 1, -1>     = FIELD(Y.STR.NO.TRANS, VM, I.DEP)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.MtoTrans, 1, -1>    = FIELD(Y.STR.MTO.TRANS, VM, I.DEP)
                        NEXT
*----------------------------------
                        FOR I.MOV.DEP = 1 TO DCOUNT(Y.STR.MOV.DEP, VM)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.MovDep, 1, -1>    = FIELD(Y.STR.MOV.DEP, VM, I.MOV.DEP)
                        NEXT
*----------------------------------
                        FOR I.DEP.LN = 1 TO DCOUNT(Y.STR.COD.TRANS.LN, VM)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.CodTransLn, 1, -1> = FIELD(Y.STR.COD.TRANS.LN, VM, I.DEP.LN)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.MtoTransLn, 1, -1> = FIELD(Y.STR.MTO.TRANS.LN, VM, I.DEP.LN)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.FolTransLn, 1, -1> = FIELD(Y.STR.FOL.TRANS.LN, VM, I.DEP.LN)
                            REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.FecTransLn, 1, -1> = FIELD(Y.STR.FEC.TRANS.LN, VM, I.DEP.LN)
                        NEXT
 
                    END
                    TNO = EB.SystemTables.getTno()
                    OPERATOR = EB.SystemTables.getOperator()
                    REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.CurrNo>    = Y.CURR.NO + 1
                    REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.Inputter>   = TNO:'_':OPERATOR
                    REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.Authoriser> = TNO:'_':OPERATOR
                    YTIME = TIMEDATE()
                    REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.DateTime>  = TODAY[3,6]:YTIME[1,2]:YTIME[4,2]
                    REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.CoCode>    = 'MX0010001'
                    R.USER = EB.SystemTables.getRUser()
                    YDEPT.CURR.USER = R.USER<EB.Security.User.UseDepartmentCode>[1,9]
                    REC.MOV.ANUAL<AbcTable.AbcIdeTransAnual.DeptCode>  = YDEPT.CURR.USER

                    WRITE REC.MOV.ANUAL TO F.ABC.IDE.TRANS.ANUAL, Y.CLI.MES:'.':Y.FEC.PER
                END
            END
        NEXT
    END


RETURN




*==========
INICIO:
*==========
    F.ABC.IDE.TRANS.MENSUAL = ''
    FN.ABC.IDE.TRANS.MENSUAL = 'F.ABC.IDE.TRANS.MENSUAL'
    EB.DataAccess.Opf(FN.ABC.IDE.TRANS.MENSUAL, F.ABC.IDE.TRANS.MENSUAL)

    F.ABC.IDE.TRANS.ANUAL = ''
    FN.ABC.IDE.TRANS.ANUAL = 'F.ABC.IDE.TRANS.ANUAL'
    EB.DataAccess.Opf(FN.ABC.IDE.TRANS.ANUAL, F.ABC.IDE.TRANS.ANUAL)

    CAD.LOG = ''

RETURN
END

