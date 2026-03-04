* @ValidationCode : MjoxOTk0NTg2NzQ5OkNwMTI1MjoxNzU4MTI2MTQyNzQ3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Sep 2025 13:22:22
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
$PACKAGE ABC.BP
SUBROUTINE ABC.ACT.ACTUALIZA.INTEREST
*===============================================================================
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING AC.AccountOpening
    $USING EB.Display
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.ErrorProcessing
    $USING AA.Framework

*------ Main Processing Section

    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
*    IF (Y.V.FUNCTION EQ 'A') THEN
    GOSUB INITIALISE
    GOSUB PROCESS
*    END
    
RETURN
*----------------------------------------
INITIALISE:
*----------------------------------------

    ID.NEW = EB.SystemTables.getIdNew()
    SEL.AC = ''
    LISTA.AC = ''
    TOTAL.AC = ''
    ERROR.AC = ''
    BUILD.LIST = ''
    LISTA.AC = ''
    Y.LISTA.AA.ID = ''

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    EB.DataAccess.Opf(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    
    FN.ABC.GENERAL.PARAM = 'F.ABC.GENERAL.PARAM'
    F.ABC.GENERAL.PARAM = ''
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM)
    
    FN.ABC.CHANGE.GROUP = 'F.ABC.CHANGE.GROUP'
    F.ABC.CHANGE.GROUP = ''
    EB.DataAccess.Opf(FN.ABC.CHANGE.GROUP, F.ABC.CHANGE.GROUP)



RETURN

*----------------------------------------
PROCESS:
*----------------------------------------
    EB.Updates.MultiGetLocRef("CUSTOMER","GROUP.CLASSIFIC",YCLS.POS)

    
    Y.LOCAL.REF = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusLocalRef)
    Y.GROUP.CLASSIFIC = Y.LOCAL.REF<1,YCLS.POS>
    Y.PARAM.ID = "TASAS"
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM, Y.PARAM.ID, R.ABC.GENERAL.PARAM, F.ABC.GENERAL.PARAM, Y.ERR.PARAM)
    
    IF R.ABC.GENERAL.PARAM THEN
        Y.LIST.PARAMS = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.NombParametro>)
        Y.LIST.VALUES = RAISE(R.ABC.GENERAL.PARAM<AbcTable.AbcGeneralParam.DatoParametro>)
    END ELSE
        ETEXT = 'No existe el par�metro ':Y.PARAM.ID:' en la tabla ABC.GENERAL.PARAM'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
   
    EB.DataAccess.FRead(FN.CUSTOMER.ACCOUNT,ID.NEW,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,Y.CUSTOMER.ACCOUNT.ERR)
    
    IF R.CUSTOMER.ACCOUNT THEN
        NO.OF.AC = ''
        NO.OF.AC = DCOUNT(R.CUSTOMER.ACCOUNT,@FM)
        FOR Y.AC.LIST = 1 TO NO.OF.AC
            Y.AC.ID = ''
            Y.AC.ID = R.CUSTOMER.ACCOUNT<Y.AC.LIST>
            Y.ACCT.REC = '' ; Y.ACCT.ERR = ''
            EB.DataAccess.FRead(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,Y.ACCT.ERR)
            IF R.ACCOUNT THEN
                Y.AC.RFC = ''
                Y.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>
                
                IF Y.CATEGORY EQ '6006' OR Y.CATEGORY EQ '6007' THEN
                           
                    LOCATE Y.CATEGORY IN Y.LIST.PARAMS SETTING Y.POS.GROUP ELSE

                        RETURN
                    END
                    Y.VALUE = Y.LIST.VALUES<Y.POS.GROUP>
                           
                    NO.OF.AC.TASA = DCOUNT(Y.VALUE,'*')
                    FOR Y.AC.LIST.TASA = 1 TO NO.OF.AC.TASA
                        Y.PARAMETROS.NOM = FIELDS(Y.VALUE,'*',Y.AC.LIST.TASA)
                        Y.PARAMETROS.DATO = FIELDS(Y.PARAMETROS.NOM,'|',2)
                        IF Y.GROUP.CLASSIFIC EQ Y.PARAMETROS.DATO THEN
                            Y.TASA = FIELDS(Y.PARAMETROS.NOM,'|',1)
                        END
                    NEXT Y.AC.LIST.TASA
                    Y.R.ACCOUNT = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
                    Y.LISTA.AA.ID<-1> = Y.R.ACCOUNT

                    Y.ID.ARRAY = Y.R.ACCOUNT
                           
                           
                        
                    R.AA<AA.Framework.ArrangementActivity.ArrActArrangement>    = Y.AC.ID
                    R.AA<AA.Framework.ArrangementActivity.ArrActProperty>        = 'CRINTEREST'
                    R.AA<AA.Framework.ArrangementActivity.ArrActActivity>       = 'ACCOUNTS-CHANGE-CRINTEREST'
                    R.AA<AA.Framework.ArrangementActivity.ArrActCustomer>       = ID.NEW
                    R.AA<AA.Framework.ArrangementActivity.ArrActFieldName>      = 'FIXED.RATE'
                    R.AA<AA.Framework.ArrangementActivity.ArrActFieldValue>     = Y.TASA
                           
                    Y.OFS.REQUEST   = ''
                    Y.OFS.APP       = 'AA.ARRANGEMENT.ACTIVITY'
                    Y.OFS.VERSION   = 'AA.ARRANGEMENT.ACTIVITY,'
                    Y.ID            = Y.ID.ARRAY
                    Y.ID.CUSTOMER   = ''
                    Y.NO.OF.AUTH    = 0
                    Y.GTSMODE       = ''
    
                    EB.Foundation.OfsBuildRecord(Y.OFS.APP,'I','PROCESS',Y.OFS.VERSION,Y.GTSMODE,Y.NO.OF.AUTH,Y.ID.CUSTOMER,R.AA,Y.OFS.REQUEST)

                    EB.Interface.OfsAddlocalrequest(Y.OFS.REQUEST, 'APPEND', Error)
                    IF Error THEN
                        EB.SystemTables.setEtext(Error)
                        EB.ErrorProcessing.StoreEndError()
                        RETURN
                    END
                        
                END
            END
        NEXT Y.AC.LIST
    END
        
    EB.DataAccess.FRead(FN.ABC.CHANGE.GROUP,EB.SystemTables.getToday(),R.ABC.CHANGE.GROUP,F.ABC.CHANGE.GROUP,Y.ABC.CHANGE.GROUP.ERR)
        

    NO.OF.AC.ID = DCOUNT(Y.LISTA.AA.ID,@FM)
    FOR Y.AC.LIST.ID = 1 TO NO.OF.AC.ID
        R.ABC.CHANGE.GROUP<AbcTable.AbcChangeGroup.idAa,-1> = Y.LISTA.AA.ID<Y.AC.LIST.ID>
    NEXT Y.AC.LIST.ID

    EB.DataAccess.FWrite(FN.ABC.CHANGE.GROUP,EB.SystemTables.getToday(),R.ABC.CHANGE.GROUP)
        


RETURN
*----------------------------------------
END

