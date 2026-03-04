* @ValidationCode : MjotMjEzMjIxMDI3ODpDcDEyNTI6MTc1Njc1NzU1MTQyMzptYXV1YjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 01 Sep 2025 17:12:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauub
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
SUBROUTINE ABC.2BR.CC.MORAL.VALIDATE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    

    $USING AbcTable

    GOSUB INITIALIZE
    GOSUB CHECK.FIELDS
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.MNEMONIC.CUSTOMER = 'F.MNEMONIC.CUSTOMER'
    F.MNEMONIC.CUSTOMER = ''
    EB.DataAccess.Opf(FN.MNEMONIC.CUSTOMER,F.MNEMONIC.CUSTOMER)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)
RETURN
*-----------------------------------------------------------------------------
CHECK.FIELDS:
*-----------------------------------------------------------------------------
    
    COMI = EB.SystemTables.getComi()
    AF = EB.SystemTables.getAf()
    BEGIN CASE
        CASE AF = AbcTable.Abc2brCcMoral.Mnemonic
            IF EB.SystemTables.getROld(AbcTable.Abc2brCcMoral.Mnemonic) NE COMI THEN
                Y.MNEMONIC =  ''
                Y.MNEMONIC = COMI

                MNE.CUST.REC = '' ; MNE.CUS.ERR = ''
                EB.DataAccess.FRead(FN.MNEMONIC.CUSTOMER,Y.MNEMONIC,MNE.CUST.REC,F.MNEMONIC.CUSTOMER,MNE.CUS.ERR)
                IF MNE.CUST.REC THEN
                    EB.SystemTables.setE("MNEMONICO ya existe")
                    EB.SystemTables.setTSequ("IFLD")
                    EB.ErrorProcessing.Err()
                    RETURN
                END
            END

        CASE AF = AbcTable.Abc2brCcMoral.Account
            Y.ACCT = COMI

            Y.ACCT.REC = '' ; Y.ACCT.ERR = ''
            EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCT,Y.ACCT.REC,F.ACCOUNT,Y.ACCT.ERR)
            IF Y.ACCT.REC THEN
                Y.ACCT.CUST = Y.ACCT.REC<AC.AccountOpening.Account.Customer>
                Y.CUS.ID = FIELD(ID.NEW,".",1)
                IF Y.ACCT.CUST NE Y.CUS.ID THEN
                    EB.SystemTables.setE("No. cuenta no corresponde al cliente")
                    EB.SystemTables.setTSequ("IFLD")
                    EB.ErrorProcessing.Err()
                    RETURN
                END

                Y.AC.RFC = ''
                Y.ID.ARRAY = Y.ACCT.REC<AC.AccountOpening.Account.ArrangementId>
                EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
                IF R.ABC.ACCT.LCL.FLDS THEN

                    Y.AC.RFC = RAISE(R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutRfc>)
                END
                Y.RFC = FIELD(ID.NEW,".",2)
                LOCATE Y.RFC IN Y.AC.RFC<1,1> SETTING P1  ELSE
                    EB.SystemTables.setE("RFC de persona autorizada no corresponde a la cuenta")
                    EB.SystemTables.setTSequ("IFLD")
                    EB.ErrorProcessing.Err()
                    RETURN
                END


            END


    END CASE

*REM > CALL XX.CHECK.FIELDS
    IF EB.SystemTables.getE() THEN
        EB.SystemTables.setTSequ("IFLD")
        EB.ErrorProcessing.Err()
    END

RETURN

END