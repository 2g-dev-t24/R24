* @ValidationCode : MjotMTkzMTMzNzEzNDpDcDEyNTI6MTc2NDA4NTg1Mzg4MzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Nov 2025 12:50:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.2BR.ACTUALIZA.SOL
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING TT.Contract
    $USING TT.Stock
    $USING AbcTable
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING AbcTeller
    $USING EB.Display
    
    $USING EB.Browser
*********
    GOSUB PROCESS
    
RETURN
*********
PROCESS:
*********
*******************************CAMB TEMPORAL INICIO*********************************************************
*    FECHA.FILE = FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4")
*    str_filename = "ABC.2BR.ACTUALIZA.SOL." : FECHA.FILE : ".log"
*    SEQ.FILE.NAME = @PATH : "/"

*    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
*        CREATE FILE.VAR1 ELSE
*        END
*    END
*********************************CAMB TEMPORAL FIN**********************************************************
*****
    ARREGLO.AVIABLE = AbcTeller.getarregloAviable()
***
    LINK.DATA = ARREGLO.AVIABLE

    Y.FECHA.DIA = EB.SystemTables.getToday()
    Y.FECHA.HORA = TIMEDATE()
    Y.HORA = Y.FECHA.HORA[1,8]
    Y.ID.BOV    = LINK.DATA<1>
    PGM.VERSION = EB.SystemTables.getPgmVersion()
    
    IF (Y.ID.BOV EQ '') OR (Y.ID.BOV EQ 0) THEN
        Y.VAR.NAME = 'CURRENT.LINK.DATA'
        LINK.DATA = EB.Browser.SystemGetvariable(Y.VAR.NAME)
        CONVERT "*" TO @FM IN LINK.DATA
        Y.ID.BOV    = LINK.DATA<1>
    END

    IF Y.ID.BOV THEN
*******************************CAMB TEMPORAL INICIO*********************************************************
*        MENSAJE = "LINK.DATA<1>: ":LINK.DATA<1>
*        GOSUB BITACORA
*********************************CAMB TEMPORAL FIN**********************************************************
        F.ABC.2BR.BOVEDAS = ""
        FN.ABC.2BR.BOVEDAS = "F.ABC.2BR.BOVEDAS"
        EB.DataAccess.Opf(FN.ABC.2BR.BOVEDAS,F.ABC.2BR.BOVEDAS)

        F.TT.STOCK.CONTROL = ""
        FN.TT.STOCK.CONTROL = "F.TT.STOCK.CONTROL"
        EB.DataAccess.Opf(FN.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL)
        
        Y.REG   = ''
        EB.DataAccess.FRead(FN.ABC.2BR.BOVEDAS, Y.ID.BOV, Y.REG, F.ABC.2BR.BOVEDAS, ERR.BOV)

        IF (Y.REG) THEN
            IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.BOV" THEN
                Y.REG<AbcTable.Abc2brBovedas.Estado> = "T"
                Y.REG<AbcTable.Abc2brBovedas.UsrAprueba> = EB.SystemTables.getOperator()
                Y.REG<AbcTable.Abc2brBovedas.FechaLiquidacion> = Y.FECHA.DIA
                Y.REG<AbcTable.Abc2brBovedas.HoraLiquidacion> = Y.HORA
*******************************CAMB TEMPORAL INICIO*********************************************************
*                MENSAJE = "PGM.VERSION: ":EB.SystemTables.getPgmVersion()
*                GOSUB BITACORA
*                MENSAJE = "Y.REG<BVD.ESTADO>: ":Y.REG<AbcTable.Abc2brBovedas.Estado>
*                GOSUB BITACORA
*********************************CAMB TEMPORAL FIN**********************************************************
            END ELSE
                IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.BOV.INT" THEN
                    Y.REG<AbcTable.Abc2brBovedas.Estado> = "P"
                    Y.REG<AbcTable.Abc2brBovedas.UsrAprueba> = EB.SystemTables.getOperator()
                    Y.REG<AbcTable.Abc2brBovedas.FechaLiquidacion> = Y.FECHA.DIA
                    Y.REG<AbcTable.Abc2brBovedas.HoraLiquidacion> = Y.HORA
*******************************CAMB TEMPORAL INICIO*********************************************************
*                    MENSAJE = "PGM.VERSION: ":EB.SystemTables.getPgmVersion()
*                    GOSUB BITACORA
*                    MENSAJE = "Y.REG<BVD.ESTADO>: ":Y.REG<AbcTable.Abc2brBovedas.Estado>
*                    GOSUB BITACORA
*********************************CAMB TEMPORAL FIN**********************************************************
                END ELSE
                    IF PGM.VERSION EQ ",ABC.2BR.EM.TILLCONCEN.BOV" THEN
                        Y.REG<AbcTable.Abc2brBovedas.Estado> = "F"
                        Y.REG<AbcTable.Abc2brBovedas.UsrRecibe> = EB.SystemTables.getOperator()
                        Y.REG<AbcTable.Abc2brBovedas.FechaRecepcion> = Y.FECHA.DIA
                        Y.REG<AbcTable.Abc2brBovedas.HoraRecepcion> = Y.HORA
*******************************CAMB TEMPORAL INICIO*********************************************************
*                        MENSAJE = "PGM.VERSION: ":EB.SystemTables.getPgmVersion()
*                        GOSUB BITACORA
*                        MENSAJE = "Y.REG<BVD.ESTADO>: ":Y.REG<AbcTable.Abc2brBovedas.Estado>
*                        GOSUB BITACORA
*********************************CAMB TEMPORAL FIN**********************************************************
                    END ELSE
                        IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.1.BOV" THEN
                            Y.REG<AbcTable.Abc2brBovedas.Estado> = "P"
                            Y.REG<AbcTable.Abc2brBovedas.UsrRechaza> = EB.SystemTables.getOperator()
                            Y.REG<AbcTable.Abc2brBovedas.FechaRechazo> = Y.FECHA.DIA
                            Y.REG<AbcTable.Abc2brBovedas.HoraRechazo> = Y.HORA
*******************************CAMB TEMPORAL INICIO*********************************************************
*                            MENSAJE = "PGM.VERSION: ":EB.SystemTables.getPgmVersion()
*                            GOSUB BITACORA
*                            MENSAJE = "Y.REG<BVD.ESTADO>: ":Y.REG<AbcTable.Abc2brBovedas.Estado>
*                            GOSUB BITACORA
*********************************CAMB TEMPORAL FIN**********************************************************
                        END ELSE
                            IF PGM.VERSION EQ ",ABC.2BR.EM.TILLCONCEN.1.BOV" THEN
                                Y.REG<AbcTable.Abc2brBovedas.Estado> = "F"
                                Y.REG<AbcTable.Abc2brBovedas.UsrRecibe> = EB.SystemTables.getOperator()
                                Y.REG<AbcTable.Abc2brBovedas.FechaRecepcion> = Y.FECHA.DIA
                                Y.REG<AbcTable.Abc2brBovedas.HoraRecepcion> = Y.HORA
*******************************CAMB TEMPORAL INICIO*********************************************************
*                                MENSAJE = "PGM.VERSION: ":EB.SystemTables.getPgmVersion()
*                                GOSUB BITACORA
*                                MENSAJE = "Y.REG<BVD.ESTADO>: ":Y.REG<AbcTable.Abc2brBovedas.Estado>
*                                GOSUB BITACORA
*********************************CAMB TEMPORAL FIN**********************************************************
                            END
                        END
                    END
                END
            END
            Y.REG<AbcTable.Abc2brBovedas.Referencia> = EB.SystemTables.getRNew( TT.Contract.Teller.TeTheirReference)
            EB.DataAccess.FWrite(FN.ABC.2BR.BOVEDAS, Y.ID.BOV, Y.REG)
        END
*******************************CAMB TEMPORAL INICIO*********************************************************
*        MENSAJE = "Y.REG: ":Y.REG
*        GOSUB BITACORA
*********************************CAMB TEMPORAL FIN**********************************************************

        Y.CTA.DEBIT = LINK.DATA<3>
        Y.CTA.CREDIT = LINK.DATA<4>

        Y.DEN = LINK.DATA<5>
        Y.CAN = LINK.DATA<6>

        CONVERT "|" TO @FM IN Y.DEN
        CONVERT "|" TO @FM IN Y.CAN

        Y.TOT.DEN = DCOUNT(Y.DEN, @FM)

        Y.DEN.CAP = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
        Y.DEN.CAP.DR = EB.SystemTables.getRNew(T.Contract.Teller.TeDrDenom)
        Y.CAN.CAP = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
        Y.CAN.CAP.DR = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)

        IF Y.CTA.DEBIT NE "" THEN
            Y.SUM.CAP = SUM(Y.CAN.CAP.DR)
            Y.SUM = SUM(Y.CAN)
            IF Y.SUM.CAP NE Y.SUM THEN
                ETEXT = "DENOMINACIONES DIFERENTES"
                EB.SystemTables.setEtext(ETEXT)
                E   = ETEXT
                EB.SystemTables.setE(E)
                EB.SystemTables.setAf(TT.Contract.Teller.TeUnit)
                EB.SystemTables.setAv(1)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END

        IF Y.CTA.CREDIT NE "" THEN
            Y.SUM.CAP = SUM(Y.CAN.CAP)
            Y.SUM = SUM(Y.CAN)
            IF Y.SUM.CAP NE Y.SUM THEN
                ETEXT = "DENOMINACIONES DIFERENTES"
                EB.SystemTables.setEtext(ETEXT)
                E   = ETEXT
                EB.SystemTables.setE(E)
                EB.SystemTables.setAf(TT.Contract.Teller.TeUnit)
                EB.SystemTables.setAv(1)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END

        LINK.DATA = ""
        EB.Display.RebuildScreen()
    END

RETURN
*******************************CAMB TEMPORAL INICIO*********************************************************
*********
BITACORA:
*********

*    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR1 ELSE
*    END
*    MENSAJE = ''
RETURN
*********************************CAMB TEMPORAL FIN**********************************************************
END
