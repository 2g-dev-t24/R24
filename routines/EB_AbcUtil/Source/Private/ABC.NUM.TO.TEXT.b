* @ValidationCode : Mjo0NzM5OTY3MDY6Q3AxMjUyOjE3NjQ2NzY0NjAxNTA6RWRnYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Dec 2025 05:54:20
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
SUBROUTINE ABC.NUM.TO.TEXT(NUM2TEXTBASE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    YVALUE = ''; YDECIM = ''; YNUM = '';

    YVALUE = INT(NUM2TEXTBASE)
    YDECIM = FIELD(NUM2TEXTBASE,'.',2)
    YNUM = YVALUE
    BEGIN CASE
        CASE YNUM EQ 0
            NUM2TEXTBASE = "CERO"
        CASE YNUM EQ 1
            NUM2TEXTBASE = "UN"
        CASE YNUM EQ 2
            NUM2TEXTBASE = "DOS"
        CASE YNUM EQ 3
            NUM2TEXTBASE = "TRES"
        CASE YNUM EQ 4
            NUM2TEXTBASE = "CUATRO"
        CASE YNUM EQ 5
            NUM2TEXTBASE = "CINCO"
        CASE YNUM EQ 6
            NUM2TEXTBASE = "SEIS"
        CASE YNUM EQ 7
            NUM2TEXTBASE = "SIETE"
        CASE YNUM EQ 8
            NUM2TEXTBASE = "OCHO"
        CASE YNUM EQ 9
            NUM2TEXTBASE = "NUEVE"
        CASE YNUM EQ 10
            NUM2TEXTBASE = "DIEZ"
        CASE YNUM EQ 11
            NUM2TEXTBASE = "ONCE"
        CASE YNUM EQ 12
            NUM2TEXTBASE = "DOCE"
        CASE YNUM EQ 13
            NUM2TEXTBASE = "TRECE"
        CASE YNUM EQ 14
            NUM2TEXTBASE = "CATORCE"
        CASE YNUM EQ 15
            NUM2TEXTBASE = "QUINCE"
    END CASE
END
