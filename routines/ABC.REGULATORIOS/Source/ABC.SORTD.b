* @ValidationCode : MjoxNzEzMDE3NjQxOkNwMTI1MjoxNzYzMDQ0Mjc4ODI0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Nov 2025 11:31:18
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
$PACKAGE AbcRegulatorios


SUBROUTINE ABC.SORTD(INP.DARRAY, OUT.DARRAY, SORT.ORDER)
*-----------------------------------------------------------------------------
*
*======================================================================
* Purpose:Sorts a dynamic array into another dynamic array. If the second one
* is empty it helps to sort one array(the result is always in the output array)
*
* Description:
*       This routine is called from another routine:
*       Input:
*         -INP.DARRAY Input dynamic array containg scratch data
*         -SORT.ORDER wanted order(ascending,descending,...)
*       Output
*         -OUT.DARRAY Output dynamic array containg sorted data
*
* Usage:o To sort one array then,make the Output array empty. Therefor the
*           result is in the output array
*         o To place an array in another one,in order to have one sorted array:
*         . Then if the second one is not soted sort it using previous method
*         . if it is sorted,let the first one the Input Array and the second
*           one(which is sorted) the Output Array
*         o Always specify Sort Order("AL","DL,...)
*         o You can't sort the array into itself,means the Input equal to
*           the Output array
*===========================================================================
*
*
* Logs    :
* 31/01/01  - Creation
* 01/12/2008  - Modificación:  LBASABE
* La rutina dejaba fuera siempre el último valor del arreglo TEMP.DARRAY
* se cambió la condición final para incluirlo
*
*===========================================================================
*-----------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------
*   ODR NUMBER                        : ODR-2009-11-0108
*   R09 UPGRADE DONE BY               : TAM
*-----------------------------------------------------------------------------
    TEMP.DARRAY = ''
*==================================================================
* Main
    FMCount = DCOUNT(INP.DARRAY, @FM)
    fcount = 1
*
    SSELECT INP.DARRAY TO TEMP.DARRAY
*// Read the Input dynamic array

    LOOP
*fcount +=1
        READNEXT DATA1 FROM TEMP.DARRAY THEN
            dummy = 1
        END
        IF DATA1 THEN
            fcount+=1
        END
        LOCATE DATA1 IN OUT.DARRAY<1> BY SORT.ORDER SETTING FPOS
        ELSE
            INS DATA1 BEFORE OUT.DARRAY<FPOS>
        END
    WHILE fcount LE FMCount REPEAT      ;* Se cambia LT por LE en esta última condición
RETURN
*
*===========================================================================
END


