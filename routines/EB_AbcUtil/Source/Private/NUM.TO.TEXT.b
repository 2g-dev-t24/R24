* @ValidationCode : MjotMTY1MzQyNjc4MTpDcDEyNTI6MTc2NDY3NjU0NjYzNzpFZGdhcjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Dec 2025 05:55:46
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
*-----------------------------------------------------------------------------
* <Rating>559</Rating>
*-----------------------------------------------------------------------------

SUBROUTINE NUM.TO.TEXT(NUM2TEXT)

*-----------------------------------------------------------------------------

    $USING EB.AbcUtil

    YVALUE = ''; YDECIM = ''; YNUM = '';

    YVALUE = INT(NUM2TEXT)
    YDECIM = FIELD(NUM2TEXT,'.',2)
    YNUM = YVALUE

    BEGIN CASE
        CASE YNUM EQ 0
            NUM2TEXT = "CERO"
        CASE YNUM EQ 1
            NUM2TEXT = "UN"
        CASE YNUM EQ 2
            NUM2TEXT = "DOS"
        CASE YNUM EQ 3
            NUM2TEXT = "TRES"
        CASE YNUM EQ 4
            NUM2TEXT = "CUATRO"
        CASE YNUM EQ 5
            NUM2TEXT = "CINCO"
        CASE YNUM EQ 6
            NUM2TEXT = "SEIS"
        CASE YNUM EQ 7
            NUM2TEXT = "SIETE"
        CASE YNUM EQ 8
            NUM2TEXT = "OCHO"
        CASE YNUM EQ 9
            NUM2TEXT = "NUEVE"
        CASE YNUM EQ 10
            NUM2TEXT = "DIEZ"
        CASE YNUM EQ 11
            NUM2TEXT = "ONCE"
        CASE YNUM EQ 12
            NUM2TEXT = "DOCE"
        CASE YNUM EQ 13
            NUM2TEXT = "TRECE"
        CASE YNUM EQ 14
            NUM2TEXT = "CATORCE"
        CASE YNUM EQ 15
            NUM2TEXT = "QUINCE"
        CASE YNUM LT 20
            YNUM -= 10
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = "DIECI" : YNUM
        CASE YNUM EQ 20
            NUM2TEXT = "VEINTE"
        CASE YNUM LT 30
            YNUM -= 20
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = "VEINTI" : YNUM
        CASE YNUM EQ 30
            NUM2TEXT = "TREINTA"
        CASE YNUM EQ 40
            NUM2TEXT = "CUARENTA"
        CASE YNUM EQ 50
            NUM2TEXT = "CINCUENTA"
        CASE YNUM EQ 60
            NUM2TEXT = "SESENTA"
        CASE YNUM EQ 70
            NUM2TEXT = "SETENTA"
        CASE YNUM EQ 80
            NUM2TEXT = "OCHENTA"
        CASE YNUM EQ 90
            NUM2TEXT = "NOVENTA"
        CASE YNUM LT 100
            YNUM = INT(YVALUE / 10) * 10    ;* PARTE ENTERA
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = YNUM : " Y "
            YNUM = YVALUE - INT(YVALUE / 10) * 10
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT := YNUM
        CASE YNUM EQ 100
            NUM2TEXT = "CIEN"
        CASE YNUM LT 200
            YNUM -= 100
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = "CIENTO " : YNUM
        CASE YNUM EQ 200 OR YNUM EQ 300 OR YNUM EQ 400 OR YNUM EQ 600 OR YNUM EQ 800
            YNUM = YNUM / 100
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = YNUM : "CIENTOS"
        CASE YNUM EQ 500
            NUM2TEXT = "QUINIENTOS"
        CASE YNUM EQ 700
            NUM2TEXT = "SETECIENTOS"
        CASE YNUM EQ 900
            NUM2TEXT = "NOVECIENTOS"
        CASE YNUM LT 1000
            YNUM = INT(YVALUE / 100) * 100
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = YNUM : " "
            YNUM = YVALUE - INT(YVALUE / 100) * 100
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT := YNUM
        CASE YNUM EQ 1000
            NUM2TEXT = "UN MIL"
        CASE YNUM LT 2000
            YNUM = YVALUE - INT(YVALUE / 1000) * 1000
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = "UN MIL " : YNUM
        CASE YNUM LT 1000000
            YNUM = INT(YVALUE / 1000)
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT =  YNUM : " MIL"
            YNUM = YVALUE - INT(YVALUE / 1000) * 1000
            IF YNUM THEN
                EB.AbcUtil.abcNumToText(YNUM)
                NUM2TEXT := " " : YNUM
            END
        CASE YNUM EQ 1000000
            NUM2TEXT = "UN MILLON"
        CASE YNUM LT 2000000
            YNUM = YVALUE - INT(YNUM / 1000000) * 1000000
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = "UN MILLON " : YNUM
        CASE YNUM LT 1000000000000
            YNUM = INT(YVALUE / 1000000)
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT =  YNUM : " MILLONES"
            YNUM = YVALUE - INT(YVALUE / 1000000) * 1000000
            IF YNUM THEN
                EB.AbcUtil.abcNumToText(YNUM)
                NUM2TEXT := " " : YNUM
            END
        CASE YNUM EQ 1000000000000
            NUM2TEXT = "UN BILLON"
        CASE YNUM LT 2000000000000
            YNUM = YVALUE - INT(YVALUE / 1000000000000) * 1000000000000
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = "UN BILLON " : YNUM
        CASE 1
            YNUM = INT(YVALUE / 1000000000000)
            EB.AbcUtil.abcNumToText(YNUM)
            NUM2TEXT = YNUM : " BILLONES"
            YNUM = YVALUE - INT(YVALUE / 1000000000000) * 1000000000000
            IF YNUM THEN
                EB.AbcUtil.abcNumToText(YNUM)
                NUM2TEXT := " " : YNUM
            END
    END CASE
    IF YDECIM THEN
        NUM2TEXT := ' PESOS ' : YDECIM : '/100'
    END
********
END
