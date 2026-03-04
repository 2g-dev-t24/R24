* @ValidationCode : MjotNjc3OTExMTA5OkNwMTI1MjoxNzYyOTE2OTYxMTM2Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Nov 2025 00:09:21
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

SUBROUTINE ABC.2BR.FECHA.DIA

*-----------------------------------------------------------------------------
    
    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.Display

    Y.OPERADOR      = EB.SystemTables.getOperator()
    Y.FECHA.DIA     = EB.SystemTables.getToday()
    Y.FECHA.HORA    = TIMEDATE()
    Y.HORA          = Y.FECHA.HORA[1,8]
    TODAY           = EB.SystemTables.getToday()
    PGM.VERSION     = EB.SystemTables.getPgmVersion()
    Y.ESTADO        = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Estado)
    Y.CONTADOR      = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Contador)

    IF PGM.VERSION EQ ",TRAMITE.BOVEDA" THEN
        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrAprueba, Y.OPERADOR)
        Y.CONTADOR = Y.CONTADOR + 1
        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Contador, Y.CONTADOR)

        IF Y.ESTADO NE "S" THEN
            Y.MSG = "SOLICITUD YA PROCESADA"
            E = Y.MSG
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
            EB.SystemTables.setIdNew("")
            RETURN
        END
    
    END ELSE
        IF PGM.VERSION EQ ",RECHAZO.BOVEDA" THEN

            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.FechaRechazo, Y.FECHA.DIA)
            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.HoraRechazo, Y.HORA)
            IF (Y.ESTADO NE "S") AND (Y.ESTADO NE "A") THEN
                Y.MSG = "SOLICITUD YA PROCESADA"
                E = Y.MSG
                EB.SystemTables.setE(E)
                EB.ErrorProcessing.Err()
                EB.SystemTables.setIdNew("")
                RETURN
            END
            
            EB.SystemTables.setRNew(AAbcTable.Abc2brBovedas.Estado, "R")
            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrRechaza, Y.OPERADOR)
        END ELSE
            IF PGM.VERSION EQ ",RECEPCION.BOVEDA" THEN
                EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrRecibe, Y.OPERADOR)
                Y.CONTADOR = Y.CONTADOR + 1
                EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Contador, Y.CONTADOR)

                IF Y.ESTADO NE "T" THEN
                    Y.MSG = "SOLICITUD YA PROCESADA"
                    E = Y.MSG
                    EB.SystemTables.setE(E)
                    EB.ErrorProcessing.Err()
                    EB.SystemTables.setIdNew("")
                    RETURN
                END
            END ELSE
                IF PGM.VERSION EQ ",TRAMITE.CONCENTRACION" THEN
                    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.FechaRecepcion, TODAY)
                    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.HoraRecepcion, Y.HORA)
                    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrRecibe, Y.OPERADOR)
                    Y.CONTADOR = Y.CONTADOR + 1
                    EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Contador, Y.CONTADOR)
                    IF Y.ESTADO NE "P" THEN
                        Y.MSG = "SOLICITUD YA PROCESADA"
                        E = Y.MSG
                        EB.SystemTables.setE(E)
                        EB.ErrorProcessing.Err()
                        EB.SystemTables.setIdNew("")
                        RETURN
                    END
                END ELSE
                    IF PGM.VERSION EQ ",AUTORIZACION.CONCENTRACION" THEN
                        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.FechaLiquidacion, TODAY)
                        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.HoraLiquidacion, Y.HORA)
                        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrAprueba, Y.OPERADOR)
                        Y.CONTADOR = Y.CONTADOR + 1
                        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Contador, Y.CONTADOR)
                        IF Y.ESTADO NE "S" THEN
                            Y.MSG = "SOLICITUD YA PROCESADA"
                            E = Y.MSG
                            EB.SystemTables.setE(E)
                            EB.ErrorProcessing.Err()
                            EB.SystemTables.setIdNew("")
                            RETURN
                        END
                        EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Estado, "A")
                    END ELSE
                        IF PGM.VERSION EQ ",CONCENTRACION.BOVEDA" THEN
                            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.FechaRechazo, TODAY)
                            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.HoraRechazo, Y.HORA)
                            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.UsrRechaza, Y.OPERADOR)
                            Y.CONTADOR = Y.CONTADOR + 1
                            EB.SystemTables.setRNew(AbcTable.Abc2brBovedas.Contador, Y.CONTADOR)
                            IF Y.ESTADO NE "A" THEN
                                Y.MSG = "SOLICITUD YA PROCESADA"
                                E = Y.MSG
                                EB.SystemTables.setE(E)
                                EB.ErrorProcessing.Err()
                                EB.SystemTables.setIdNew("")
                                RETURN
                            END
                        END
                    END
                END
            END
        END
    END
    
    EB.Display.RebuildScreen()

RETURN
**********
END


