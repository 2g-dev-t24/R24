* @ValidationCode : MjoxNDY3NjM4MjQ0OkNwMTI1MjoxNzU4MDc1MjYzNTk0Om1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Sep 2025 23:14:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcUdis
SUBROUTINE ABC.HIS.NIVEL.LIMITE
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.HIS.NIVEL.LIMITE
* Objetivo:             Rutina que envia a historico
*      del registro
* Desarrollador:        Cesar Alejandro Miranda Bravo - FyG Solutions   (CAMB)
* Compania:             ABC CAPITAL
* Fecha Creacion:       18 - May - 2020
* Modificaciones:
*-----------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.API
    $USING AbcTable
    $USING AbcSpei
    $USING EB.Utility

******************************************************************************

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

*******************
INIT:
*******************

    Y.ULTIMO.MES    = EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)
    Y.ULTIMO.MES    = LEFT(Y.ULTIMO.MES, 6)
RETURN

*******************
OPENFILES:
*******************

    FN.ABC.MOVS.CTA.NIVEL2 = 'F.ABC.MOVS.CTA.NIVEL2'
    F.ABC.MOVS.CTA.NIVEL2 = ''
    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.NIVEL2,F.ABC.MOVS.CTA.NIVEL2)

    FN.ABC.MOVS.CTA.NIVEL2$HIS = 'F.ABC.MOVS.CTA.NIVEL2$HIS'
    F.ABC.MOVS.CTA.NIVEL2$HIS = ''
    EB.DataAccess.Opf(FN.ABC.MOVS.CTA.NIVEL2$HIS,F.ABC.MOVS.CTA.NIVEL2$HIS)

RETURN

********
PROCESS:
********

    SEL.LIVE = 'SELECT ':FN.ABC.MOVS.CTA.NIVEL2:' WITH @ID LIKE ': DQUOTE('...':SQUOTE(Y.ULTIMO.MES)):' BY @ID '
    EB.DataAccess.Readlist(SEL.LIVE,Y.ID.LIST,'',Y.NUM.LIVE,'')

    IF Y.ID.LIST NE '' THEN
        FOR Y.AA =  1 TO Y.NUM.LIVE
            Y.LIVE.ID = Y.ID.LIST<Y.AA>
            EB.DataAccess.FRead(FN.ABC.MOVS.CTA.NIVEL2, Y.LIVE.ID, R.LIVE, F.ABC.MOVS.CTA.NIVEL2, Y.LIVE.ERR)
            GOSUB HIST.ARCH
        NEXT Y.AA

    END

RETURN

**********
HIST.ARCH:
**********

    GOSUB ESCRIBE.HIS
    EB.DataAccess.FDelete(FN.ABC.MOVS.CTA.NIVEL2,Y.LIVE.ID)

RETURN

************
ESCRIBE.HIS:
************

    Y.LIVE.ID.HIS = Y.LIVE.ID:';':1
    EB.DataAccess.FWrite(FN.ABC.MOVS.CTA.NIVEL2$HIS, Y.LIVE.ID.HIS,R.LIVE)

RETURN

END
