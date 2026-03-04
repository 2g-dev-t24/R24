* @ValidationCode : MjotMjA5OTY3ODk6Q3AxMjUyOjE3NjI5MjIwOTgyMzc6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Nov 2025 01:34:58
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

SUBROUTINE ABC.2BR.GET.AMOUNT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTeller
    $USING TT.Contract
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    YAMOUNT = AbcTeller.getYAmount()
    EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne, YAMOUNT)

    EB.Display.RebuildScreen()

RETURN
*-----------------------------------------------------------------------------
END