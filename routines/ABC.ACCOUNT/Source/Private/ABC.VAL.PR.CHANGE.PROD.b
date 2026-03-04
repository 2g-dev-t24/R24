$PACKAGE AbcAccount

SUBROUTINE ABC.VAL.PR.CHANGE.PROD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AA.Account
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.POST.REST = EB.SystemTables.getRNew(AA.Account.Account.AcPostingRestrict)
    IF Y.POST.REST THEN
        ETEXT = "La cuenta se encuentra bloqueada: [Bloqueada LPB]"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
RETURN
*-----------------------------------------------------------------------------
END