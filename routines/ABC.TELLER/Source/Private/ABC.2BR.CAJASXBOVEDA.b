* @ValidationCode : MjotMTgxNzc5NTkwNjpDcDEyNTI6MTc2NjQxMzU5NDA2MDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Dec 2025 11:26:34
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
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
SUBROUTINE ABC.2BR.CAJASXBOVEDA
*****************************************************************************************

    $USING AC.AccountOpening
    $USING TT.Contract
    $USING EB.Security
    $USING EB.DataAccess
    $USING EB.Reports
*****************************
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    
RETURN
*****************************
INIT:
*****************************
    SELECT.CMD      = ''
    NO.OF.REC       = ''
    GRL.ERR         = ''
    SELECT.CMD1     = ''
    NO.OF.REC1      = ''
    SELECT.CMD2     = ''
    NO.OF.REC2      = ''

    FN.AC           = 'F.ACCOUNT'
    F.AC            = ''
    AC.SELECT.LIST  = ''
    ACREC.LIST      = ''

    FN.US           = 'F.USER'
    F.US            = ''
    USREC.LIST      = ''

    FN.TI           = 'F.TELLER.ID'
    F.TI            = ''
    TI.SELECT.LIST  = ''
    TIREC.LIST      = ''
    TI2.SELECT.LIST = ''
    TI2REC.LIST     = ''

RETURN
*****************************
OPENFILES:
*****************************
    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.Opf(FN.TI,F.TI)
    EB.DataAccess.Opf(FN.US,F.US)

RETURN
*****************************
PROCESS:
*****************************
    Y.CAJA     = EB.Reports.getOData()
    TIREC.LIST = ''
    Y.COMPARA  = ''
    EB.DataAccess.FRead(FN.TI, Y.CAJA, TIREC.LIST, F.TI, GRL.ERR)

    IF NOT(GRL.ERR) THEN
        Y.COMPARA = TIREC.LIST<TT.Contract.TellerId.TidDeptCode>
    END

    TI2.SELECT.LIST =''
    NO.OF.REC1 = ''

    SELECT.CMD1 = ''
    SELECT.CMD1  = 'SSELECT ':FN.TI:' WITH DEPT.CODE EQ ':DQUOTE(Y.COMPARA)
    SELECT.CMD1 := " AND TELLER.ID LT '9500' AND TELLER.ID NE ":DQUOTE(Y.CAJA)
    

    EB.DataAccess.Readlist(SELECT.CMD1, TI2.SELECT.LIST, Y.NO, NO.OF.REC1, Y.ERR)

    F.ENTREGA = ''

    IF NO.OF.REC1 GT 0 THEN

        FOR IND = 1 TO NO.OF.REC1

            Y.TELLER.ID = TI2.SELECT.LIST<IND>
            TI2REC.LIST = ''
            EB.DataAccess.FRead(FN.TI,Y.TELLER.ID,TI2REC.LIST, F.TI, GRL.ERR)
            ENTREGA  = ''
            CAJA     = ''
            CANTIDAD = ''

            NO.MONEDA = DCOUNT(TI2REC.LIST<TT.Contract.TellerId.TidCategory>,@VM)       ;*VM

            FOR IND2 = 1 TO  NO.MONEDA

                MONEDA   = TI2REC.LIST<TT.Contract.TellerId.TidCurrency,IND2>          ;*QUITAR EL ,IND2
                CATEGORY = TI2REC.LIST<TT.Contract.TellerId.TidCategory,IND2>          ;*NUEVO


                BEGIN CASE
                    CASE MONEDA EQ 'MXN' AND CATEGORY EQ '10000'
                        CATEGORIA = MONEDA:CATEGORY   ;
                        Y.MON     = 'MXN'
                        REGISTRO  = CATEGORIA:Y.TELLER.ID

                    CASE MONEDA EQ 'USD' AND CATEGORY EQ '10000'
                        CATEGORIA = MONEDA:CATEGORY   ;
                        Y.MON     = 'USD'

                        REGISTRO  = CATEGORIA:Y.TELLER.ID

                    CASE MONEDA EQ 'USD' AND CATEGORY EQ '19424'
                        CATEGORIA = MONEDA:CATEGORY   ;
                        Y.MON     = 'USDTC'
                        REGISTRO  = CATEGORIA:Y.TELLER.ID
                    CASE 1
                        REGISTRO  = 'X1000'

                END CASE

                READ ACREC.LIST FROM F.AC, REGISTRO THEN
                    CANTIDAD = ACREC.LIST<AC.AccountOpening.Account.OnlineActualBal>
                    IF CANTIDAD EQ '' THEN
                        CANTIDAD = '0.00'
                    END
                END ELSE
                    CANTIDAD = "*****"
                END

                ENTREGA = "CAJA ":Y.TELLER.ID:" : ":CANTIDAD:SPACE(1):Y.MON:SPACE(4)
                F.ENTREGA := ENTREGA
                O.DATA = F.ENTREGA
                EB.Reports.setOData(O.DATA)

            NEXT IND2
        NEXT IND
    END ELSE
        O.DATA = "NO HAY CAJAS ASIGNADAS A ESTA BOVEDA"
        EB.Reports.setOData(O.DATA)
    END

RETURN
*****************************
END
