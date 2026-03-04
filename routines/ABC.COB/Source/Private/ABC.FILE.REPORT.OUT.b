* @ValidationCode : MjotMTgwNzg5NzY0ODpDcDEyNTI6MTc1OTc4NTUxNzc1NTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Oct 2025 18:18:37
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
 
SUBROUTINE ABC.FILE.REPORT.OUT

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING AbcTable
    $USING EB.SystemTables
    $USING EB.Service
    $USING ST.Config

    GOSUB INITIALISATION      ;* file opening, variable set up
    GOSUB MAIN.PROCESS        ;* main subroutine processing

RETURN

*-----------------------------------------------------------------------------

*** <region name= INITIALISATION>
INITIALISATION:
*** <desc>file opening, variable set up</desc>

    FN.ABC.FILE.REPORT.TMP = 'F.ABC.FILE.REPORT.TMP'
    F.ABC.FILE.REPORT.TMP = ''
    EB.DataAccess.Opf(FN.ABC.FILE.REPORT.TMP,F.ABC.FILE.REPORT.TMP)

    FN.ABC.FILE.EXPORT = 'F.ABC.FILE.EXPORT'
    F.ABC.FILE.EXPORT = ''
    EB.DataAccess.Opf(FN.ABC.FILE.EXPORT,F.ABC.FILE.EXPORT)

    FILE.NAME.AUX = ''
    
    GOSUB SET.DATES ;*

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= SET.DATES>
SET.DATES:
***
    
    R.TSA.SERVICE = EB.Service.TsaService.Read('COB',YERR)
    Y.COB.STATUS = R.TSA.SERVICE<EB.Service.TsaService.TsTsmServiceControl>

    IF Y.COB.STATUS EQ 'STOP' THEN
        FECHA.FIN = EB.SystemTables.getToday()
    END ELSE
        FECHA.INI = EB.SystemTables.getToday()
        FECHA.INI = FECHA.INI[1,6]:'01'
        GOSUB GET.LAST.DAY
        FECHA.FIN = EB.SystemTables.getToday()
        FECHA.FIN = FECHA.FIN[1,6]:YVAR
    END

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.LAST.DAY>
GET.LAST.DAY:
***

    HOLIDAY.ID = 'MX00':FECHA.INI[1,4]
    YFLD = 14

    R.HOLIDAY = ST.Config.Holiday.Read(HOLIDAY.ID,YERR)

    IF R.HOLIDAY THEN
        YMTH = FECHA.INI[5,2]
        FOR J = 1 TO 12
            IF YMTH = J THEN
                YVAR = LEN(R.HOLIDAY<YFLD>)-COUNT(R.HOLIDAY<YFLD>,'X')
                EXIT
            END
            YFLD += 1
        NEXT J
    END

RETURN

*** </region>

*-----------------------------------------------------------------------------

*** <region name= MAIN.PROCESS>
MAIN.PROCESS:
*** <desc>main subroutine processing</desc>

    ABC.FILE.EXPORT.ID = 'IPAB'
    EB.DataAccess.FRead(FN.ABC.FILE.EXPORT,ABC.FILE.EXPORT.ID,R.ABC.FILE.EXPORT,F.ABC.FILE.EXPORT,YERR)

    IF R.ABC.FILE.EXPORT THEN

        Y.NO.RECS = DCOUNT(R.ABC.FILE.EXPORT<AbcTable.AbcFileExport.FileMappingId>,@VM)

        FOR i = 1 TO Y.NO.RECS

            ABC.FILE.MAPPING.ID = R.ABC.FILE.EXPORT<AbcTable.AbcFileExport.FileMappingId,i>
            FILE.NAME = R.ABC.FILE.EXPORT<AbcTable.AbcFileExport.FileName,i>
            FILE.PATH = R.ABC.FILE.EXPORT<AbcTable.AbcFileExport.FilePath,i>

            GOSUB GET.VARIABLE.VALUE    ;*
            GOSUB DELETE.FILE ;*
            GOSUB WRITE.FILE  ;*

        NEXT i

    END

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.VARIABLE.VALUE>
GET.VARIABLE.VALUE:
***
    V.FECHA.FIN.IPAB = '!FECHA.FIN'     ;* YYMMDD

    Y.INDEX = INDEX(FILE.NAME,V.FECHA.FIN.IPAB,1)

    IF Y.INDEX GT 0 THEN

        FILE.NAME = CHANGE(FILE.NAME, V.FECHA.FIN.IPAB, FECHA.FIN[3,6])

    END

RETURN
*** </region>

*** <region name= DELETE.FILE>
DELETE.FILE:
***

    IF FILE.NAME NE FILE.NAME.AUX THEN
        CMD = 'rm ' : FILE.PATH : "/" : FILE.NAME
        EXEC CMD
        PRINT 'BORRANDO : ' : CMD
        FILE.NAME.AUX = FILE.NAME
    END

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= WRITE.FILE>
WRITE.FILE:
***

    SELECT.STATEMENT  = 'SELECT ':FN.ABC.FILE.REPORT.TMP
    SELECT.STATEMENT := ' WITH @ID LIKE ' : DQUOTE(SQUOTE(ABC.FILE.MAPPING.ID) : "..."):' BY @ID'     ;*Standardise the SELECT syntax   ; * ITSS - SANGAVI - Added DQUOTE / SQUOTE
    ABC.FILE.REPORT.TMP.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    EB.DataAccess.Readlist(SELECT.STATEMENT,ABC.FILE.REPORT.TMP.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    PRINT 'Escribiendo en: ' : FILE.NAME

    OPENSEQ FILE.PATH, FILE.NAME TO F.OUT.FILE THEN

    END

    IF ABC.FILE.REPORT.TMP.LIST THEN

        LOOP
            REMOVE ABC.FILE.REPORT.TMP.ID FROM ABC.FILE.REPORT.TMP.LIST SETTING ABC.FILE.REPORT.TMP.MARK
        WHILE ABC.FILE.REPORT.TMP.ID : ABC.FILE.REPORT.TMP.MARK

            EB.DataAccess.CacheRead(FN.ABC.FILE.REPORT.TMP,ABC.FILE.REPORT.TMP.ID,R.ABC.FILE.REPORT.TMP,YERR)
            LINE = R.ABC.FILE.REPORT.TMP

            WRITESEQ LINE APPEND TO F.OUT.FILE ELSE
                EB.ErrorProcessing.FatalError('OUTPUT FILE - WRITE ERROR')
            END

        REPEAT
    END ELSE
        WRITESEQ "" APPEND TO F.OUT.FILE ELSE
            EB.ErrorProcessing.FatalError('OUTPUT FILE - WRITE ERROR')
        END
    END

    CLOSESEQ F.OUT.FILE

RETURN
*** </region>
END

