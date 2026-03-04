*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.UPDATE.DC.ACC.ENRI

*===============================================================================
* Nombre de Programa:   ABC.UPDATE.DC.ACC.ENRI
* Objetivo:             Rutina que actualiza el enrichment del campo ACCOUNT.NUMBER.D y ACCOUNT.NUMBER.C
* Desarrollador:        
* Compania:             
* Fecha Creacion:       
* Modificaciones:
*===============================================================================

    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING EB.Display

    GOSUB INITIALIZE
    GOSUB PROCESS
    RETURN


*---------------------------------------------------
INITIALIZE:
*---------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    Y.ACCOUNT = EB.SystemTables.getComi()

    RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    R.ACCOUNT = ''
    EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.ACCOUNT.TITLE.1 = R.ACCOUNT<AC.AccountOpening.Account.AccountTitleOne>
        OFS$ENRI<EB.SystemTables.getAf(),EB.SystemTables.getAv()> = Y.ACCOUNT.TITLE.1
    END

    EB.Display.RebuildScreen()

    RETURN
**********
END
