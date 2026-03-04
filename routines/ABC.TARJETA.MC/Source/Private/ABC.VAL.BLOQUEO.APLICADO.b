$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.VAL.BLOQUEO.APLICADO
*======================================================================================
* Nombre de Programa : ABC.VAL.BLOQUEO.APLICADO
* Objetivo           : Rutina que valida si el bloqueo ya fue aplicado a la cuenta garantizada.
*======================================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING EB.Template

    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'R' THEN
        GOSUB INICIALIZA
        GOSUB VALIDA.BLOQUEO
    END

    RETURN

***********
INICIALIZA:
***********

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS' ; F.AC.LOCKED.EVENTS = '' 
    EB.DataAccess.Opf(FN.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS)

    FN.AC.LOCKED.EVENTS$HIS = 'F.AC.LOCKED.EVENTS$HIS' ; F.AC.LOCKED.EVENTS$HIS = ''
    EB.DataAccess.Opf(FN.AC.LOCKED.EVENTS$HIS, F.AC.LOCKED.EVENTS$HIS)

    FN.EB.LOOKUP = 'F.EB.LOOKUP' ; F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)

    RETURN

***************
VALIDA.BLOQUEO:
***************
    Y.COMI = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.AC.LOCKED.EVENTS,Y.COMI,R.AC.LOCK,F.AC.LOCKED.EVENTS,AC.LOCK.ERR)
    IF R.AC.LOCK EQ '' THEN
        EB.DataAccess.FReadHistory(FN.AC.LOCKED.EVENTS$HIS,Y.COMI,R.AC.LOCK,F.AC.LOCKED.EVENTS$HIS,AC.LOCK.ERR)
    END
    IF R.AC.LOCK THEN
        Y.CUENTA = R.AC.LOCK<AC.AccountOpening.LockedEvents.LckAccountNumber>
        Y.STATUS = R.AC.LOCK<AC.AccountOpening.LockedEvents.LckRecordStatus>
    END ELSE
        ETEXT = "Error, operacion no permitida, no existe el bloqueo"
        EB.SystemTables.setE(ETEXT)
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()

    END

    IF Y.STATUS EQ 'REVE' THEN
        Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA
        EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)
        IF R.EB.LOOKUP THEN
            Y.DESCRIPTION = R.EB.LOOKUP<EB.Template.Lookup.LuDescription>
            Y.DATA.NAME.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataName>
            Y.DATA.VALUE.LIST = R.EB.LOOKUP<EB.Template.Lookup.LuDataValue>

            LOCATE "TARJGAR" IN Y.DATA.NAME.LIST SETTING POS THEN
                Y.DATA.VALUE = Y.DATA.VALUE.LIST<POS>
            END

            IF Y.DESCRIPTION EQ 'APLICADA' THEN
                ETEXT = "Error, operacion no permitida, ya se aplico traspaso ":Y.DATA.VALUE
                EB.SystemTables.setE(ETEXT)
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END ELSE
                IF Y.DESCRIPTION EQ 'CANCELADA' THEN
                    ETEXT = "Error, operacion no permitida, el bloqueo fue cancelado"
                    EB.SystemTables.setE(ETEXT)
                    EB.SystemTables.setEtext(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END
            END
        END
    END

    RETURN

END
