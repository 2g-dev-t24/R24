* @ValidationCode : MjotMTkxNDMwNTQ0NTpDcDEyNTI6MTc3MTU1Mzk0NDMwMzpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Feb 2026 23:19:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.TRAE.GENERAL.PARAM(Y.ID.MOD, Y.CADENA.PARAM, Y.CADENA.DATOS)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.DataAccess

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*---------------------------------------------------
INITIALIZE:
*---------------------------------------------------
    Y.MODULO = Y.ID.MOD
    Y.CAMPOS = Y.CADENA.PARAM
    Y.SEPARADOR = "#"
    Y.DATOS = ""
RETURN

*---------------------------------------------------
OPEN.FILES:
*---------------------------------------------------
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)
RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------
    Y.NUM.BUSCADOS = DCOUNT(Y.CAMPOS, Y.SEPARADOR)
    Y.DATOS.ENCONTRADOS = ""
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.MODULO,R.PARAMETROS,F.ABC.GENERAL.PARAM,GRL.ERR)
    Y.NUM.PARAMS = DCOUNT(R.PARAMETROS<2>,VM)
*AbcTable.AbcGeneralParam.NombParametro
    FOR Y.J = 1 TO Y.NUM.BUSCADOS
        Y.PARAM.BUSCADO = FIELD(Y.CAMPOS,Y.SEPARADOR,Y.J)
        Y.ENCONTRADO = 0
        FOR Y.I = 1 TO Y.NUM.PARAMS
            Y.NOM.PARAMETRO = R.PARAMETROS<2,Y.I>
*            AbcTable.AbcGeneralParam.NombParametro
            Y.DAT.PARAMETRO = R.PARAMETROS<3,Y.I>
*AbcTable.AbcGeneralParam.DatoParametro
            IF Y.PARAM.BUSCADO EQ Y.NOM.PARAMETRO THEN
                Y.DATOS.ENCONTRADOS := Y.DAT.PARAMETRO : Y.SEPARADOR
                Y.ENCONTRADO = 1
            END
        NEXT Y.I
        IF Y.ENCONTRADO NE 1 THEN
            Y.DATOS.ENCONTRADOS := Y.SEPARADOR
        END
    NEXT Y.J
    Y.CADENA.DATOS = Y.DATOS.ENCONTRADOS
RETURN
END