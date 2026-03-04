* @ValidationCode : MjotMjEwNzcwNjA4NTpDcDEyNTI6MTc1OTc4MTk3NjU2MzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Oct 2025 17:19:36
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

SUBROUTINE ABC.IPAB.TABLA.6

    $USING EB.DataAccess
    $USING EB.TransactionControl
    $USING AbcTable
    $USING ST.Config

    GOSUB INITIALISATION      ;* file opening, variable set up
    GOSUB MAIN.PROCESS        ;* main subroutine processing

RETURN

*-----------------------------------------------------------------------------

*** <region name= INITIALISATION>
INITIALISATION:
*** <desc>file opening, variable set up</desc>

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    EB.DataAccess.Opf(FN.CATEGORY,F.CATEGORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.ABC.IPAB.PARAM = 'F.ABC.IPAB.PARAM'
    F.ABC.IPAB.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.PARAM,F.ABC.IPAB.PARAM)

    FN.ABC.FILE.MAPPING = 'F.ABC.FILE.MAPPING'
    F.ABC.FILE.MAPPING = ''
    EB.DataAccess.Opf(FN.ABC.FILE.MAPPING,F.ABC.FILE.MAPPING)

    FN.ABC.FILE.REPORT.TMP = 'F.ABC.FILE.REPORT.TMP'
    F.ABC.FILE.REPORT.TMP = ''
    EB.DataAccess.Opf(FN.ABC.FILE.REPORT.TMP,F.ABC.FILE.REPORT.TMP)

    ABC.FILE.MAPPING.ID = 'TABLA.6'
    Y.SPACE = ' '
    Y.SEP = '|'
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>main subroutine processing</desc>

    EB.DataAccess.CacheRead(FN.ABC.FILE.MAPPING,ABC.FILE.MAPPING.ID,R.ABC.FILE.MAPPING,YERR)

    Y.FM.MAIN.APPLICATION = R.ABC.FILE.MAPPING<AbcTable.AbcFileMapping.MainApplication>
    Y.FM.FIXED.SELECTION = R.ABC.FILE.MAPPING<AbcTable.AbcFileMapping.FixedSelection>
    Y.FM.FIELD.NAME = R.ABC.FILE.MAPPING<AbcTable.AbcFileMapping.FieldName>

    FN.APP  = 'F.':Y.FM.MAIN.APPLICATION
    F.APP = ''

    EB.DataAccess.Opf(FN.APP,F.APP)

    IF Y.FM.FIXED.SELECTION THEN

        Y.FM.FIXED.SELECTION = Y.SPACE : Y.FM.FIXED.SELECTION

    END

    SELECT.STATEMENT  = 'SSELECT ': FN.APP :
    SELECT.STATEMENT := Y.FM.FIXED.SELECTION

    APP.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    EB.DataAccess.Readlist(SELECT.STATEMENT,APP.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    GOSUB SET.REGISTRO        ;*

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= SET.REGISTRO>
SET.REGISTRO:
***

    LOOP
        REMOVE APP.ID FROM APP.LIST SETTING APP.MARK
    WHILE APP.ID : APP.MARK

        CATEGORY.ID = APP.ID
        GOSUB GET.CATEGORY.DATA         ;*

        GOSUB WRITE.REGISTRO            ;*

    REPEAT

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.CATEGORY.DATA>
GET.CATEGORY.DATA:
***

    ABC.IPAB.PARAM.ID = 'SYSTEM'
    EB.DataAccess.CacheRead(FN.ABC.IPAB.PARAM,ABC.IPAB.PARAM.ID,R.ABC.IPAB.PARAM,YERR)

    CATEGORIAS      = R.ABC.IPAB.PARAM<AbcTable.AbcIpabParam.Categoria>
    CLASIFICACIONES = R.ABC.IPAB.PARAM<AbcTable.AbcIpabParam.Clasificacion>
    PRODUCTOS       = R.ABC.IPAB.PARAM<AbcTable.AbcIpabParam.Producto>

    FIND CATEGORY.ID IN CATEGORIAS SETTING Ap,Vp,Sp THEN
        CLASIFICACION = CLASIFICACIONES<Ap,Vp>
        PRODUCTO = PRODUCTOS<Ap,Vp>
    END ELSE
        RETURN
    END

    EB.DataAccess.CacheRead(FN.CATEGORY,CATEGORY.ID,R.CATEGORY,YERR)

    DESCRIPTION = R.CATEGORY<ST.Config.Category.EbCatDescription>
    MAX.DESCRIPTION = DCOUNT(DESCRIPTION,VM)

    IF MAX.DESCRIPTION EQ 4 THEN
        NOMBRE.PRODUCTO = FIELD(DESCRIPTION,VM,4)
    END ELSE
        NOMBRE.PRODUCTO = FIELD(DESCRIPTION,VM,1)
    END

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= WRITE.REGISTRO>
WRITE.REGISTRO:
***

    ID = ABC.FILE.MAPPING.ID :'*': CATEGORY.ID

    Y.REGISTRO = CATEGORY.ID : Y.SEP
    Y.REGISTRO := NOMBRE.PRODUCTO : Y.SEP
    Y.REGISTRO := CLASIFICACION : Y.SEP
    Y.REGISTRO := PRODUCTO

    EB.DataAccess.FWrite(FN.ABC.FILE.REPORT.TMP, ID, Y.REGISTRO)

    EB.TransactionControl.JournalUpdate(ID)
    
    Y.REGISTRO = ''

RETURN
*** </region>
END
