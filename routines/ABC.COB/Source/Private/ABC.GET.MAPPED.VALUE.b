* @ValidationCode : MjoxMDUxNDk5MjgzOkNwMTI1MjoxNzU5NzgyMTc0MDI0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Oct 2025 17:22:54
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
$PACKAGE AbcCob

SUBROUTINE ABC.GET.MAPPED.VALUE(Y.ID.ABC.GENERAL.MAPPING, Y.IN.VALUE, Y.VALUE.MAPPED, Y.ERROR)

    $USING EB.DataAccess
    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

RETURN

*** <region name= INITIALIZE>
INITIALIZE:
***

    Y.VALUE.MAPPED = ''
    Y.ERROR = ''

    F.ABC.GENERAL.MAPPING = ''
    FN.ABC.GENERAL.MAPPING = 'F.ABC.GENERAL.MAPPING'
    EB.DataAccess.Opf(FN.ABC.GENERAL.MAPPING,F.ABC.GENERAL.MAPPING)

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
***

    R.ABC.GENERAL.MAPPING = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.MAPPING,Y.ID.ABC.GENERAL.MAPPING,R.ABC.GENERAL.MAPPING,F.ABC.GENERAL.MAPPING,Y.ERR)
    IF R.ABC.GENERAL.MAPPING THEN
        Y.LIST.VALOR.ENTRADA = RAISE(R.ABC.GENERAL.MAPPING<AbcTable.AbcGeneralMapping.ValorEntrada>)
        Y.LIST.VALOR.T24.MAPEO = RAISE(R.ABC.GENERAL.MAPPING<AbcTable.AbcGeneralMapping.ValorT24Mapeo>)
        LOCATE Y.IN.VALUE IN Y.LIST.VALOR.ENTRADA SETTING Y.POS THEN
            Y.VALUE.MAPPED = Y.LIST.VALOR.T24.MAPEO<Y.POS>
        END ELSE
            Y.ERROR = 'VALOR NO MAPEADO [' : Y.IN.VALUE : '] ID NO ENCONTRADO [' : Y.ID.ABC.GENERAL.MAPPING : '] EN TABLA ' : FN.ABC.GENERAL.MAPPING
        END

    END ELSE
        Y.ERROR = 'ID NO ENCONTRADO [' : Y.ID.ABC.GENERAL.MAPPING : '] EN TABLA [' : FN.ABC.GENERAL.MAPPING
    END

RETURN
*** </region>

*** <region name= FINALIZE>
FINALIZE:
***

RETURN
*** </region>
END
