$PACKAGE ABC.BP

SUBROUTINE ABC.VALIDA.BLOQ.PREVIO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING ST.Customer

*-----------------------------------------------------------------------------
    
    GOSUB INIT
    GOSUB PROC
    
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.APP.LOC = 'CUSTOMER'
    Y.FIELD.LOC = 'ABC.FECHA.BLOQ':@VM:'ABC.FECHA.DBLOQ'
    Y.POS.LOC = ''
    EB.Updates.MultiGetLocRef(Y.APP.LOC, Y.FIELD.LOC, Y.POS.LOC)

    Y.POS.FEC.BLOQ = Y.POS.LOC<1,1>
    Y.POS.FEC.DBLOQ = Y.POS.LOC<1,2>

    Y.LOCAL.TABLE = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.FEC.BLOQ    = Y.LOCAL.TABLE<1, Y.POS.FEC.BLOQ>
    Y.FEC.DBLOQ   = Y.LOCAL.TABLE<1, Y.POS.FEC.DBLOQ>

RETURN
*-----------------------------------------------------------------------------
PROC:
*-----------------------------------------------------------------------------

    Y.CNT.MV = DCOUNT(Y.FEC.BLOQ, @SM)

    FOR Y.IDX = 2 TO Y.CNT.MV
        Y.VAL.FEC.BLOQ = FIELD(Y.FEC.BLOQ, @SM, Y.IDX)
        
        Y.IDX.PREV = Y.IDX - 1
        Y.VAL.FEC.DBLOQ.PREV = FIELD(Y.FEC.DBLOQ, @SM, Y.IDX.PREV)
        
        IF Y.VAL.FEC.BLOQ NE '' AND Y.VAL.FEC.DBLOQ.PREV EQ '' THEN
            EB.SystemTables.setAf(ST.Customer.Customer.EbCusLocalRef)
            EB.SystemTables.setAv(Y.POS.FEC.BLOQ)
            EB.SystemTables.setE("NO SE PUEDE BLOQUEAR SIN DESBLOQUEO PREVIO")
            EB.ErrorProcessing.Err()
        END
    NEXT Y.IDX
    
RETURN
*-----------------------------------------------------------------------------
END
