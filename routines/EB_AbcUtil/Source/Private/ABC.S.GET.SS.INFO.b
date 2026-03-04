* @ValidationCode : Mjo5ODM3NTg1MTI6Q3AxMjUyOjE3NjQ4MDk3NjkwNzA6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Dec 2025 18:56:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE EB.AbcUtil
**IN.FIELD<1> : Nombre del campo a buscar
**IN.FIELD<1> : Aplicacion en donde se debe buscar el campo
**OUT.VALUE  : valor de salida el nombre del campo
SUBROUTINE ABC.S.GET.SS.INFO(IN.FIELD,OUT.VALUE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.API
    $USING EB.SystemTables
*-----------------------------------------------------------------------------

    IN.FIELD.NAME = IN.FIELD<1,1>
    YAPP = IN.FIELD<1,2>
    R.STANDARD.SELECTION = EB.SystemTables.StandardSelection.Read(YAPP, ERR.SS)
* Before incorporation : CALL F.READ(FN.STANDARD.SELECTION,YAPP,R.STANDARD.SELECTION,F.STANDARD.SELECTION,ERR.SS)
    EB.API.FieldNamesToNumbers(IN.FIELD.NAME,R.STANDARD.SELECTION,FIELD.NO,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
    
    IF FIELD.NO THEN
        OUT.VALUE<1> = FIELD.NO
    END
    IF YAF THEN
        OUT.VALUE<2> = YAF
    END
    IF YAV THEN
        OUT.VALUE<3> = YAF
    END
    IF YAS THEN
        OUT.VALUE<4> = YAS
    END
    IF ERR.MSG THEN
        OUT.VALUE<5> = ERR.MSG
    END
END
