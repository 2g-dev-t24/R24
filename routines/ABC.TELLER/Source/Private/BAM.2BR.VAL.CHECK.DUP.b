* @ValidationCode : MjotMTM3Njk3MjE6Q3AxMjUyOjE3NTczODE1NDU0OTU6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 08 Sep 2025 22:32:25
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

SUBROUTINE BAM.2BR.VAL.CHECK.DUP
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING TT.Contract
    $USING EB.Updates
*-----------------------------------------------------------------------------
    Y.FUNCTION = EB.SystemTables.getVFunction()
    IF Y.FUNCTION NE 'R' THEN
        GOSUB INITIALISE
        GOSUB VALIDATE
    END
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    F.TELLER  = ""
    FN.TELLER = "F.TELLER"
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)
    
RETURN
*-----------------------------------------------------------------------------
VALIDATE:
*-----------------------------------------------------------------------------
*CAMBIO REALIZADO PARA OBTENERLA CUENTA DE CLIENTE DESDE CAMPO LOCAL PORQUE EL CAMPO CORE NO ES ACTUALIZADO CUANDO ES LANZADA ESTA RUTINA
*MARCO MORENO AHORA SE USA EL CAMPO DRAW.ACCT.NO EN LUGAR DE CHEQUE.ACCT.NO
    Y.APP       = "TELLER"
    Y.FLD       = "DRAW.ACCT.NO"
    Y.POS.FLD   = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    YPOS.ACCT   = Y.POS.FLD<1,1>

    YBANK.NUM       = EB.SystemTables.getRNew(TT.Contract.Teller.TeChequeBankCde)
*CAMBIO REFERIDO EN LINEAS ANTERIORES
    TT.TE.LOCAL.REF = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    YACCT.NUM       = TT.TE.LOCAL.REF<1,YPOS.ACCT>
    YCHECK.NUM      = EB.SystemTables.getRNew(TT.Contract.Teller.TeChequeNumber)
    
    YNUM    = 0
    YSTATUS = ""
    YLIST   = ""
    SELECT.CMD = 'SELECT ':FN.TELLER:' WITH CHEQUE.BANK.CDE EQ ':DQUOTE(YBANK.NUM):' AND DRAW.ACCT.NO EQ ':DQUOTE(YACCT.NUM):' AND CHEQUE.NUMBER EQ ':DQUOTE(YCHECK.NUM)
*    CALL EB.READLIST(SELECT.CMD,YLIST,'',YNUM,YSTATUS)

    IF YNUM NE 0 THEN
        TEXT = "CHEQUE YA FUE INGRESADO HOY"
        EB.SystemTables.setText(TEXT)
        EB.Display.Rem()
        EB.SystemTables.setE(TEXT)
        RETURN
    END
    
RETURN
*-----------------------------------------------------------------------------
END