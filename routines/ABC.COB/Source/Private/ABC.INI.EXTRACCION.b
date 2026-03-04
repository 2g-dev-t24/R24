* @ValidationCode : MjotNDg2ODQ1NTMyOkNwMTI1MjoxNzYwNTU5MTIwODM4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Oct 2025 17:12:00
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

SUBROUTINE ABC.INI.EXTRACCION
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.INI.EXTRACCION
* Objetivo:             Rutina inicial para la carga de parametros DATE.TIME para
*                       d�as inh�biles
* Desarrollador:        C�sar Miranda
* Compania:             ABC Capital
* Fecha Creacion:       2018-06-11
* Modificaciones:
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING AbcGetGeneralParam
    $USING AbcTable
    
    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

***********
INITIALIZE:
***********

    Y.FECHA.FIN = ''
    Y.HORA.FIN = ''
    Y.ID.GEN.PARAM = "ABC.EXTRACCION.INHABIL"

RETURN

***********
OPEN.FILES:
***********

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

RETURN

********
PROCESS:
********

    Y.FECHA.FIN = OCONV(DATE(), "DY2"):FMT(OCONV(DATE(), "DM"),"2'0'R"):FMT(OCONV(DATE(), "DD"),"2'0'R")
    Y.HORA.FIN = TIMEDATE()[1,2]:TIMEDATE()[4,2]

    PRINT Y.FECHA.FIN:Y.HORA.FIN

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.ID.GEN.PARAM,R.PARAMETROS,F.ABC.GENERAL.PARAM,GRL.ERR)
    IF R.PARAMETROS THEN
        Y.LIST.PARAMS = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.PARAMETROS<AbcTable.AbcGeneralParam.DatoParametro>)

        LOCATE 'DATE.TIME.FIN' IN Y.LIST.PARAMS SETTING POSITION.FIN THEN
            Y.DATE.TIME.INI = Y.LIST.VALUES<POSITION.FIN>
            Y.DATE.TIME.FIN = Y.FECHA.FIN:Y.HORA.FIN
*         Y.DATE.TIME.FIN = '1806042300'
            R.PARAMETROS<AbcTable.AbcGeneralParam.DatoParametro,POSITION.FIN> = Y.DATE.TIME.FIN
        END

        IF Y.DATE.TIME.INI EQ '' THEN Y.DATE.TIME.INI = Y.FECHA.FIN

        LOCATE 'DATE.TIME.INI' IN Y.LIST.PARAMS SETTING POSITION.INI THEN
            R.PARAMETROS<AbcTable.AbcGeneralParam.DatoParametro,POSITION.INI> = Y.DATE.TIME.INI
        END

        IF POSITION.FIN OR POSITION.INI THEN
            WRITE R.PARAMETROS TO F.ABC.GENERAL.PARAM,Y.ID.GEN.PARAM ON ERROR
                PRINT "ERROR AL ACTUALIZAR LAS FECHAS DE INICIO Y FIN"
            END
        END
    END

RETURN

END

