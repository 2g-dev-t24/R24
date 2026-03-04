* @ValidationCode : MjoxMzg1MTcyMjYzOkNwMTI1MjoxNzYxMjU5NjIzMDIyOm1hdXJpY2lvLmxvcGV6Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Oct 2025 19:47:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcAccountApi

SUBROUTINE ABC.BEF.UPD.CUS

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.Interface
    $USING EB.Foundation

    R.CUSTOMER<ST.Customer.Customer.EbCusCustomerStatus> = 1

    Y.OFS.REQUEST   = ''
    Y.OFS.APP       = 'CUSTOMER'
    Y.OFS.VERSION   = 'CUSTOMER,'
    Y.ID            = ''
    Y.ID.CUSTOMER   = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)
    Y.NO.OF.AUTH    = 0
    Y.GTSMODE       = ''
    
    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.CUSTOMER,Y.OFS.REQUEST)

    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
    IF Error THEN
        EB.SystemTables.setEtext(Error)
        EB.ErrorProcessing.StoreEndError()
    END
RETURN

END
