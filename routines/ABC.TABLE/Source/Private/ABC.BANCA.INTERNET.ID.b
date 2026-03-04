* @ValidationCode : Mjo2OTExMTY1NjY6Q3AxMjUyOjE3Njc2Njk1NjQzMTg6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Jan 2026 00:19:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcTable


SUBROUTINE ABC.BANCA.INTERNET.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer
    $USING EB.DataAccess
    $USING AbcSpei
    $USING EB.ErrorProcessing
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB CHECK.ID
    
RETURN


INITIALISE:

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    EB.DataAccess.Opf(FN.CUS,F.CUS)


RETURN
CHECK.ID:
* Validation and changes of the ID entered.  Sets V$ERROR to 1 if in error.

    COMI = EB.SystemTables.getComi()
    COMI.ENRI = ''
    
    EB.DataAccess.FRead(FN.CUS, COMI, R.CUS, F.CUS, Y.ERR.CUS)
    
    IF R.CUS NE '' THEN
        SAVE.COMI = COMI
        
        COMI = COMI:"*1"
        MSG = EB.SystemTables.getMessage()
        AbcSpei.abcVCustomerName(COMI,COMI.ENRI,MSG)

        NOM.CUS = COMI.ENRI
        ID.ENRI = " ":NOM.CUS
        EB.SystemTables.setComi(COMI)
        EB.SystemTables.setComiEnri(ID.ENRI )

    END ELSE
    
        ETEXT = 'EL CLIENTE NO EXISTE'
        EB.SystemTables.setE(ETEXT)

    END

RETURN


END
