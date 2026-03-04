* @ValidationCode : MjoxNTgwNTYyNTEyOkNwMTI1MjoxNzYyOTIwMjk5MTU3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Nov 2025 01:04:59
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

SUBROUTINE ABC.2BR.ACTUALIZA.REC

*-----------------------------------------------------------------------------
    
    $USING EB.SystemTables
    $USING TT.Contract
    $USING TT.Stock
    $USING AbcTable
    $USING EB.DataAccess
    $USING EB.Display
    $USING EB.ErrorProcessing
    $USING AbcTeller
**************
    ARREGLO.AVIABLE = AbcTeller.getarregloAviable()
    LINK.DATA   = ARREGLO.AVIABLE
    Y.FECHA.DIA     = EB.SystemTables.getToday()
    Y.FECHA.HORA    = TIMEDATE()
    Y.HORA      = Y.FECHA.HORA[1,8]
    PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.ID.BOV    = LINK.DATA<7>

    IF Y.ID.BOV NE "" THEN
        F.ABC.2BR.BOVEDAS = ""
        FN.ABC.2BR.BOVEDAS = "F.ABC.2BR.BOVEDAS"
        EB.DataAccess.Opf(FN.ABC.2BR.BOVEDAS,F.ABC.2BR.BOVEDAS)

        F.TT.STOCK.CONTROL = ""
        FN.TT.STOCK.CONTROL = "F.TT.STOCK.CONTROL"
        EB.DataAccess.Opf(FN.TT.STOCK.CONTROL,F.TT.STOCK.CONTROL)
        
        Y.REG       = ''
        EB.DataAccess.FRead(F.ABC.2BR.BOVEDAS, Y.ID.BOV, Y.REG, F.ABC.2BR.BOVEDAS, Er)

        IF (Y.REG) THEN
            IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.BOV" THEN
                Y.REG<AbcTable.Abc2brBovedas.Estado> = "T"
                Y.REG<AbcTable.Abc2brBovedas.UsrAprueba> = EB.SystemTables.getOperator()
                Y.REG<AbcTable.Abc2brBovedas.FechaLiquidacion> = Y.FECHA.DIA
                Y.REG<AbcTable.Abc2brBovedas.HoraLiquidacion> = Y.HORA
            END ELSE
                IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.BOV.INT" THEN
                    Y.REG<AbcTable.Abc2brBovedas.Estado> = "T"
                    Y.REG<AbcTable.Abc2brBovedas.UsrAprueba> = EB.SystemTables.getOperator()
                    Y.REG<AbcTable.Abc2brBovedas.FechaLiquidacion> = Y.FECHA.DIA
                    Y.REG<AbcTable.Abc2brBovedas.HoraLiquidacion> = Y.HORA
                END ELSE
                    IF PGM.VERSION EQ ",ABC.2BR.EM.TILLCONCEN.BOV" THEN
                        Y.REG<AbcTable.Abc2brBovedas.Estado> = "F"
                        Y.REG<AbcTable.Abc2brBovedas.UsrRecibe> = EB.SystemTables.getOperator()
                        Y.REG<AbcTable.Abc2brBovedas.FechaRecepcion> = Y.FECHA.DIA
                        Y.REG<AbcTable.Abc2brBovedas.HoraRecepcion> = Y.HORA
                    END ELSE
                        IF PGM.VERSION EQ ",ABC.2BR.EM.TILLDOTACION.1.BOV" THEN
                            Y.REG<AbcTable.Abc2brBovedas.Estado> = "P"
                            Y.REG<AbcTable.Abc2brBovedas.UsrRechaza> = EB.SystemTables.getOperator()
                            Y.REG<AbcTable.Abc2brBovedas.FechaRechazo> = Y.FECHA.DIA
                            Y.REG<AbcTable.Abc2brBovedas.HoraRechazo> = Y.HORA
                        END ELSE
                            IF PGM.VERSION EQ ",ABC.2BR.EM.TILLCONCEN.1.BOV" THEN
                                Y.REG<AbcTable.Abc2brBovedas.Estado> = "F"
                                Y.REG<AbcTable.Abc2brBovedas.UsrRecibe> = EB.SystemTables.getOperator()
                                Y.REG<AbcTable.Abc2brBovedas.FechaRecepcion> = Y.FECHA.DIA
                                Y.REG<AbcTable.Abc2brBovedas.HoraRecepcion> = Y.HORA
                            END
                        END
                    END
                END
            END
        END

        Y.CTA.CREDIT = ''
        Y.CTA.DEBIT = LINK.DATA<6>
        X = LINK.DATA<9> * 10
        Y.DEN = LINK.DATA<X+3>
        Y.CAN = LINK.DATA<X+4>
        CONVERT "|" TO @FM IN Y.DEN
        CONVERT "|" TO @FM IN Y.CAN
        Y.TOT.DEN = DCOUNT(Y.DEN, @FM)
        Y.DEN.CAP = EB.SystemTables.getRNew(TT.Contract.Teller.TeDenomination)
        Y.DEN.CAP.DR = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
        Y.CAN.CAP = EB.SystemTables.getRNew(TT.Contract.Teller.TeUnit)
        Y.CAN.CAP.DR = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
        IF Y.CTA.DEBIT NE "" THEN
            Y.SUM.CAP = SUM(Y.CAN.CAP.DR)
            Y.SUM = SUM(Y.CAN)
            IF Y.SUM.CAP NE Y.SUM THEN
                ETEXT = "DENOMINACIONES DIFERENTES"
                EB.SystemTables.setEtext(ETEXT)
                E = ETEXT
                EB.SystemTables.setE(E)
                EB.SystemTables.setAf(TT.Contract.Teller.TeDrUnit)
                EB.SystemTables.setAv(1)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
        TT.REF  = EB.SystemTables.getRNew(TT.Contract.Teller.TeTheirReference)
        IF Y.REG<AbcTable.Abc2brBovedas.Referencia> NE TT.REF THEN
            ETEXT = "REFERENCIAS DIFERENTES"
            EB.SystemTables.setEtext(ETEXT)
            E = ETEXT
            EB.SystemTables.setE(E)
            EB.SystemTables.setAf(TT.Contract.Teller.TeTheirReference)
            EB.SystemTables.setAv(1)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
        EB.DataAccess.FWrite(FN.ABC.2BR.BOVEDAS, Y.ID.BOV, Y.REG)
        LINK.DATA = ""
    END
    EB.Display.RebuildScreen()

RETURN
**************
END
