* @ValidationCode : MjotNzYzMDgyMDUwOkNwMTI1MjoxNzU2MzI0MTIzMzE0OlVzdWFyaW86LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Aug 2025 14:48:43
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
SUBROUTINE ABC.E.ACTI.ECONO(ENQ.PARAM)
*-----------------------------------------------------------------------------
* Company Name : Banco Uala
* Developed By : FyG Solutions
* Product Name : EB
*--------------------------------------------------------------------------------------------
* Subroutine Type : ENQUIRY
* Attached to : ENQUIRY>ABC.ACTIVIDAD.ECONOMICA
* Attached as : BUILD.ROUTINE
* Primary Purpose : Rutina para filtrar por el valor del campo Industry de la tabla Customer.
*--------------------------------------------------------------------------------------------
* Edgar Aguilar - EAGUILAR
* 25-agosto-2025
* Se realiza componetizacion de codigo
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* $INSERT I_COMMON - Not Used anymore;
* $INSERT I_EQUATE - Not Used anymore;
* $INSERT I_ENQUIRY.COMMON - Not Used anymore;
* $INSERT I_PM.ENQ.COMMON - Not Used anymore;
* $INSERT I_F.COMPANY - Not Used anymore;
* $INSERT I_F.CUSTOMER - Not Used anymore;
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Reports
    $USING ST.Customer
*-----------------------------------------------------------------------------

    Y.EDO = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusIndustry)
*  Y.EDO = Y.EDO[1,4]
*----------------------------
* Fgv June/10/2006 Changed to take only the first two characters
*                  from the INDUSTRY as requested by BAM
* Fgv June/30/2006 Changed to take the first three characters
*                  from the INDUSTRY converting the leftmost to zeroes
*                  in case the lenght of the number is less that 4 as requested by BAM
*----------------------------
*  Y.EDO = Y.EDO[1,2]
    IF LEN(Y.EDO) LT 4 THEN
        Y.EDO = STR("0",4-LEN(Y.EDO)):Y.EDO
    END
    Y.EDO = Y.EDO[1,3]
*----------------------------
* Fgv June/10/2006 End
*----------------------------
    ENQ.PARAM<2,1> = '@ID'
    ENQ.PARAM<3,1> = 'BW'
    ENQ.PARAM<4,1,1> = Y.EDO:'...'

RETURN


END