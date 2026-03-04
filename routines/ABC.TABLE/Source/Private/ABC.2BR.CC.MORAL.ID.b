* @ValidationCode : MjotNzAyNDc0MjU2OkNwMTI1MjoxNzY2OTQ3MTAxNDY1Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Dec 2025 15:38:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.2BR.CC.MORAL.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING EB.TransactionControl
    $USING EB.LocalReferences
    $USING ST.Customer
*  $USING ABC.BP
    $USING AbcSpei
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB PROCESS

 
   
RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    EB.DataAccess.Opf(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.MNEMONIC.CUSTOMER = 'F.MNEMONIC.CUSTOMER'
    F.MNEMONIC.CUSTOMER = ''
    EB.DataAccess.Opf(FN.MNEMONIC.CUSTOMER,F.MNEMONIC.CUSTOMER)

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS)

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
* Validation and changes of the ID entered.  Set ERROR to 1 if in error.
    ID.NEW = EB.SystemTables.getIdNew()
    IF LEN(ID.NEW) GT 24 THEN
        ETEXT="ID no valido"
        EB.SystemTables.setE(ETEXT)
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END

    Y.FIRST.ID = ''
    Y.FIRST.ID = ID.NEW[1,1]

    IF ID.NEW[11,1] NE "." THEN
        ETEXT="Formato de ID no valido"
        EB.SystemTables.setE(ETEXT)
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END

    Y.CUS.ID = ''
    Y.CUS.ID = FIELD(ID.NEW,".",1)
    Y.CUS.REC = '' ; Y.CUS.ERR = ''
    EB.DataAccess.FRead(FN.CUSTOMER,Y.CUS.ID,Y.CUS.REC,F.CUSTOMER,Y.CUS.ERR)
    IF Y.CUS.ERR THEN
        ETEXT="No. cliente no valido"
        EB.SystemTables.setE(ETEXT)
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END ELSE
        Y.CUST.CLASS = Y.CUS.REC<ST.Customer.Customer.EbCusSector>
        IF Y.CUST.CLASS NE 3 THEN
            ETEXT="Cliente no es persona moral"
            EB.SystemTables.setE(ETEXT)
            V$ERROR = 1
            EB.SystemTables.setMessage("REPEAT")
            EB.ErrorProcessing.Err()
            RETURN
        END
    END

    Y.RFC = ''
    Y.ERR = ''
    Y.RFC = FIELD(ID.NEW,".",2)
    AbcSpei.AbcValidaRfc(Y.RFC,Y.ERR)
    IF Y.ERR EQ 1 THEN
        ETEXT="Numero de RFC no es valido"
        EB.SystemTables.setE(ETEXT)
        V$ERROR = 1
        EB.SystemTables.setMessage("REPEAT")
        EB.ErrorProcessing.Err()
        RETURN
    END


    Y.CUS.ACC.REC= '' ; Y.CUS.ACC.ERR = ''
    EB.DataAccess.FRead(FN.CUSTOMER.ACCOUNT,Y.CUS.ID,Y.CUS.ACC.REC,F.CUSTOMER.ACCOUNT,Y.CUS.ACC.ERR)
    IF Y.CUS.ACC.REC THEN
        NO.OF.AC = ''
        NO.OF.AC = DCOUNT(Y.CUS.ACC.REC,@FM)
        FOR Y.AC.LIST = 1 TO NO.OF.AC
            Y.AC.ID = ''
            Y.AC.ID = Y.CUS.ACC.REC<Y.AC.LIST>
            Y.ACCT.REC = '' ; Y.ACCT.ERR = ''
            EB.DataAccess.FRead(FN.ACCOUNT,Y.AC.ID,Y.ACCT.REC,F.ACCOUNT,Y.ACCT.ERR)
            IF Y.ACCT.REC THEN
                Y.AC.RFC = ''
                Y.ID.ARRAY = Y.ACCT.REC<AC.AccountOpening.Account.ArrangementId>
                EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ID.ARRAY,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,ERR.ABC.ACCT.LCL.FLDS)
                IF R.ABC.ACCT.LCL.FLDS THEN

                    Y.AC.RFC = RAISE(R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutRfc>)
                    Y.RFC = FIELD(ID.NEW,".",2)
                    LOCATE Y.RFC IN Y.AC.RFC<1,1> SETTING P2  THEN
                        NOMRE1 = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutNombre>
                        NOMRE2 = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutApePat>
                        NOMRE3 = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutApeMat>
                        ID.ENRI = NOMRE1:" ":NOMRE2:" ":NOMRE3
                        Y.AC.LIST = NO.OF.AC + 1
                    END
                END
                
            END
        NEXT Y.AC.LIST
        IF ID.ENRI EQ "" THEN
            ETEXT="RFC no esta asignado a ninguna cuenta del cliente"
            EB.SystemTables.setE(ETEXT)
            V$ERROR = 1
            EB.SystemTables.setMessage("REPEAT")
            EB.ErrorProcessing.Err()
            RETURN
        END
    END

************************

    IF EB.SystemTables.getE() THEN V$ERROR = 1

RETURN

END
