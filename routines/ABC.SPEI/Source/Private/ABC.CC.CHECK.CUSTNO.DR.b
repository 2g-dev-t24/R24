* @ValidationCode : MjoxODU1NjQxNDgzOkNwMTI1MjoxNzU2NzU3NTM2MDUyOm1hdXViOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 01 Sep 2025 17:12:16
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
*-----------------------------------------------------------------------------
* <Rating>99</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.CC.CHECK.CUSTNO.DR

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Security
    $USING AC.AccountOpening
    $USING AbcTable
    $USING EB.ErrorProcessing

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    EB.LocalReferences.GetLocRef("USER","CC.CUST.ID",YUSER.CUST.LR)

RETURN
    
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    R.USER = EB.SystemTables.getRUser()
    YUSER.CC.CUST =  R.USER<EB.Security.User.UseLocalRef,YUSER.CUST.LR>

    YUSER.CUST = FIELD(YUSER.CC.CUST,'.',1)


    IF NOT(TRIM(YUSER.CUST)) THEN
        EB.SystemTables.setE('NO EXISTE UNA LLAMADA ACTIVA')
        EB.ErrorProcessing.Err()
        EB.SystemTables.setComi('')
        RETURN
    END

    IF YUSER.CC.CUST[11,1] = "." THEN
        F.ABC.2BR.CC.MORAL = ''
        FN.ABC.2BR.CC.MORAL = 'F.ABC.2BR.CC.MORAL'
        EB.DataAccess.Opf(FN.ABC.2BR.CC.MORAL,F.ABC.2BR.CC.MORAL)
        YREC.CC.MORAL = ""
        EB.DataAccess.FRead(FN.ABC.2BR.CC.MORAL, YUSER.CC.CUST, YREC.CC.MORAL, F.ABC.2BR.CC.MORAL, Y.ERR)

    END

    IF YUSER.CC.CUST[11,1] = "." THEN
        LOCATE EB.SystemTables.getComi() IN YREC.CC.MORAL<AbcTable.Abc2brCcMoral.Account,1> SETTING YPOS.ACCT THEN
            IF YREC.CC.MORAL<AbcTable.Abc2brCcMoral.Transaction,YPOS.ACCT> EQ 'N' THEN
                EB.SystemTables.setE("CLIENTE NO ESTA AUTORIZADO A OPERAR CON CUENTA")
                EB.ErrorProcessing.Err()
                EB.SystemTables.setComi('')
            END
        END ELSE

            EB.SystemTables.setE("CUENTA NO CORRESPONDE A CLIENTE")
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
        END



    END ELSE

        YACCT = EB.SystemTables.getComi()
        R.ACCOUNT = AC.AccountOpening.Account.Read(YACCT, Y.ERR.ACCOUNT)
        EB.SystemTables.setE('')
        YCUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        IF YCUSTOMER NE YUSER.CUST THEN
            EB.SystemTables.setE("CUENTA NO CORRESPONDE A CLIENTE")
            EB.ErrorProcessing.Err()
            EB.SystemTables.setComi('')
        END
    END
RETURN
END

