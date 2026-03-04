* @ValidationCode : MjotMTE3NTA1MDc5ODpDcDEyNTI6MTc3MjU0NjIxMjUzMzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Mar 2026 10:56:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.

$PACKAGE AbcSpei

SUBROUTINE ABC.2BR.GET.CREDIT.CUST.NAME(YINPUT.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING ST.Customer
    $USING AbcSpei
    $USING AbcTeller
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.NOMBRE    = ''
    
*    Y.NOMBRE.APP    = "CUSTOMER"
*    Y.NOMBRE.CAMPO  = "FORMER.NAME":@VM:"NOMBRE.3"
*    EB.Updates.MultiGetLocRef(Y.NOMBRE.APP, Y.NOMBRE.CAMPO, R.POS.CAMPO)
*    Y.POS.FORMER.NAME   = R.POS.CAMPO<1,1>
*    Y.POS.NOMBRE.3      = R.POS.CAMPO<1,2>

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    YCUST.ID = YINPUT.DATA
    
    R.CUSTOMER  = ST.Customer.Customer.Read(YCUST.ID, YF.ERROR)

    IF R.CUSTOMER THEN
*        Y.CLASSIFICATION = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
*        EB.CUS.LOCAL.REF = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>

*Y.FORMER.NAME    = EB.CUS.LOCAL.REF<1,Y.POS.FORMER.NAME>
*Y.NOMBRE.3       = EB.CUS.LOCAL.REF<1,Y.POS.NOMBRE.3>
*Y.SHORT.NAME     = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
*Y.NAME.2         = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
*Y.NAME.1         = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
*AbcSpei.AbcIExtractName(Y.NOMBRE, Y.CLASSIFICATION, Y.SHORT.NAME, Y.NAME.1, Y.NAME.2, Y.FORMER.NAME, Y.NOMBRE.3)
        Y.NOMBRE = YCUST.ID
        AbcTeller.AbcNombreCompleto(Y.NOMBRE)
        YINPUT.DATA = Y.NOMBRE
    END ELSE
        YINPUT.DATA = ""
    END

RETURN
*-----------------------------------------------------------------------------
END
