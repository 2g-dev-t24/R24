$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.GUARDA.BLOQUEO.TARJ.GAR
*======================================================================================
* Nombre de Programa : ABC.GUARDA.BLOQUEO.TARJ.GAR
* Objetivo           : Rutina que guarda o elimina el bloqueo de tarjeta garantizada seg�n
*                      el proceso invocado.
*======================================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING EB.Template

    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION EQ 'I' OR Y.FUNCTION EQ 'R' THEN
        GOSUB INICIALIZA
        GOSUB GUARDA.BLOQUEO
    END

    RETURN

***********
INICIALIZA:
***********

    Y.ID.TRANSACTION = ''
    Y.OFS.OPTIONS = ''
    Y.OFS.SOURCE = 'T24.GENERIC.UPLOAD'

    FN.EB.LOOKUP = 'F.EB.LOOKUP' ; F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)

    Y.CUENTA = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckAccountNumber)
    Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA

    Y.OFS.VER = 'ACCOUNT.CLOSURE,ABC.DIGITAL.TCG'

    RETURN

***************
GUARDA.BLOQUEO:
***************
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)

    IF R.EB.LOOKUP THEN
        Y.DESCRIPTION = R.EB.LOOKUP<EB.Template.Lookup.LuDescription>
        Y.CUENTA.GAR = R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo>
    END

    IF Y.FUNCTION EQ 'I' THEN
        R.EB.LOOKUP<EB.Template.Lookup.LuDescription> = 'SOLICITADA'
        R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo> = ''
        R.EB.LOOKUP<EB.Template.Lookup.LuDataName> = 'TARJGAR'
        R.EB.LOOKUP<EB.Template.Lookup.LuDataValue> = EB.SystemTables.getIdNew()

        EB.DataAccess.FWrite(FN.EB.LOOKUP,Y.ID.EB.LOOKUP,R.EB.LOOKUP)
    END

    IF Y.FUNCTION EQ 'R' THEN
        IF Y.DESCRIPTION EQ 'SOLICITADA' THEN
            R.EB.LOOKUP<EB.Template.Lookup.LuDescription> = 'CANCELADA'
            R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo> = ''
            R.EB.LOOKUP<EB.Template.Lookup.LuDataName> = ''
            R.EB.LOOKUP<EB.Template.Lookup.LuDataValue> = ''

            EB.DataAccess.FWrite(FN.EB.LOOKUP,Y.ID.EB.LOOKUP,R.EB.LOOKUP)
        END ELSE
            IF Y.DESCRIPTION EQ 'APLICADA' THEN
                ETEXT = "OPERACION NO PERMITIDA SE APLICO TRASPASO: " :R.EB.LOOKUP<EB.Template.Lookup.LuDataValue>
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                IF Y.DESCRIPTION EQ 'AUTORIZADA' THEN
                    GOSUB CIERRA.CUENTA
                END
            END
        END
    END

    RETURN

**************
CIERRA.CUENTA:
**************

* OFS.MSG = Y.OFS.VER :'/I/PROCESS,,':Y.CUENTA.GAR
* CALL ofs.addLocalRequest(OFS.MSG, "add", Y.RTN.ERR)

*    Y.OFS = Y.OFS.VER:"/I/PROCESS/0/0/,//MX0010001/////,":Y.CUENTA.GAR

*    CALL OFS.POST.MESSAGE(Y.OFS,Y.ID.TRANSACTION,Y.OFS.SOURCE,Y.OFS.OPTIONS)

    RETURN

END
