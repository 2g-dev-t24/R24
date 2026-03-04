* @ValidationCode : Mjo4MTEwODg1NTU6Q3AxMjUyOjE3NjkxMzAxOTgzNjY6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2026 19:03:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.CAL.CAUSAL.REV.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.API
    $USING EB.Updates
    $USING AbcTable
    $USING EB.Service
    $USING AC.AccountOpening
    $USING EB.AbcUtil
*-----------------------------------------------------------------------------

    GOSUB INICIALIZA
    GOSUB OBTIENE.AC.LOCKED.CUSTOMER
    GOSUB SELECCIONA
    
    Y.NOMBRE.RUTINA = "ABC.CAL.CAUSAL.REV.SELECT"
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.DATA.LOG)
RETURN

***********
INICIALIZA:
***********

    FN.CUSTOMER = AbcCob.getFnCustomerRev()
    FN.AC.LOCKED.EVENTS = AbcCob.getFnAcLockedEventsRev()
    FN.ABC.SDO.COMP.IPAB = AbcCob.getFnAbcSdoCompIpabRev()
    F.ABC.SDO.COMP.IPAB = AbcCob.getFAbcSdoCompIpabRev()
    
    EB.Service.ClearFile(FN.ABC.SDO.COMP.IPAB, F.ABC.SDO.COMP.IPAB)

RETURN

***********
SELECCIONA:
***********
    IF AC.LOCKED.CUSTOMER.LIST THEN
        SELECT.STATEMENT  = 'SELECT ' : FN.CUSTOMER
        CUSTOMER.LIST = ''; LIST.NAME = '': SELECTED = ''; SYSTEM.RETURN.CODE = ''
        EB.DataAccess.Readlist(SELECT.STATEMENT,CUSTOMER.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
        EB.Service.BatchBuildList('',CUSTOMER.LIST)
        AbcCob.setAcLockedCustomerListRev(AC.LOCKED.CUSTOMER.LIST)
    END
    
RETURN

***************************
OBTIENE.AC.LOCKED.CUSTOMER:
***************************

    SELECT.STATEMENT  = 'SELECT ' : FN.AC.LOCKED.EVENTS :
*    SELECT.STATEMENT := ' WITH DESCRIPTION LIKE "':SQUOTE('OFC'):'..." OR "':SQUOTE('OFICIO'):'..." OR "':SQUOTE('ORDEN'):'..." OR "':SQUOTE('OFICO'):'..." SAVING EVAL "TRANS(FBNK.ACCOUNT,ACCOUNT.NUMBER,'
**     "SAVING EVAL "TRANS(FBNK.ACCOUNT,ACCOUNT.NUMBER,CUSTOMER,'C')'
    SELECT.STATEMENT := ' WITH (DESCRIPTION LIKE ':SQUOTE('OFC'):'... OR DESCRIPTION LIKE ':SQUOTE('OFICIO'):'... OR DESCRIPTION LIKE ':SQUOTE('ORDEN'):'... OR DESCRIPTION LIKE ':SQUOTE('OFICO'):'...)'
    AC.LOCKED.LIST = ''; LIST.NAME = '': SELECTED = ''; SYSTEM.RETURN.CODE = ''
    AC.LOCKED.CUSTOMER.LIST = ''
    EB.DataAccess.Readlist(SELECT.STATEMENT,AC.LOCKED.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    Y.DATA.LOG <-1> = "SELECT.STATEMENT=":SELECT.STATEMENT
    Y.DATA.LOG <-1> = "SELECTED=":SELECTED
**EAGUILAR - S
    LOOP
        REMOVE IDACLK FROM AC.LOCKED.LIST SETTING POS.ULTIMO
    WHILE IDACLK:POS.ULTIMO
        GOSUB GET.CUSTOMER.ID
    REPEAT
**EAGUILAR - E
RETURN


*-----------------------------------------------------------------------------
**EAGUILAR - S
*** <region name= GET.CUSTOMER.ID>
GET.CUSTOMER.ID:
*** <desc> </desc>
    REC.ACLE = AC.AccountOpening.LockedEvents.Read(IDACLK, ERR.ACLE)
    IF REC.ACLE THEN
        TEMP.ACCOUNT = REC.ACLE<AC.AccountOpening.LockedEvents.LckAccountNumber>
        REC.ACCOUNT = AC.AccountOpening.Account.Read(TEMP.ACCOUNT, ERR.ACCOUNT)
        IF REC.ACCOUNT THEN
            TEMP.CUSTOMER = REC.ACCOUNT<AC.AccountOpening.Account.Customer>
            LOCATE TEMP.CUSTOMER IN AC.LOCKED.CUSTOMER.LIST SETTING POS.CUSTOMER ELSE
                AC.LOCKED.CUSTOMER.LIST<-1> = TEMP.CUSTOMER
            END
        END
    END
RETURN
*** </region>
**EAGUILAR - E
END

