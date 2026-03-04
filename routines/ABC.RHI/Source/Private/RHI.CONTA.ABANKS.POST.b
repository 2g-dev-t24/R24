* @ValidationCode : MjoyMTkzODQ0MzE6Q3AxMjUyOjE3NzI0MDMxMDk1MDY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 01 Mar 2026 19:11:49
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
$PACKAGE AbcRhi

SUBROUTINE RHI.CONTA.ABANKS.POST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.Utility
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING EB.AbcUtil

    GOSUB VARIABLES.COMMON
    GOSUB PROCESS
    GOSUB MOVEFILE

RETURN
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
VARIABLES.COMMON:
    
    AbcGetGeneralParam.AbcGetGeneralParam('RHI.CONTA.ABANKS', Y.LIST.PARAMS, Y.LIST.VALUES)

    LOCATE 'FILE.DIRECTORY' IN Y.LIST.PARAMS SETTING YPOS.FILE.DIRECTORY THEN
        Y.BASE.FILE.DIRECTORY = Y.LIST.VALUES<YPOS.FILE.DIRECTORY>
    END
    LOCATE 'TEMP.DIRECTORY' IN Y.LIST.PARAMS SETTING YPOS.TEMP.DIRECTORY THEN
        Y.TEMP.DIRECTORY = Y.LIST.VALUES<YPOS.TEMP.DIRECTORY>
    END
    LOCATE 'DATAFILE.NAME' IN Y.LIST.PARAMS SETTING YPOS.DATAFILE.NAME THEN
        Y.BASE.DATAFILE.NAME = Y.LIST.VALUES<YPOS.DATAFILE.NAME>
    END
    LOCATE 'DATAFILE.EXT' IN Y.LIST.PARAMS SETTING YPOS.DATAFILE.EXT THEN
        Y.BASE.DATAFILE.EXT = Y.LIST.VALUES<YPOS.DATAFILE.EXT>
    END
    LOCATE 'LOGFILE.NAME' IN Y.LIST.PARAMS SETTING YPOS.LOGFILE.NAME THEN
        Y.BASE.LOGFILE.NAME = Y.LIST.VALUES<YPOS.LOGFILE.NAME>
    END
    LOCATE 'LOGFILE.EXT' IN Y.LIST.PARAMS SETTING YPOS.LOGFILE.EXT THEN
        Y.BASE.LOGFILE.EXT = Y.LIST.VALUES<YPOS.LOGFILE.EXT>
    END
    
    LOCATE 'POST.DIR' IN Y.LIST.PARAMS SETTING YPOS.POST.DIR THEN
        Y.POST.DIR = Y.LIST.VALUES<YPOS.POST.DIR>
    END
    
    Y.DATES.LWKDAY= EB.SystemTables.getRDates(EB.Utility.Dates.DatLastWorkingDay)
    Y.DATETIME.STAMP = Y.DATES.LWKDAY:".":EREPLACE(OCONV(TIME(),'MTS'),':','')

    Y.DATAFILE.FIN = Y.BASE.DATAFILE.NAME:".":Y.DATETIME.STAMP:Y.BASE.DATAFILE.EXT
    Y.LOGFILE.FIN =  Y.BASE.LOGFILE.NAME:".":Y.DATETIME.STAMP:Y.BASE.LOGFILE.EXT
    
    Y.DATAFILE.TMP = Y.BASE.FILE.DIRECTORY:Y.TEMP.DIRECTORY:'/DATAFILE.TMP'
    Y.LOGFILE.TMP  = Y.BASE.FILE.DIRECTORY:Y.TEMP.DIRECTORY:'/LOGFILE.TMP'
    
    Y.DATA.DIRECTORY = Y.BASE.FILE.DIRECTORY:'/':Y.DATAFILE.FIN
    Y.LOGFILE.DIRECTORY =  Y.BASE.FILE.DIRECTORY:'/':Y.LOGFILE.FIN
    
    OPENSEQ Y.DATA.DIRECTORY TO Y.DATAFILE.FIN.F ELSE
        CREATE Y.DATAFILE.FIN.F THEN
            DISPLAY "SE CREO Y.DATAFILE.FIN"
        END ELSE
            DISPLAY "NO SE PUEDE CREAR Y.DATAFILE.FIN"
        END
    END
    
    OPENSEQ Y.LOGFILE.DIRECTORY TO Y.LOGFILE.FIN.F ELSE
        CREATE Y.LOGFILE.FIN.F THEN
            DISPLAY "SE CREO Y.LOGFILE.FIN"
        END ELSE
            DISPLAY "NO SE PUEDE CREAR Y.LOGFILE.FIN"
        END
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
    SEL.CMD = "SELECT ":Y.DATAFILE.TMP
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)
    Y.TOT.39 = 0
    Y.TOT.40 = 0
    Y.TOT.41 = 0
    Y.TOT.42 = 0
    Y.CNT.CMD.DF = 0
    FOR REC.REG = 1 TO Y.NO.REC
        EOF = ''
        Y.ID = ID.LIST<REC.REG>
        GOSUB GRABAR.DATA.FILE
    NEXT REC.REG
    
    SEL.CMD = "SELECT ":Y.LOGFILE.TMP
    EB.DataAccess.Readlist(SEL.CMD,ID.LIST,'',Y.NO.REC,ERR.SEL)

    Y.TOT.LOG = 0
    
    FOR REC.REG = 1 TO Y.NO.REC
        EOF = ''
        Y.ID = ID.LIST<REC.REG>
        GOSUB GRABAR.LOG.FILE
    NEXT REC.REG
    Y.LIST.CMD.LOG<-1> = '(':Y.LOGFILE.FIN:') TOTAL DE AMOUNT.LCY= ':Y.TOT.LOG
    Y.LIST.CMD.LOG<-1> = ''
    Y.LIST.CMD.LOG<-1> = '(':Y.DATAFILE.FIN:') TOTAL DE MOVS= ':Y.CNT.CMD.DF:' TOTAL DEBITOS= ':Y.TOT.39:' TOTAL CREDITOS= ':Y.TOT.40:' DIFERENCIA= ':(Y.TOT.39-Y.TOT.40)
    WRITESEQ Y.LIST.CMD.LOG TO Y.LOGFILE.FIN.F ELSE
        DISPLAY "ERROR AL ESCIBIR Y.LIST.DETAILS"
    END

RETURN

*-----------------------------------------------------------------------------
GRABAR.DATA.FILE:
*-----------------------------------------------------------------------------
    EOF = 0
    OPENSEQ Y.DATAFILE.TMP,Y.ID TO Y.DATAFILE.TMP.F THEN
        Y.LIST.DETAILS = ""

        LOOP
        WHILE NOT(EOF) DO
            READSEQ Y.READ.RECORDS FROM Y.DATAFILE.TMP.F THEN
                WRITESEQ Y.READ.RECORDS TO Y.DATAFILE.FIN.F ELSE
                    DISPLAY "ERROR AL ESCIBIR Y.LIST.DETAILS"
                END
                Y.TOT.39 += FIELD(Y.READ.RECORDS,',',39)
                Y.TOT.40 += FIELD(Y.READ.RECORDS,',',40)
                Y.TOT.41 += FIELD(Y.READ.RECORDS,',',41)
                Y.TOT.42 += FIELD(Y.READ.RECORDS,',',42)
                Y.CNT.CMD.DF = Y.CNT.CMD.DF + 1
            END ELSE
                EOF = 1
            END
        REPEAT
        CLOSESEQ Y.DATAFILE.TMP.F
        DELETESEQ Y.DATAFILE.TMP.F
    END
RETURN

*-----------------------------------------------------------------------------
GRABAR.LOG.FILE:
*-----------------------------------------------------------------------------
    EOF = 0
    OPENSEQ Y.LOGFILE.TMP,Y.ID TO Y.LOGFILE.TMP.F THEN
        
        LOOP
        WHILE NOT(EOF) DO
            READSEQ Y.READ.RECORDS FROM Y.LOGFILE.TMP.F THEN
                Y.TOT.LOG += FIELD(Y.READ.RECORDS,'|',2)
	            WRITESEQ Y.READ.RECORDS TO Y.LOGFILE.FIN.F ELSE
	                DISPLAY "ERROR AL ESCIBIR Y.LIST.DETAILS"
	            END
            END ELSE
                EOF = 1
            END
        REPEAT
        CLOSESEQ Y.LOGFILE.TMP.F
        DELETESEQ Y.LOGFILE.TMP.F
    END
RETURN
*-----------------------------------------------------------------------------
MOVEFILE:
*-----------------------------------------------------------------------------

    EB.AbcUtil.abcMoveFileToS3(Y.BASE.FILE.DIRECTORY, Y.POST.DIR, Y.DATAFILE.FIN)

    EB.AbcUtil.abcMoveFileToS3(Y.BASE.FILE.DIRECTORY, Y.POST.DIR, Y.LOGFILE.FIN)
    
RETURN
END
