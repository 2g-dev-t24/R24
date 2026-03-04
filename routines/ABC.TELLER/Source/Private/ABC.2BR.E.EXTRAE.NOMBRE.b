* @ValidationCode : MjoxNDY0MDg1OTUzOkNwMTI1MjoxNzYyOTEzMjMxMzczOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Nov 2025 23:07:11
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

SUBROUTINE ABC.2BR.E.EXTRAE.NOMBRE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING TT.Config
    $USING EB.Reports
    $USING ST.CompanyCreation
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    F.TELLER.PARAMETER  = ""
    FN.TELLER.PARAMETER = "F.TELLER.PARAMETER"
    EB.DataAccess.Opf(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

    Y.SOLICITANTE   = EB.Reports.getOData()
    Y.DESC          = ""

    Y.ID.PARAM = EB.SystemTables.getIdCompany()

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    ST.CompanyCreation.EbReadParameter(FN.TELLER.PARAMETER,'N','',Y.REG.TELLER.P,Y.ID.PARAM,F.TELLER.PARAMETER,Y.ERROR)
    IF Y.ERROR THEN
        PAR.VAULT.ID    = Y.REG.TELLER.P<TT.Config.TellerParameter.ParVaultId>
        PAR.VAULT.DESC  = Y.REG.TELLER.P<TT.Config.TellerParameter.ParVaultDesc>
        Y.TOT.BOV = DCOUNT(PAR.VAULT.ID, @VM)
        FOR Y.CONT.BOV = 1 TO Y.TOT.BOV
            IF Y.SOLICITANTE EQ PAR.VAULT.ID<1, Y.CONT.BOV> THEN
                Y.DESC = PAR.VAULT.DESC<1, Y.CONT.BOV>
            END
        NEXT Y.CONT.BOV
    END
    
    EB.Reports.setOData(Y.DESC)

RETURN
*-----------------------------------------------------------------------------
END
