*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.LIMPIA.LECTORA.CHQ
*---------------------------------------------------
* Autor         : 
* Fecha         : 
* Descripcion   : Se limpia la tabla ABC.TMP.LECTORA.CHQ, cada vez que se abre un TT, para que se pase un cheque nuevo.
*----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING AbcTable
    $USING EB.DataAccess
    
    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB FINALLY

    RETURN

*----------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------

    Y.OPERATOR  = EB.SystemTables.getOperator()
    Y.ID                = 'IP.CAJA'

    R.ABC.GENERAL.PARAM = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,Y.ID,R.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM,GRL.ERR)
    IF R.ABC.GENERAL.PARAM THEN
        Y.ARR.USER      = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.ARR.IP        = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)

        LOCATE Y.OPERATOR IN Y.ARR.USER SETTING POSITION THEN
            Y.IP = FIELD(Y.ARR.IP,FM,POSITION)
            EXECUTE "DELETE " : FN.ABC.TMP.LECTORA.CHQ :" ": Y.IP
        END
    END

    RETURN

*----------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------

    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

    FN.ABC.TMP.LECTORA.CHQ = "F.ABC.TMP.LECTORA.CHQ"
    F.ABC.TMP.LECTORA.CHQ  = ""
    EB.DataAccess.Opf(FN.ABC.TMP.LECTORA.CHQ,F.ABC.TMP.LECTORA.CHQ)

    RETURN

*----------------------------------------------------------------------------
FINALLY:
*----------------------------------------------------------------------------
END
