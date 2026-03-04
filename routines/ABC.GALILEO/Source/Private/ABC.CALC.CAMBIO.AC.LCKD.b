*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.CALC.CAMBIO.AC.LCKD
*===============================================================================
* Nombre de Programa : ABC.CALC.CAMBIO.AC.LCKD
* Objetivo           : Rutina para retenciones de compra que calcula el tipo de cambio
*                      cuando se hace una compra en comercio
* Tipo de cambio= Monto en pesos / Monto en moneda original
*===============================================================================

    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening

    GOSUB INICIALIZA
    GOSUB CALC.TIPO.CAMBIO
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------
    
    Y.APP = 'AC.LOCKED.EVENTS'
    Y.FLD = "ORIG.AMOUNT":@VM:"ORIG.CURRENCY":@VM:"TIPO.CAMB"
    Y.POS.FLD = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)

    POS.ORIG.MONTO = Y.POS.FLD<1,1>
    POS.ORIG.CURRN = Y.POS.FLD<1,2>
    POS.TIPO.CAMB  = Y.POS.FLD<1,3>

    Y.MONTO.MXN = ''
    Y.MONTO.ORI = ''
    Y.MONED.ORI = ''
    Y.TIPO.CAMB = ''
    Y.COMISION  = ''

    RETURN
*---------------------------------------------------------------
CALC.TIPO.CAMBIO:
*---------------------------------------------------------------
    Y.LOCAL.REF = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)
    Y.MONTO.ORI = Y.LOCAL.REF<1, POS.ORIG.MONTO>
    Y.MONED.ORI = Y.LOCAL.REF<1, POS.ORIG.CURRN>
    Y.MONTO.MXN = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLockedAmount)

    IF EB.SystemTables.getVFunction() EQ 'R' THEN RETURN ELSE

        IF (Y.MONTO.ORI NE '') AND (Y.MONED.ORI NE '') THEN
            Y.TIPO.CAMB = Y.MONTO.MXN / Y.MONTO.ORI
            Y.TIPO.CAMB = DROUND(Y.TIPO.CAMB, 2)

            Y.LOCAL.REF<1, POS.TIPO.CAMB> = Y.TIPO.CAMB

            EB.SystemTables.setRNew(AC.AccountOpening.LockedEvents.LckLocalRef, Y.LOCAL.REF)
        END ELSE
            Y.LOCAL.REF<1, POS.ORIG.CURRN> = ''
            Y.LOCAL.REF<1, POS.ORIG.MONTO> = ''

            EB.SystemTables.setRNew(AC.AccountOpening.LockedEvents.LckLocalRef, Y.LOCAL.REF)
        END
    END

    RETURN
