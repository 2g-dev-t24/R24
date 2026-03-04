$PACKAGE AbcSpei
    SUBROUTINE ABC.CTA.EXT.VALIDATE

    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.Display

* Main Program Loop

***************************
*VARIABLES USADAS
***************************

    YPOS.CTA.EXT.TRANSF = 0

    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","CTA.EXT.TRANSF",YPOS.CTA.EXT.TRANSF)


    YPOS.CTA.BENEF.SPEUA = 0

    EB.LocalReferences.GetLocRef("FUNDS.TRANSFER","CTA.BENEF.SPEUA",YPOS.CTA.BENEF.SPEUA)
    Y.EXT.TRANS.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    IF Y.EXT.TRANS.ID<1,YPOS.CTA.EXT.TRANSF> THEN
        Y.EXT.TRANS.ID<1,YPOS.CTA.BENEF.SPEUA> = ""
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.EXT.TRANS.ID)
    END

    EB.Display.RebuildScreen()

    RETURN
