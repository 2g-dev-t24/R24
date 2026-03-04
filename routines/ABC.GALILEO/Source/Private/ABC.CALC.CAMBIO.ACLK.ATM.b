* @ValidationCode : Mjo3NTY5NzIzMzE6Q3AxMjUyOjE3NjMwNzAwODE0ODM6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Nov 2025 18:41:21
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
*-----------------------------------------------------------------------------
* <Rating>80</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
SUBROUTINE ABC.CALC.CAMBIO.ACLK.ATM
*===============================================================================
* Nombre de Programa : ABC.CALC.CAMBIO.ACLK.ATM
* Objetivo           : Rutina para bloqueos de cajero que calcula el tipo de cambio
*                      cuando se hace una retiro en cajero
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

    LREF.TABLE = "AC.LOCKED.EVENTS"
    LREF.FIELD = "ORIG.AMOUNT":@VM:"ORIG.CURRENCY":@VM:"TIPO.CAMB":@VM:"COMISION"
    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)
    POS.ORIG.MONTO   = LREF.POS<1,1>
    POS.ORIG.CURRN   = LREF.POS<1,2>
    POS.TIPO.CAMB    = LREF.POS<1,3>
    POS.COMISION     = LREF.POS<1,4>

    Y.MONTO.MXN = ''
    Y.MONTO.ORI = ''
    Y.MONED.ORI = ''
    Y.TIPO.CAMB = 0
    Y.COMISION  = 0

    Y.LOCAL.REF = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)

RETURN
*---------------------------------------------------------------
CALC.TIPO.CAMBIO:
*---------------------------------------------------------------

    Y.MONTO.ORI = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)<1, POS.ORIG.MONTO>
    Y.MONED.ORI = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)<1, POS.ORIG.CURRN>
    Y.COMISION = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)<1, POS.COMISION>
    Y.MONTO.MXN = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLockedAmount)

    IF EB.SystemTables.getVFunction() EQ 'R' THEN RETURN ELSE

        IF (Y.MONTO.ORI NE '') AND (Y.MONED.ORI NE '') THEN
            Y.TIPO.CAMB = (Y.MONTO.MXN - Y.COMISION) / Y.MONTO.ORI
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
