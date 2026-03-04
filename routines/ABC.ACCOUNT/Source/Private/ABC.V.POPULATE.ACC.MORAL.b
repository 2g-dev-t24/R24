* @ValidationCode : MjotODAxMDUzNTcxOkNwMTI1MjoxNzU2OTUwNjU3NzQ1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Sep 2025 22:50:57
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

$PACKAGE AbcAccount

SUBROUTINE ABC.V.POPULATE.ACC.MORAL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING ST.Customer
    $USING EB.Security
    $USING EB.ErrorProcessing

    $USING AbcTable
    $USING EB.Interface
    $USING EB.Updates
    $USING AbcAccount
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getMessage() = 'VAL' THEN RETURN
    
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    TODAY = EB.SystemTables.getToday()
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB VALIDA.ACCTOFFC
    
    GIC.CUST.ID = EB.SystemTables.getComi()
    
    GOSUB CONCAT.NOMBRES

    GIC.CUST.REC = ''
    GIC.CUST.REC = ST.Customer.Customer.Read(GIC.CUST.ID, GIC.CUST.ERR)
    
    IF (GIC.CUST.REC) THEN
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.AccountTittle1, Y.NAME)

        Y.TIPO.CTE = GIC.CUST.REC<ST.Customer.Customer.EbCusSector>
        Y.TIPO.CTE = Y.TIPO.CTE[1,1]
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Classification, Y.TIPO.CTE)

        AbcAccount.AbcRtnAccInhibeCb(Y.TIPO.CTE)
        
        AC.OFFICER = GIC.CUST.REC<ST.Customer.Customer.EbCusAccountOfficer>
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.AccountOfficer,AC.OFFICER)

        AC.OPENING.DATE = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.OpeningDate)
        IF LEN(AC.OPENING.DATE) = 0 THEN
            EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.OpeningDate, TODAY)
        END

        EB.Display.RefreshField(AbcTable.AbcAcctLclFlds.AccountOfficer, "")
        EB.Display.RebuildScreen()
    END
    
*    AbcAccount.AbcVGetClabe()
*    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
VALIDA.ACCTOFFC:
*-----------------------------------------------------------------------------
    CUST.ID = EB.SystemTables.getComi()
    DEPT.FLAG = 'N'

    YRECORD = ''
    YRECORD = ST.Customer.Customer.Read(CUST.ID, CUST.ERR)
    
    YACCT.OFFICER = YRECORD<ST.Customer.Customer.EbCusAccountOfficer>
    YOTHER.OFFICER = YRECORD<ST.Customer.Customer.EbCusOtherOfficer>

    R.USER = EB.SystemTables.getRUser()
    YDEPT.CURR.USER = R.USER<EB.Security.User.UseDepartmentCode>[1,9]
    
    IF YDEPT.CURR.USER EQ YACCT.OFFICER[1,9] THEN
        DEPT.FLAG = 'Y'
    END ELSE
        YNO.CONT = DCOUNT(YOTHER.OFFICER,@VM)
        FOR YCONT = 1 TO YNO.CONT
            IF R.USER<EB.Security.User.UseDepartmentCode> EQ YOTHER.OFFICER<1,YCONT> THEN
                DEPT.FLAG = 'Y'
                YCONT = YNO.CONT + 1
            END
        NEXT
    END
    
RETURN
*-----------------------------------------------------------------------------
CONCAT.NOMBRES:
*-----------------------------------------------------------------------------
    Y.ESPACIO    = " "
    Y.CUST.NO    = EB.SystemTables.getComi()
    Y.DOUBLE.ESP = "  "

    R.CUSREC = ''
    R.CUSREC = ST.Customer.Customer.Read(Y.CUST.NO, ERR.CUS)
    
    Y.APELLIDO.P    = R.CUSREC<ST.Customer.Customer.EbCusShortName>
    Y.APELLIDO.M    = R.CUSREC<ST.Customer.Customer.EbCusNameOne>
    Y.NOMBRE.1      = R.CUSREC<ST.Customer.Customer.EbCusNameTwo>
*    Y.CUS.REF       = R.CUSREC<ST.Customer.Customer.EbCusLocalRef>

    Y.CLASSIFICATION    = R.CUSREC<ST.Customer.Customer.EbCusSector>
    Y.CLASS.SHORT       = Y.CLASSIFICATION[1,1]

*    IF Y.CLASS.SHORT EQ 1 OR Y.CLASS.SHORT EQ 2 THEN
    IF Y.CLASS.SHORT EQ 1 THEN
        ETEXT = "CLIENTE " : Y.CUST.NO : " NO ES PERSONA MORAL, UTILICE ALTA DE CUENTAS PARA PERSONA FISICA "
*        EB.SystemTables.setE(ETEXT)
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        IF Y.CLASS.SHORT EQ 3 OR Y.CLASS.SHORT EQ 2 THEN
            Y.NAME = Y.APELLIDO.P
        END ELSE
            IF Y.CLASS.SHORT EQ 4 OR Y.CLASS.SHORT EQ 5 THEN
                Y.NAME = Y.APELLIDO.P
            END
        END
    END

    EB.SystemTables.setComiEnri(Y.NAME)
    
RETURN
*-----------------------------------------------------------------------------
END