* @ValidationCode : MjotMTYxMzY1MzQ2NjpDcDEyNTI6MTc1NjMyNDM3Nzc0NDpVc3VhcmlvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Aug 2025 14:52:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usuario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE EB.AbcRemesas
SUBROUTINE ABC.VAL.ID.CUST.REME
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*===============================================================================
* Nombre de Programa : ABC.VAL.ID.CUST.REME
* Objetivo           : Valida que no se permitan nuevos registros de CUSTOMER
*                      Solo se permite ingresar un id de cliente existente para actualizacion de datos
* Requerimiento      : REMESAS
* Desarrollador      : Alexis Almaraz Robles - F&G Solutions
* Compania           : F&G Solutions
* Fecha Creacion     : 2022/06/02
* Subroutine Type    : VERSION
* Attached to        : CUSTOMER,ABC.ACT.DAT.REME
* Attached as        : ID.ROUTINE
*===============================================================================
* Modificaciones:
*===============================================================================
*--------------------------------------------------------------------------------------------
* Edgar Aguilar - EAGUILAR
* 25-agosto-2025
* Se realiza componetizacion de codigo
*-----------------------------------------------------------------------------
* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_F.CUSTOMER - Not Used anymore;
*-----------------------------------------------------------------------------
    $USING ST.Customer
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-------------------------------------------------------------------------------
INITIALIZE:
*-------------------------------------------------------------------------------

    Y.ID.CUSTOMER = EB.SystemTables.getComi()
    R.CUSTOMER = ''
    CUST.ERR = ''
    Y.MENSAJE = 'EB-ABC.VAL.CUST.REMESAS';* 'OPCION SOLO PARA ACTUALIZACION DE DATOS'

RETURN

*-------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------
    R.CUSTOMER = ST.Customer.Customer.Read(Y.ID.CUSTOMER, CUST.ERR)

    IF R.CUSTOMER EQ "" THEN
        EB.SystemTables.setE(Y.MENSAJE)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
RETURN

*-------------------------------------------------------------------------------
FINALLY:
*-------------------------------------------------------------------------------
RETURN
END
