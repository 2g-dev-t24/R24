* @ValidationCode : MjotMTk0Nzk0NDk5MTpDcDEyNTI6MTc2MTYxODQ4NTY0OTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2025 23:28:05
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
$PACKAGE AbcTable

SUBROUTINE GENERIC.EXTRACT.PARAM.LV.VALIDATE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    !** Template FOR validation routines
* @author youremail@temenos.com
* @stereotype validator
* @package infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 07/06/06 - BG_100011433
*            Creation
*-----------------------------------------------------------------------------
*       Autor: CAST
*       Fecha: 27/06/2022
*       Descripcion: Se agrega validación a la información guardada en el campo LINK.APP.FIELD
*      CAST.20220627
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.API
    
    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
* TODO - Add the validation code here.
* Set AF, AV and AS to the field, multi value and sub value and invoke STORE.END.ERROR
* Set ETEXT to point to the EB.ERROR.TABLE

*      AF = MY.FIELD.NAME                 <== Name of the field
*      ETEXT = 'EB-EXAMPLE.ERROR.CODE'    <== The error code
*      CALL STORE.END.ERROR               <== Needs to be invoked per error


    GOSUB VALIDATE.DATES
    GOSUB VALIDATE.FIELD.VALUE


RETURN

*-----------------------------------------------------------------------------
*** <region name= Initialise>
VALIDATE.DATES:
***
    Y.LOAD.TYPE = EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.LoadType)
    Y.LOAD.DATE.INI = EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.LoadDateIni)
    Y.LOAD.DATE.FIN = EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.LoadDateFin)
    IF Y.LOAD.TYPE EQ 'CHANGED' THEN
        IF (NOT (Y.LOAD.DATE.INI) AND NOT (Y.LOAD.DATE.FIN)) OR  (Y.LOAD.DATE.INI AND Y.LOAD.DATE.FIN) THEN
        END ELSE
*AF = GEN.EXT.P.LOAD.TYPE
            EB.SystemTables.setAf(AbcTable.GenericExtractParamLv.LoadType)
            ETEXT = 'FAVOR DE INGRESAR AMBAS FECHAS O DEJAR AMBAS EN BLANCO'
            EB.SystemTables.setEtext(ETEXT)
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
*-----------------------------------------------------------------------------
*** <region name= Initialise>
VALIDATE.FIELD.VALUE:
***
    Y.FIELD.LIST = RAISE(EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.Field))
    Y.LOCAL.FIELD.LIST = RAISE(EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.LocalName))
    Y.NO.FIELDS = DCOUNT (Y.FIELD.LIST, @FM)
    Y.NO.LOCAL.FIELDS = DCOUNT (Y.LOCAL.FIELD.LIST, @FM)

    FOR Y.AA = 1 TO Y.NO.FIELDS
        Y.FIELD = Y.FIELD.LIST<Y.AA>
        LOCATE Y.FIELD IN YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysFieldName,1> SETTING LFIELD.POS.APP ELSE
*            AF = GEN.EXT.P.FIELD
*            AV = Y.AA
            ETEXT = 'CAMPO ' : Y.FIELD : ' NO EXISTE EN ' : Y.APLICACION
            EB.SystemTables.setAf(AbcTable.GenericExtractParamLv.Field)
            EB.SystemTables.setAv(Y.AA)
            EB.SystemTables.setEtext(ETEXT)
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
*Se validan campos locales parametrizados
        Y.FIELD.LOCAL = ''
        Y.FIELD.LOCAL = Y.LOCAL.FIELD.LIST<Y.AA>
        IF Y.FIELD EQ 'LOCAL.REF' AND Y.FIELD.LOCAL THEN
            LOCATE Y.FIELD.LOCAL IN YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysFieldName,1> SETTING LFIELD.POS.APP ELSE
*                AF = GEN.EXT.P.LOCAL.NAME
*                AV = Y.AA
                
                ETEXT = 'CAMPO LOCAL ' : Y.FIELD.LOCAL : ' NO EXISTE EN ' : Y.APLICACION
                EB.SystemTables.setAf(AbcTable.GenericExtractParamLv.LocalName)
                EB.SystemTables.setAv(Y.AA)
                EB.SystemTables.setEtext(ETEXT)
                EB.SystemTables.setE(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END
*CAST.20220627.I

        IF EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.LinkAppField)<1,Y.AA> THEN
            IF YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysSingleMult,LFIELD.POS.APP> EQ 'M' THEN
*               AF = GEN.EXT.P.LINK.APP.FIELD
*              AV = Y.AA
                ETEXT = 'FUNCIONALIDAD NO DISPONIBLE PARA CAMPOS MULTIVALOR/SUBVALOR'
                EB.SystemTables.setAf(AbcTable.GenericExtractParamLv.LinkAppField)
                EB.SystemTables.setAv(Y.AA)
                EB.SystemTables.setEtext(ETEXT)
                EB.SystemTables.setE(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END ELSE

                Y.LINK.APP = FIELD(EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.LinkAppField)<1,Y.AA>,',',1)
                Y.LINK.FIELD = FIELD(EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.LinkAppField)<1,Y.AA>,',',2)
                Y.SS.LINK.APP.ID = FIELD(Y.LINK.APP,'$HIS',1)
                EB.DataAccess.CacheRead('F.STANDARD.SELECTION',Y.SS.LINK.APP.ID,R.SS.LINK.APP,YERR)
                IF R.SS.LINK.APP THEN
                    LOCATE Y.LINK.FIELD IN R.SS.LINK.APP<EB.SystemTables.StandardSelection.SslSysFieldName,1> SETTING Y.SS.FIELD.POS ELSE
                        LOCATE Y.LINK.FIELD IN R.SS.LINK.APP<EB.SystemTables.StandardSelection.SslUsrFieldName,1> SETTING Y.SS.FIELD.POS ELSE
*                          AF = GEN.EXT.P.LINK.APP.FIELD
*                         AV = Y.AA
                            ETEXT = 'CAMPO ' : Y.LINK.FIELD : ' NO EXISTE EN ' : Y.LINK.APP
                            EB.SystemTables.setAf(AbcTable.GenericExtractParamLv.LinkAppField)
                            EB.SystemTables.setAv(Y.AA)
                            EB.SystemTables.setEtext(ETEXT)
                            EB.SystemTables.setE(ETEXT)
                            EB.ErrorProcessing.StoreEndError()
                        END
                    END
                END ELSE
*                  AF = GEN.EXT.P.LINK.APP.FIELD
*                 AV = Y.AA
                    ETEXT = 'APLICACION ' : Y.LINK.APP : ' NO EXISTE'
                    EB.SystemTables.setAf(AbcTable.GenericExtractParamLv.LinkAppField)
                    EB.SystemTables.setAv(Y.AA)
                    EB.SystemTables.setEtext(ETEXT)
                    EB.SystemTables.setE(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END
            END
        END
*CAST.20220627.F

    NEXT Y.AA
*CAST.20220627.I

    Y.FILTER.ROUTINE = EB.SystemTables.getRNew(AbcTable.GenericExtractParamLv.SelFilterRoutine)
    IF Y.FILTER.ROUTINE THEN
        Y.COMPILED = '' ; Y.RETURN.INFO = ''
        EB.API.CheckRoutineExist(Y.FILTER.ROUTINE,Y.COMPILED,Y.RETURN.INFO)
* CALL CHECK.ROUTINE.EXIST(Y.FILTER.ROUTINE,Y.COMPILED,Y.RETURN.INFO)
        IF NOT(Y.COMPILED) THEN
*  AF = GEN.EXT.P.SEL.FILTER.ROUTINE
            ETEXT = 'RUTINA NO EXISTE'
            EB.SystemTables.setAf(AbcTable.GenericExtractParamLv.SelFilterRoutine)
            EB.SystemTables.setEtext(ETEXT)
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END
*CAST.20220627.F
*
RETURN
*** </region>

*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***
    ID.NEW = EB.SystemTables.getIdNew()
    Y.ID = ID.NEW

    Y.APLICACION = FIELD(Y.ID, '-', 1)
    Y.APLICACION = FIELD(Y.APLICACION, '$', 1)

    YREC.APP.SS = ''
    EB.API.GetStandardSelectionDets(Y.APLICACION,YREC.APP.SS)
*   CALL GET.STANDARD.SELECTION.DETS(Y.APLICACION,YREC.APP.SS)

*
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Process Message>
PROCESS.MESSAGE:
    Y.FUNCTION          = EB.SystemTables.getVFunction()
    MESSAGE = EB.SystemTables.getMessage()

    BEGIN CASE
        CASE MESSAGE EQ ''        ;* Only during commit...
            BEGIN CASE
                CASE Y.FUNCTION EQ 'D'
                    GOSUB VALIDATE.DELETE
                CASE Y.FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE 1        ;* The real VALIDATE...
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'     ;* During authorisation and verification...
            GOSUB VALIDATE.AUTHORISATION
    END CASE
*
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.DELETE>
VALIDATE.DELETE:
* Any special checks for deletion

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.REVERSE>
VALIDATE.REVERSE:
* Any special checks for reversal

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.AUTHORISATION>
VALIDATE.AUTHORISATION:
* Any special checks for authorisation

RETURN
*** </region>
*-----------------------------------------------------------------------------
END

