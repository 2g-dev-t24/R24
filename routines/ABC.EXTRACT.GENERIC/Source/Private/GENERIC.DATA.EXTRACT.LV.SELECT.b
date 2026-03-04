* @ValidationCode : MjotMTg4OTk2MzcxMDpDcDEyNTI6MTc2NTEzOTc1NDI5MDpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Dec 2025 17:35:54
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
$PACKAGE AbcExtractGeneric

SUBROUTINE GENERIC.DATA.EXTRACT.LV.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*===============================================================================
* Nombre de Programa:   EXTRACT.CUST.INFO.LV.SELECT
* Objetivo:             Rutina que realiza el SELECT general para armar la lista a procesar
* Desarrollador:        FyG Solutions
* Compania:             ABC Capital
* Modificaciones:
*===============================================================================
*       Autor: CAST
*       Fecha: 30/06/2022
*       Se agrega funcionalidad para ejecutar una rutina en SELECT que haga filtro de registros seleccionados.
*      CAST.20220630
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING EB.Service
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.CompanyCreation
    $USING AbcGetGeneralParam
    $USING EB.API
    $USING EB.AbcUtil
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    Y.NOMBRE.RUTINA = "GENERIC.DATA.EXTRACT.LV.SELECT"
    Y.CADENA.LOG =  ""
    
    Y.SELECT.CMD = ''
    Y.LIST = ''
    Y.NO.ELEMS = ''

    Y.FILTRO.CAMPOS      = ''
    Y.FILTRO.OPERADORES  = ''
    Y.FILTRO.OPERANDOS   = ''
    Y.FILTRO             = ''
    TODAY   = EB.SystemTables.getToday()
    F.DATA.HELP.FILE = AbcExtractGeneric.getFDataHelpFile()
    Y.LOAD.DATE.FMT.INI = AbcExtractGeneric.getYLoadDateFmtIni()
    Y.LOAD.DATE.FMT.FIN =  AbcExtractGeneric.getYLoadDateFmtFin()
    FN.GENERIC.FILE = AbcExtractGeneric.getFnGenericFile()
    Y.APP.EXEC = AbcExtractGeneric.getYAppExec()
    Y.LOAD.TYPE = AbcExtractGeneric.getYLoadType()
    Y.FIELD.LIST =   AbcExtractGeneric.getYFieldList()
    Y.OPERADOR.LIST = AbcExtractGeneric.getYOperadorList()
    
    Y.OPERANDO.LIST = AbcExtractGeneric.getYOperandoList()
    Y.FLAG.HEADER = AbcExtractGeneric.getYFlagHeader()
    Y.FILE.PATH = AbcExtractGeneric.getYFilePath()
    Y.FILE.NAME = AbcExtractGeneric.getYFileName()
    Y.LOAD.DATE.INI = AbcExtractGeneric.getYLoadDateIni()
    Y.LOAD.DATE.FIN = AbcExtractGeneric.getYLoadDateFin()
    Y.CONSTANT = AbcExtractGeneric.getYConstant()
    Y.SEL.FILTER.ROUTINE = AbcExtractGeneric.getYSelFilterRoutine()
    
;*     CRT "Clearing and creating file: " : F.DATA.HELP.FILE
;*     EXECUTE 'SH -c rm ' : F.DATA.HELP.FILE
;*     EXECUTE 'SH -c touch ' : F.DATA.HELP.FILE
   
    OPEN F.DATA.HELP.FILE TO SEQ.FILE.POINTER THEN
        EXECUTE "CLEAR-FILE " : F.DATA.HELP.FILE CAPTURING Y.RESPONSE.CLEAR
    END ELSE
        EXECUTE "CREATE-FILE " : F.DATA.HELP.FILE : " TYPE=XML"  CAPTURING Y.RESPONSE.CREATE
        OPEN F.DATA.HELP.FILE TO SEQ.FILE.POINTER ELSE        ;* declare F.DATA.HELP.FILE
            EB.ErrorProcessing.FatalError("NO SE PUDO ABRIR ARCHIVO DE ENTRADA: " : Y.HELP.FILE)
        END
    END

RETURN


*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*    CALL GENERIC.DATA.EXTRACT.SELECT.LV(Y.SELECT.CMD)

    DISPLAY Y.LOAD.DATE.FMT.INI
    DISPLAY Y.LOAD.DATE.FMT.FIN

    IF Y.APP.EXEC EQ 'TRUE' THEN
        SEL.CMD = 'SELECT ' : FN.GENERIC.FILE

        IF Y.LOAD.TYPE EQ 'CHANGED' THEN
            Y.FILTRO.CAMPOS<-1>     = 'DATE.TIME'
            Y.FILTRO.OPERADORES<-1> = 'RG'
            Y.FILTRO.OPERANDOS<-1>  = Y.LOAD.DATE.FMT.INI:@VM:Y.LOAD.DATE.FMT.FIN
        END


        IF Y.OPERANDO.LIST THEN
            Y.FILTRO.CONTADOR = DCOUNT(Y.OPERANDO.LIST, FM)

            FOR i = 1 TO Y.FILTRO.CONTADOR
                IF Y.OPERANDO.LIST<i> THEN
                    IF Y.FIELD.LIST<i> EQ 'DATE.TIME' AND Y.LOAD.TYPE EQ 'CHANGED' THEN
                    END ELSE
                        Y.FILTRO.CAMPOS<-1>     = Y.FIELD.LIST<i>
                        Y.FILTRO.OPERADORES<-1> = Y.OPERADOR.LIST<i>

                        Y.OPERANDO              = Y.OPERANDO.LIST<i>
                        CONVERT ' ' TO @VM IN Y.OPERANDO

                        Y.FILTRO.OPERANDOS<-1>  = Y.OPERANDO
                    END
                END
            NEXT i
        END
        
        AbcExtractGeneric.GenSelCmdLv(Y.FILTRO.CAMPOS, Y.FILTRO.OPERADORES, Y.FILTRO.OPERANDOS, Y.FILTRO)
        
        Y.CADENA.LOG<-1> =  "Y.FILTRO.CAMPOS->" : Y.FILTRO.CAMPOS
        Y.CADENA.LOG<-1> =  "Y.FILTRO.OPERADORES->" : Y.FILTRO.OPERADORES
        Y.CADENA.LOG<-1> =  "Y.FILTRO.OPERANDOS->" : Y.FILTRO.OPERANDOS
        Y.CADENA.LOG<-1> =  "Y.FILTRO->" : Y.FILTRO
* CALL GEN.SEL.CMD.LV(Y.FILTRO.CAMPOS, Y.FILTRO.OPERADORES, Y.FILTRO.OPERANDOS, Y.FILTRO)

        IF Y.FILTRO THEN
                
            CHANGE "!TODAY" TO TODAY IN Y.FILTRO
            SEL.CMD := ' WITH ':Y.FILTRO
        END

        Y.SELECT.CMD = SEL.CMD
        DISPLAY Y.SELECT.CMD
        
        Y.CADENA.LOG<-1> =  "Y.SELECT.CMD->" : Y.SELECT.CMD
        
        EB.DataAccess.Readlist(SEL.CMD, Y.LIST, '', Y.NO.ELEMS, '')
        
        Y.CADENA.LOG<-1> =  "Y.NO.ELEMS->" : Y.NO.ELEMS
        DISPLAY Y.NO.ELEMS
;*CAST.20220630.I
        IF Y.SEL.FILTER.ROUTINE THEN
            DISPLAY 'EJECUTA RUTINA -->':Y.SEL.FILTER.ROUTINE
*CALL @Y.SEL.FILTER.ROUTINE(Y.LIST)
            EB.SystemTables.CallBasicRoutine(Y.SEL.FILTER.ROUTINE, Y.LIST, '')
            Y.NO.ELEMS = DCOUNT(Y.LIST,FM)
            DISPLAY 'REGISTROS A PROCESAR ':Y.NO.ELEMS
        END
;*CAST.20220630.F
        EB.Service.BatchBuildList('',Y.LIST)
    END


RETURN


*-------------------------------------------------------------------------
*Last Step in Program
*-------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------

    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)


*Do Not Add Return :)

END




