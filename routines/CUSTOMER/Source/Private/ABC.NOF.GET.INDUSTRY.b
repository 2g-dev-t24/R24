$PACKAGE ABC.BP
SUBROUTINE ABC.NOF.GET.INDUSTRY(R.DATA)
***********************************************************

    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Config

    GOSUB INIT.VARS
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

**********
INIT.VARS:
**********

    Y.SEP        = "*"

    FN.INDUSTRY = 'F.INDUSTRY'
    F.INDUSTRY = ''

RETURN

***********
OPEN.FILES:
***********

    EB.DataAccess.Opf(FN.INDUSTRY, F.INDUSTRY)

    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()

RETURN

********
PROCESS:
********

    LOCATE "INDUSTRY.CODE" IN SEL.FIELDS SETTING IND.POS THEN
        Y.IND.POS = SEL.VALUES<IND.POS>
        Y.EDO = Y.IND.POS
    END

    IF LEN(Y.EDO) LT 4 THEN
       Y.EDO = Y.EDO[1,1]
    END ELSE
        Y.EDO = Y.EDO[1,2]
    END

    R.DATA = ""
    Y.CADENA.SALIDA = ""
    SEL.CMD = "SELECT " : FN.INDUSTRY : " WITH INDUSTRY.CODE LIKE '" :DQUOTE(Y.EDO): "...'"

    EB.DataAccess.Readlist(SEL.CMD,Y.LIST.REG,'',Y.NO.REGISTROS,Y.SELECT.CMD.ERR)
        
    FOR Y.I = 1 TO Y.NO.REGISTROS 
        Y.ID.IND = Y.LIST.REG<Y.I>
        IF LEN(Y.IND.POS) EQ LEN(Y.ID.IND) THEN
            EB.DataAccess.FRead(FN.INDUSTRY, Y.ID.IND, R.INDUSTRY, F.INDUSTRY, ERR.IND)
            Y.IND.DESC = R.INDUSTRY<ST.Config.Industry.EbIndDescription>
            Y.CADENA.SALIDA = Y.ID.IND : Y.SEP : Y.IND.DESC : Y.SEP
            R.DATA<-1> = Y.CADENA.SALIDA
        END
    NEXT Y.I

RETURN

END
