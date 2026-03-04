$PACKAGE AbcCob

SUBROUTINE ABC.OBTIENE.TAX(Y.TAX.ID,FECHA,TAX)

    $USING EB.DataAccess
    $USING CG.ChargeConfig

    GOSUB INITIALISATION
    GOSUB MAIN.PROCESS

    RETURN

***************
INITIALISATION:
***************

    FN.TAX = 'F.TAX'
    F.TAX = ''
    EB.DataAccess.Opf(FN.TAX,F.TAX)

    TAX = 0

    RETURN

*************
MAIN.PROCESS:
*************

    SELECT.STATEMENT = 'SELECT ':FN.TAX:' WITH @ID LIKE ':DQUOTE(SQUOTE(Y.TAX.ID):"..."):' BY-DSND @ID'  ; *ITSS - TEJASHWINI - Added DQUOTE / SQUOTE
    TAX.LIST = ''; SELECTED = ''; SYSTEM.RETURN.CODE = ''
    EB.DataAccess.Readlist(SELECT.STATEMENT,TAX.LIST,"",SELECTED,SYSTEM.RETURN.CODE)

    FOR I = 1 TO SELECTED
        FECHA.TAX = FIELD(TAX.LIST<I>,'.',2)
        IF FECHA.TAX LT FECHA THEN
            EB.DataAccess.CacheRead(FN.TAX,TAX.LIST<I>,R.TAX,YERR)
            TAX = R.TAX<CG.ChargeConfig.Tax.EbTaxBandedRate>
            I = SELECTED
        END
    NEXT I

    RETURN

END
