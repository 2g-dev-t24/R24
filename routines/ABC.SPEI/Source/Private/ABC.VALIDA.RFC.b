* @ValidationCode : MjotODUyNjkwNzcwOkNwMTI1MjoxNzY3NjY0MjUyMTQ5Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2026 22:50:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
SUBROUTINE ABC.VALIDA.RFC(Y.RFC,Y.ERR)

********************************************
* VALIDA CAMPO DE RFC SEA:
*     MORAL, FIDEICOMISO:
*               3 CARACTERES ALFABETICOS, *** NO APLICA *** PIF-20041019-001
*               6 NUMERICOS 2 A�O 2 MESES 2 DIA
*               3 ALFANUMERICOS
*
*     FISICA, FISICA CON ACTIVIDAD EMPRESARIAL:
*               4 CARACTERES ALFABETICOS, *** NO APLICA *** PIF-20041019-001
*               6 NUMERICOS 2 A�O 2 MES 2 DIA,
*               3 ALFANUMERICOS
*
*
* NOTAS:
*     DEBE CREAR UN REGISTRO EN PGM.FILE
*     PARA PODERLO USAR EN UNA VERSION
*
*    Y.RFC - In Parameter consist of Value of RFC to be Validated
*    Y.ERR - Out Parameter
*            0 - No Error
*            1 - On Error
********************************************
*
* $USING EB.SystemTables

    Y.ERR = 0
*   IF EB.SystemTables.getMessage() NE 'VAL' THEN
    GOSUB VALIDA
*   END

RETURN

********************************************
VALIDA:
********************************************
    IF (LEN(Y.RFC) LT 10) THEN
        Y.ERR = 1
        RETURN
    END

*FISICAS/ACTIVIDAD EMPRESARIAL
    IF (LEN(Y.RFC) EQ 13) OR (LEN(Y.RFC) EQ 10) THEN
        Y.ALF = Y.RFC[1,4]
        Y.FECHA = Y.RFC[5,6]
        IF NOT(Y.FECHA MATCH '6N') THEN
            Y.ERR = 1
            RETURN
        END
        Y.AA = Y.RFC[5,2]
        Y.MM = Y.RFC[7,2]
        Y.DD = Y.RFC[9,2]

    END
    IF (LEN(Y.RFC) EQ 12) THEN
*MORALES/FIDEICOMISO
        Y.ALF = Y.RFC[1,3]
        Y.FECHA = Y.RFC[4,6]
        IF NOT(Y.FECHA  MATCH '6N') THEN
            Y.ERR = 1
            RETURN
        END

        Y.AA = Y.RFC[4,2]
        Y.MM = Y.RFC[6,2]
        Y.DD = Y.RFC[8,2]

    END

    IF (Y.MM LT 1) OR (Y.MM GT 12) THEN
        Y.ERR = 1
        RETURN
    END

    IF (Y.DD LT 1) OR (Y.DD GT 31) THEN
        Y.ERR = 1
        RETURN
    END

RETURN

END
