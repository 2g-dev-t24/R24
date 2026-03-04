* @ValidationCode : MjoyMDAwMjA4NTEzOkNwMTI1MjoxNzYyOTEzOTQ3ODQ5Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Nov 2025 23:19:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTeller

SUBROUTINE ABC.2BR.E.EXTRAE.CTA.NOSTRO(ENQ.PARAM)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING AC.AccountOpening
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.CURRENCY = EB.SystemTables.getRNew(AbcTable.Abc2brBovedas.Moneda)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.CURRENCY EQ "" THEN
        RETURN
    END
    
    Y.REG.NOS.ACCT  = AC.AccountOpening.NostroAccount.Read(Y.CURRENCY, ErrNostro)

    IF (Y.REG.NOS.ACCT) THEN
        NOS.APPLICATION = Y.REG.NOS.ACCT<AC.AccountOpening.NostroAccount.EbNosApplication>
        Y.TOT.CTAS.NOS  = DCOUNT(NOS.APPLICATION, @VM)
        NOS.ACCOUNT     = Y.REG.NOS.ACCT<AC.AccountOpening.NostroAccount.EbNosAccount>
        FOR Y.CONT.CTAS.NOS = 1 TO Y.TOT.CTAS.NOS
            ENQ.PARAM<2,Y.CONT.CTAS.NOS>    = '@ID'
            ENQ.PARAM<3,Y.CONT.CTAS.NOS>    = 'EQ'
            ENQ.PARAM<4,Y.CONT.CTAS.NOS,1>  = NOS.ACCOUNT<1, Y.CONT.CTAS.NOS>
        NEXT Y.CONT.CTAS.NOS
**************************
* Fgv Mar/30/2006
*     Added ACCOUNT number MXN100009999 to enable the local development
*     to transfer cash from the main vault
**************************
        Y.CONT.CTAS.NOS = Y.CONT.CTAS.NOS +1
        
        ENQ.PARAM<2,Y.CONT.CTAS.NOS>      = '@ID'
        ENQ.PARAM<3,Y.CONT.CTAS.NOS>      = 'EQ'
        ENQ.PARAM<4,Y.CONT.CTAS.NOS,1>    = 'MXN100009999'
**************************
* Fgv Mar/30/2006 End
**************************
    END

RETURN
*-----------------------------------------------------------------------------
END
