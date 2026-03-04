* @ValidationCode : MjoxNTQwMjQ3MDI1OkNwMTI1MjoxNzU5MDAyNzUxNTc5OmVuem9jb3JpbzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Sep 2025 16:52:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : enzocorio
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CANCELACION.TARJ.GAR
*======================================================================================
* Nombre de Programa : ABC.CANCELACION.TARJ.GAR
* Objetivo           : Rutina que actualiza el EB.LOOKUP de la cuenta eje.
*======================================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.Template
    $USING AA.Framework
    
    GOSUB INICIALIZA
    GOSUB PROCESAR

RETURN

***********
INICIALIZA:
***********

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

    Y.ID.ARR = EB.SystemTables.getRNew(AA.Framework.ArrangementActivity.ArrActArrangement)
    EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ID.ARR, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, ERR.AA.ARRANGEMENT)

    Y.ID.CUENTA = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedApplId>
    R.ABC.ACCT.LCL.FLDS = ''
    ERR.ABC.ACCT.LCL.FLDS = ''

RETURN

*************************
PROCESAR:
*************************

    IF Y.ID.CUENTA EQ '' THEN
        ETEXT = "EL REGISTRO DE LA CUENTA " :Y.ID.CUENTA: " NO EXISTE"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        Y.ID.EB.LOOKUP = "ACLK*":Y.ID.CUENTA
        GOSUB GUARDA.CANCELACION
    END

RETURN

*******************
GUARDA.CANCELACION:
*******************

    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)
    IF R.EB.LOOKUP THEN
        R.EB.LOOKUP<EB.Template.Lookup.LuDescription> = 'CANCELADA'
        R.EB.LOOKUP<EB.Template.Lookup.LuDataName> = ''
        R.EB.LOOKUP<EB.Template.Lookup.LuDataValue> = ''

        EB.DataAccess.FWrite(FN.EB.LOOKUP,Y.ID.EB.LOOKUP,R.EB.LOOKUP)
    END

RETURN

END
