* @ValidationCode : MjotMTA3NDg2MzU5MzpDcDEyNTI6MTc1ODY1NDY3OTkwNjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Sep 2025 16:11:19
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
$PACKAGE AbcTarjetaMc
*-----------------------------------------------------------------------------
SUBROUTINE ABC.GUARDA.CTA.TARJ.GAR
*======================================================================================
* Nombre de Programa : ABC.GUARDA.CTA.TARJ.GAR
* Objetivo           : Rutina que guarda la cuenta de tarjeta garantizada.
* Desarrollador      : C�sar Miranda - FyG Solutions
* Fecha Creacion     : 2024-02-01
* Modificaciones     :
*======================================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING AbcTable
    $USING AA.Framework



    GOSUB INICIALIZA
    GOSUB GUARDA.BLOQUEO

RETURN

***********
INICIALIZA:
***********

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)
    
    
    R.ARR = AA.Framework.getC_aalocarractivityrec()
    Y.CUENTA     = R.ARR<AA.Framework.ArrangementActivity.ArrActFieldValue,1,1>
    
    Y.ID.EB.LOOKUP = "ACLK*":Y.CUENTA
    
    R.ARR = AA.Framework.getC_aalocaccountdetails()
    
    R.ARR = AA.Framework.getC_aalocarrangementrec()
    
*Y.OTHER.ACCOUNT = R.ARR<AA.Framework.Arrangement.ArrLinkedApplId,1,1>
    Y.OTHER.ACCOUNT = R.ARR<14>


RETURN

***************
GUARDA.BLOQUEO:
***************
    EB.DataAccess.FRead(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR)

    IF R.EB.LOOKUP THEN

        R.EB.LOOKUP<EB.Template.Lookup.LuDescription> = 'AUTORIZADA'

        R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo> = Y.OTHER.ACCOUNT
            
        EB.DataAccess.FWrite(FN.EB.LOOKUP,Y.ID.EB.LOOKUP,R.EB.LOOKUP)
    END

RETURN

END
