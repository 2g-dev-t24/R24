* @ValidationCode : MjoxNTEyNjk1NDcwOkNwMTI1MjoxNzYxNjIyODAyODcyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Oct 2025 00:40:02
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

SUBROUTINE GENERIC.DATA.EXTRACT.LV(Y.ID.TO.PROCESS)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*===============================================================================
* Nombre de Programa:   GENERIC.DATA.EXTRACT.RTN.LV
* Objetivo:             Rutina generica que recibe un ID y dependiendo su archivo le su tabla de parametros
* Desarrollador:        Franco Manrique
* Compania:             larrainVial Ltda
* Fecha Creacion:       2014-01-28
* Modificaciones:
*===============================================================================
*       Autor: CAST
*       Fecha: 28/06/2022
*       Descripcion: Se agrega funcionalidad para hacer link a una aplicaci�n y extraer la informaci�n
*      CAST.20220628
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
    $USING EB.Updates
    $USING AbcCob
    $USING EB.AbcUtil
    $USING AA.Framework
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    Y.NOMBRE.RUTINA = "GENERIC.DATA.EXTRACT.LV"
    Y.LINEA.LOG = "" ; Y.SEP.SPC = " "
    Y.CADENA.LOG =  ""
    
    Y.LINEA.LOG = "Y.ID.TO.PROCESS->" : Y.SEP.SPC : Y.ID.TO.PROCESS : Y.SEP.SPC
    
    R.GENERIC.FILE = ''
    Y.LINE = ''
    
    FN.GENERIC.FILE = AbcExtractGeneric.getFnGenericFile()
    F.GENERIC.FILE = AbcExtractGeneric.getFGenericFile()
    BATCH.DETAILS = EB.SystemTables.getBatchDetails()
    Y.APLICACION = BATCH.DETAILS<3>
    Y.TABLE.NAME = FIELD(Y.APLICACION, '-', 1)
    
    Y.LINEA.LOG := "Y.APLICACION->" : Y.SEP.SPC : Y.APLICACION : Y.SEP.SPC
    
    Y.LOCAL.FIELD.LIST = AbcExtractGeneric.getYLocalFieldList()
    Y.LOCAL.REF.POS = AbcExtractGeneric.getYLocalRefPos()
    F.DATA.HELP.FILE = AbcExtractGeneric.getFDataHelpFile()
    Y.NO.FILEDS = AbcExtractGeneric.getYNoFileds()
    Y.APP.EXEC = AbcExtractGeneric.getYAppExec()
    
    Y.LINEA.LOG = "Y.NO.FILEDS->" : Y.NO.FILEDS : Y.SEP.SPC
    
    SEQ.FILE.POINTER = ''
    OPEN F.DATA.HELP.FILE TO SEQ.FILE.POINTER ELSE
         EB.ErrorProcessing.FatalError("NO SE PUDO ABRIR ARCHIVO DE ENTRADA: " : Y.HELP.FILE)
    END
    
;*     OPENSEQ F.DATA.HELP.FILE,'' TO SEQ.FILE.POINTER ELSE
;*         EXECUTE 'SH -c "touch ' : F.DATA.HELP.FILE : '"'
;*         OPENSEQ F.DATA.HELP.FILE,'' TO SEQ.FILE.POINTER ELSE
;*             CRT "ERROR: No se pudo abrir archivo: " : F.DATA.HELP.FILE
;*         END
;*     END

    
    
    Y.LOAD.TYPE = AbcExtractGeneric.getYLoadType()
    Y.FIELD.LIST = AbcExtractGeneric.getYFieldList()
    Y.OPERADOR.LIST = AbcExtractGeneric.getYOperadorList()
    Y.LOCAL.NAME.LIST = AbcExtractGeneric.getYLocalNameList()
    Y.NO.POS.VM.LIST = AbcExtractGeneric.getYNoPosVmList()
    Y.NO.POS.SM.LIST = AbcExtractGeneric.getYNoPosSmList()
    Y.VISUALIZA.LIST = AbcExtractGeneric.getYVisualizaList()
    Y.CONSTANT = 'F'
    Y.VM.SEP = AbcExtractGeneric.getYVmSep()
    Y.SM.SEP = AbcExtractGeneric.getYSmSep()
    Y.SPEC.VM.SEP.LIST = AbcExtractGeneric.getYSpecVmSepList()
    Y.SPEC.SM.SEP.LIST = AbcExtractGeneric.getYSpecSmSepList()
    YREC.APP.SS = AbcExtractGeneric.getYRecAppSs()
    Y.SEPARADOR = AbcExtractGeneric.getYSeparador()
    Y.LINK.APP.FIELD.LIST = AbcExtractGeneric.getYLinkAppFieldList()

RETURN


*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------


    EB.DataAccess.FRead(FN.GENERIC.FILE,Y.ID.TO.PROCESS,R.GENERIC.FILE,F.GENERIC.FILE,ERR.GENERIC.FILE)
    
    Y.LINEA.LOG := "R.GENERIC.FILE->" : Y.SEP.SPC : R.GENERIC.FILE : Y.SEP.SPC

    IF R.GENERIC.FILE THEN
        IF Y.TABLE.NAME NE 'LOCAL.TABLE' THEN
        
            FOR Y.AA = 1 TO Y.NO.FILEDS ;*Variable global que contiene el numero de campos a procesar por registro

                YFIELD.NUMBER = ''
                Y.FIELD.DATA = ''
                Y.LOCAL.REF.POS.FOUND = ''
                Y.LOCAL.REF.FIELD = ''
                Y.SYS.SINGLE.MULT = ''
                Y.FIELD.NAME = Y.FIELD.LIST<Y.AA> ;*Variable global que contiene el nombre de los campos a procesar
                Y.LOCAL.REF.FIELD = Y.LOCAL.NAME.LIST<Y.AA>
                Y.FIELD.POS.VM = Y.NO.POS.VM.LIST<Y.AA>     ;*Variable global que contiene la posici�n VM de los campos a procesar
                Y.FIELD.POS.SM = Y.NO.POS.SM.LIST<Y.AA>     ;*Variable global que contiene la posici�n SM de los campos a procesar
                Y.VISUALIZA.POS = Y.VISUALIZA.LIST<Y.AA>    ;*Variable global que contiene el valor de la visualizacion

                IF Y.VISUALIZA.POS EQ '' OR Y.VISUALIZA.POS EQ 'SI' THEN
                    IF Y.FIELD.NAME EQ '@ID' THEN
                        Y.FIELD.DATA = Y.ID.TO.PROCESS
                    END ELSE
                        GOSUB GET.FIELD.NUMBER
                        IF YFIELD.NUMBER THEN



                            IF Y.FIELD.NAME EQ 'LOCAL.REF' AND Y.LOCAL.REF.FIELD THEN     ;*Es un campo local parametrizado
                                GOSUB GET.LOCAL.REF.POS

                                IF Y.LOCAL.REF.POS.FOUND THEN

                                    IF Y.FIELD.POS.VM THEN
                                        IF Y.FIELD.POS.VM NE Y.CONSTANT THEN
                                            Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.LOCAL.REF.POS.FOUND,Y.FIELD.POS.VM>     ;*CAMPO LOCAL CON VM NUMERICA
                                        END ELSE
                                            Y.NO.FIELD.POS.VM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER,Y.LOCAL.REF.POS.FOUND>,@SM)
                                            Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.LOCAL.REF.POS.FOUND,Y.NO.FIELD.POS.VM>  ;*CAMPO LOCAL CON VM CONSTANTE
                                        END
                                    END ELSE
                                        Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.LOCAL.REF.POS.FOUND>    ;*CAMPO LOCAL CON VM VACIA
                                    END

                                END ELSE
                                    Y.LINE<-1> = '***ERROR***'
                                END

                            END ELSE

                                IF Y.FIELD.POS.VM THEN

                                    IF Y.FIELD.POS.SM THEN

                                        IF Y.FIELD.POS.SM NE Y.CONSTANT THEN
                                            IF Y.FIELD.POS.VM NE Y.CONSTANT THEN
                                                Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.FIELD.POS.VM,Y.FIELD.POS.SM>        ;*VM NUMERICA SM NUMERICA
                                            END ELSE
                                                Y.NO.FIELD.POS.VM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER>,@VM)
                                                Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.NO.FIELD.POS.VM,Y.FIELD.POS.SM>     ;*VM CONSTANTE SM NUMERICA
                                            END
                                        END ELSE

                                            IF Y.FIELD.POS.VM NE Y.CONSTANT THEN
                                                Y.NO.FIELD.POS.SM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER,Y.FIELD.POS.VM>,@SM)
                                                Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.FIELD.POS.VM,Y.NO.FIELD.POS.SM>     ;*VM NUMERICA SM CONSTANTE
                                            END ELSE

                                                Y.NO.FIELD.POS.VM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER>,@VM)
                                                Y.NO.FIELD.POS.SM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER,Y.NO.FIELD.POS.VM>,@SM)
                                                Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.NO.FIELD.POS.VM,Y.NO.FIELD.POS.SM>  ;*VM CONSTANTE SM CONSTANTE
                                            END
                                        END
                                    END ELSE

                                        IF Y.FIELD.POS.VM NE Y.CONSTANT THEN
                                            Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.FIELD.POS.VM>       ;*VM NUMERICA SM VACIA
                                        END ELSE
                                            Y.NO.FIELD.POS.VM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER>,@VM)
                                            Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER,Y.NO.FIELD.POS.VM>    ;*VM CONSTANTE SM VACIA
                                        END

                                    END

                                END ELSE

                                    IF Y.FIELD.POS.SM THEN
                                        Y.NO.FIELD.POS.VM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER>,@VM)
                                        FOR Y.POS.VM = 1 TO Y.NO.FIELD.POS.VM
                                            IF Y.FIELD.POS.SM NE Y.CONSTANT THEN
                                                Y.FIELD.DATA := R.GENERIC.FILE<YFIELD.NUMBER,Y.POS.VM,Y.FIELD.POS.SM>   ;*VM VACIA SM NUMERICA
                                            END ELSE
                                                Y.NO.FIELD.POS.SM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER,Y.POS.VM>,@SM)
                                                Y.FIELD.DATA := R.GENERIC.FILE<YFIELD.NUMBER,Y.POS.VM,Y.NO.FIELD.POS.SM>          ;*VM VACIA SM CONSTANTE
                                            END
                                            IF Y.POS.VM NE Y.NO.FIELD.POS.VM THEN Y.FIELD.DATA := @SM
                                        NEXT Y.POS.VM
                                    END ELSE
                                        Y.FIELD.DATA = R.GENERIC.FILE<YFIELD.NUMBER>      ;*VM VACIA SM VACIA
                                    END

                                END
                            END

                            IF Y.SYS.SINGLE.MULT EQ 'M' THEN          ;*Es un campo multivalor y/o subvalor

                                Y.SPECIAL.VM.SEP = Y.VM.SEP
                                Y.SPECIAL.SM.SEP = Y.SM.SEP


                                IF Y.LOCAL.REF.POS.FOUND THEN         ;*Si es un campo local y es multivalor, entonces lleva como separador @VM ya que de lo contrario lo pondr�a como @SM
                                    Y.SPECIAL.SM.SEP = Y.VM.SEP
                                END

                                IF Y.SPEC.VM.SEP.LIST<Y.AA> THEN
                                    Y.SPECIAL.VM.SEP = Y.SPEC.VM.SEP.LIST<Y.AA>
                                    IF Y.SPEC.VM.SEP.LIST<Y.AA> EQ 'QUIT' THEN
                                        Y.SPECIAL.VM.SEP = ''
                                    END
                                END

                                IF Y.SPEC.SM.SEP.LIST<Y.AA> THEN
                                    Y.SPECIAL.SM.SEP = Y.SPEC.SM.SEP.LIST<Y.AA>
                                    IF Y.SPEC.SM.SEP.LIST<Y.AA> EQ 'QUIT' THEN
                                        Y.SPECIAL.SM.SEP = ''
                                    END
                                END

*      Y.FIELD.DATA = EREPLACE (R.GENERIC.FILE<YFIELD.NUMBER>, VM, Y.SPECIAL.VM.SEP)
*      Y.FIELD.DATA = EREPLACE (Y.FIELD.DATA, SM, Y.SPECIAL.SM.SEP)
                                Y.FIELD.DATA = EREPLACE (Y.FIELD.DATA, @VM, Y.SPECIAL.VM.SEP)
                                Y.FIELD.DATA = EREPLACE (Y.FIELD.DATA, @SM, Y.SPECIAL.SM.SEP)
                            END

                        END ELSE
                            Y.LINE<-1> = '***ERROR***'
                        END
                    END
                END
*   Y.LINE := Y.FIELD.DATA : Y.SEPARADOR
*CAST.20220628.I
                IF Y.LINK.APP.FIELD.LIST<Y.AA> NE '' THEN
                    GOSUB GET.LINK.INFO
                    Y.FIELD.DATA = FIELD.INFO
                END
*CAST.20220628.F
                Y.LINE<-1> = Y.FIELD.DATA

            NEXT Y.AA

            Y.LINE = EREPLACE (Y.LINE, @FM, Y.SEPARADOR)
            
            ;*WRITESEQ Y.LINE APPEND TO SEQ.FILE.POINTER ELSE END
            WRITE Y.LINE TO SEQ.FILE.POINTER,Y.ID.TO.PROCESS
        END ELSE
            GOSUB PROCESS.LOCAL.TABLE
        END

    END

RETURN

*-----------------------------------------------------------------------------
PROCESS.LOCAL.TABLE:
*-----------------------------------------------------------------------------

    LOCATE 'VETTING.TABLE' IN Y.FIELD.LIST SETTING LFIELD.POS THEN
        LOCATE 'VETTING.TABLE' IN YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysFieldName,1> SETTING LFIELD.POS THEN
            YFIELD.NUMBER = YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysFieldNo,LFIELD.POS>
            Y.NO.FIELD.POS.VM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER>,@VM)
            FOR Y.POS.VM = 1 TO Y.NO.FIELD.POS.VM
                Y.FIELD.DATA = ''
                FOR Y.AA = 1 TO Y.NO.FILEDS
                    YFIELD.NUMBER = ''
                    Y.FIELD.NAME = Y.FIELD.LIST<Y.AA>       ;*Variable global que contiene el nombre de los campos a procesar
                    IF Y.FIELD.NAME NE '@ID' THEN
                        GOSUB GET.FIELD.NUMBER
                        IF YFIELD.NUMBER THEN
                            Y.NO.FIELD.POS.SM = DCOUNT(R.GENERIC.FILE<YFIELD.NUMBER,Y.NO.FIELD.POS.VM>,@SM)
                            IF Y.NO.FIELD.POS.SM GT 0 THEN
                                Y.FIELD.DATA := R.GENERIC.FILE<YFIELD.NUMBER,Y.POS.VM,1>
                            END ELSE
                                Y.FIELD.DATA := R.GENERIC.FILE<YFIELD.NUMBER,Y.POS.VM>
                            END
                        END ELSE
                            Y.FIELD.DATA := '***ERROR***'
                        END
                        IF Y.AA NE Y.NO.FILEDS THEN
                            Y.FIELD.DATA := Y.SEPARADOR
                        END
                    END
                NEXT Y.AA
                Y.LINE<-1> = Y.FIELD.DATA
            NEXT Y.POS.VM
            ;*WRITESEQ Y.LINE APPEND TO SEQ.FILE.POINTER ELSE END
            WRITE Y.LINE TO SEQ.FILE.POINTER,Y.ID.TO.PROCESS
        END
    END

RETURN

*----------------------------------------------------------------------------
GET.FIELD.NUMBER:
*-----------------------------------------------------------------------------

    LOCATE Y.FIELD.NAME IN YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysFieldName,1> SETTING LFIELD.POS.APP THEN
*        IF YREC.APP<SSL.SYS.TYPE,LFIELD.POS.APP> EQ "D" THEN
        YFIELD.NUMBER = YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysFieldNo,LFIELD.POS.APP>
        Y.SYS.SINGLE.MULT = YREC.APP.SS<EB.SystemTables.StandardSelection.SslSysSingleMult,LFIELD.POS.APP>
*        END
    END

RETURN

*-----------------------------------------------------------------------------
GET.LOCAL.REF.POS:
*-----------------------------------------------------------------------------

    LOCATE Y.LOCAL.REF.FIELD IN Y.LOCAL.FIELD.LIST<1,1> SETTING LCAL.REF.POS THEN
        Y.LOCAL.REF.POS.FOUND = Y.LOCAL.REF.POS<1,LCAL.REF.POS>
    END

RETURN
*CAST.20220628.I
*-----------------------------------------------------------------------------
GET.LINK.INFO:
*-----------------------------------------------------------------------------
    
    FIELD.INFO = ''
    LINK.RECS = ''
    LINK.APPLN.NAME = FIELD(Y.LINK.APP.FIELD.LIST<Y.AA>,",",1)
    LINK.FIELD.NAME = FIELD(Y.LINK.APP.FIELD.LIST<Y.AA>,",",2)
    LINK.AA.PROPERTY = FIELD(Y.LINK.APP.FIELD.LIST<Y.AA>,",",3)
    
    IF LINK.APPLN.NAME THEN
    
        IF (FIELD(LINK.APPLN.NAME, '.', 1) EQ 'AA') AND (LINK.AA.PROPERTY NE '') THEN
        
            Y.TODAY = EB.SystemTables.getToday()
            ARR.ID = Y.FIELD.DATA
            Y.FIELD.INFO = ''
            AA.Framework.GetArrangementConditions(ARR.ID, LINK.AA.PROPERTY, '',Y.TODAY ,returnIds, returnConditions, returnError)
            returnConditions = RAISE(returnConditions)
            LINK.RECS = returnConditions
        END ELSE 
	        FN.LINK.APPLN.NAME = 'F.':LINK.APPLN.NAME
	        FV.LINK.APPLN.NAME = ''
	        EB.DataAccess.Opf(FN.LINK.APPLN.NAME,FV.LINK.APPLN.NAME)
	        FINDSTR '$HIS' IN LINK.APPLN.NAME SETTING Y.FOUND THEN
	            Y.ID.HIS = Y.FIELD.DATA
	            EB.DataAccess.FReadHistory(FN.LINK.APPLN.NAME,Y.ID.HIS,LINK.RECS,FV.LINK.APPLN.NAME,LINK.ERR)
	            IF LINK.FIELD.NAME EQ '@ID' THEN
	                FIELD.INFO = Y.ID.HIS
	            END
	        END ELSE
	            EB.DataAccess.FRead(FN.LINK.APPLN.NAME,Y.FIELD.DATA,LINK.RECS,FV.LINK.APPLN.NAME,LINK.ERR)
	            IF LINK.FIELD.NAME EQ '@ID' THEN
	                FIELD.INFO = Y.FIELD.DATA
	            END
	        END
        END
        
        IF LINK.RECS NE '' AND FIELD.INFO EQ '' THEN
            GOSUB GET.FIELD.DETS
        END
        
    END

RETURN

*-------------------------------------------------------------------------
GET.FIELD.DETS:
*-------------------------------------------------------------------------
    
    LRF.POSN = ""
    R.STANDARD.SELECTION = ""
    FIELD.NO = ""
    YAS = ""
*
    LINK.APPLN.NAME = FIELD(LINK.APPLN.NAME,'$',1)
    EB.API.GetStandardSelectionDets(LINK.APPLN.NAME,R.STANDARD.SELECTION)
    EB.Updates.MultiGetLocRef(LINK.APPLN.NAME,LINK.FIELD.NAME,LRF.POSN)
*
    IF LRF.POSN THEN
        EB.API.FieldNamesToNumbers("LOCAL.REF",R.STANDARD.SELECTION,FIELD.NO,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
        FIELD.INFO = LINK.RECS<FIELD.NO,LRF.POSN,YAS>
    END ELSE
        EB.API.FieldNamesToNumbers(LINK.FIELD.NAME,R.STANDARD.SELECTION,FIELD.NO,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
        FIELD.INFO = LINK.RECS<FIELD.NO,1,1>
    END

RETURN
*CAST.20220628.F
*-------------------------------------------------------------------------
*Last Step in Program
*-------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------

*Do Not Add Return :)
    Y.CADENA.LOG =  Y.LINEA.LOG
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.CADENA.LOG)
    ;*CLOSESEQ SEQ.FILE.POINTER
    CLOSE SEQ.FILE.POINTER

END

