* @ValidationCode : Mjo4NTUzMzA5MDpDcDEyNTI6MTc1NjA4NTM0MDMyOTpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Aug 2025 22:29:00
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

SUBROUTINE ABC.REPLICA.MOD.CTA.INV
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    $USING AbcTable
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    ID.CUENTA.LINK = EB.SystemTables.getIdNew()
    R.INFO.ACC = ''
    ERROR.ACC = ''

    FN.ABC.ACCT.LCL.FLDS = 'F.ABC.ACCT.LCL.FLDS'
    F.ABC.ACCT.LCL.FLDS = ''
    EB.DataAccess.Opf(FN.ABC.ACCT.LCL.FLDS, F.ABC.ACCT.LCL.FLDS)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    SEL.AC = ''
    LISTA.AC = ''
    TOTAL.AC = ''
    ERROR.AC = ''
    BUILD.LIST = ''
    LISTA.AC = ''
*    SEL.AC = 'SELECT ':FN.ACCOUNT:' WITH CUENTA.LINK EQ ':DQUOTE(ID.CUENTA.LINK):' BY @ID'
    SEL.AC = 'SELECT ':FN.ABC.ACCT.LCL.FLDS:' WITH CUENTA.LINK EQ ':DQUOTE(ID.CUENTA.LINK):' BY @ID'
    EB.DataAccess.Readlist(SEL.AC,LISTA.AC,'',TOTAL.AC,ERROR.AC)

    IF TOTAL.AC GE 1 THEN GOSUB OBTIENE.VALORES

    FOR X = 1 TO TOTAL.AC
        AC.ID = LISTA.AC<X>
*        R.INFO.ACC = AC.AccountOpening.Account.Read(AC.ID, ERROR.ACC)
        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS, AC.ID, R.INFO.ACC, F.ABC.ACCT.LCL.FLDS, ERROR.ACC)
        IF R.INFO.ACC NE '' THEN
            GOSUB REPLICA.VALORES
*            WRITE R.INFO.ACC TO F.ACCOUNT,AC.ID
            WRITE R.INFO.ACC TO FN.ABC.ACCT.LCL.FLDS,AC.ID
        END ELSE
            ETEXT = 'LA CUENTA LINK NO EXISTE O NO PUEDE SER CONSULTADA'
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    NEXT X
    
RETURN
*-----------------------------------------------------------------------------
OBTIENE.VALORES:
*-----------------------------------------------------------------------------
*    Y.INACTIV.MARKER = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.InactivMarker)
    
RETURN
*-----------------------------------------------------------------------------
REPLICA.VALORES:
*-----------------------------------------------------------------------------
*    R.INFO.ACC<AbcTable.AbcAcctLclFlds.InactivMarker> = Y.INACTIV.MARKER
    R.INFO.ACC<AbcTable.AbcAcctLclFlds.CuentaLink> = ID.CUENTA.LINK

RETURN
*-----------------------------------------------------------------------------
END