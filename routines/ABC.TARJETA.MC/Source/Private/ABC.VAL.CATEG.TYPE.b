* @ValidationCode : Mjo0MDIwMDQzMjk6Q3AxMjUyOjE3NTU2MDg3MjQxMjA6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Aug 2025 10:05:24
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
$PACKAGE AbcTarjetaMc

SUBROUTINE ABC.VAL.CATEG.TYPE(Y.DEBIT.ACCT,Y.CREDIT.ACCT,Y.TRANS.TYPE.FT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING AbcTable
    $USING AbcSpei
    $USING AbcGetGeneralParam
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INICIO
    GOSUB PROCESO
    GOSUB VALIDA.DEBITO

RETURN
*===============================================================================
INICIO:



    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)


RETURN

*===============================================================================
PROCESO:

    Y.ID.PARAM= 'ABC.VAL.GARAN.PARAM'
    Y.CATEG.PARAM = 'CATEGORIA'
    Y.TRANS.TYPE= 'TRANSACTION.TYPE'

    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.ARR.NOM.PARAM, Y.ARR.DAT.PARAM)
    LOCATE Y.CATEG.PARAM IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.CATEGORIA = Y.ARR.DAT.PARAM<POS>
    END
    LOCATE Y.TRANS.TYPE IN Y.ARR.NOM.PARAM SETTING POS THEN
        Y.TYPE= Y.ARR.DAT.PARAM<POS>
        CHANGE ',' TO @FM IN Y.TYPE
    END


RETURN
*===============================================================================
VALIDA.DEBITO:
    EB.DataAccess.FRead(FN.ACCOUNT,Y.DEBIT.ACCT,R.ACCT.DEBIT,F.ACCOUNT,Y.ERR.ACCT)
    IF R.ACCT.DEBIT THEN
        Y.CATEG.DEBIT.ACCT =R.ACCT.DEBIT<AC.AccountOpening.Account.Category>
        IF Y.CATEG.DEBIT.ACCT EQ Y.CATEGORIA THEN
            LOCATE Y.TRANS.TYPE.FT IN Y.TYPE SETTING Y.POS THEN
                GOSUB VALIDA.CREDITO
            END ELSE

                ETEXT = "DEBIT.ACCOUNT CUENTA GARANTIZADA"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE
            GOSUB VALIDA.CREDITO
        END
    END


RETURN
*===============================================================================
VALIDA.CREDITO:

    EB.DataAccess.FRead(FN.ACCOUNT,Y.CREDIT.ACCT,R.ACCT.CREDIT,F.ACCOUNT,Y.ERR.ACCT)
    IF R.ACCT.CREDIT THEN
        Y.CATEG.CREDIT.ACCT =R.ACCT.CREDIT<AC.AccountOpening.Account.Category>
        IF Y.CATEG.CREDIT.ACCT EQ Y.CATEGORIA THEN
            LOCATE Y.TRANS.TYPE.FT IN Y.TYPE SETTING Y.POS THEN
                RETURN
            END ELSE
                ETEXT = "CREDIT.ACCOUNT CUENTA GARANTIZADA"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END

        END
          
    END
RETURN
*===============================================================================

END

