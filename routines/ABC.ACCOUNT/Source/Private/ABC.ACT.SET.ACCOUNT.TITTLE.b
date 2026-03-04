* @ValidationCode : MjoxMzkxNTU5NDg5OkNwMTI1MjoxNzcxOTAyMzQxMjI4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Feb 2026 00:05:41
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
* <Rating>43</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcAccount
SUBROUTINE ABC.ACT.SET.ACCOUNT.TITTLE

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING AA.Framework
    $USING AA.Account
    $USING AC.AccountOpening
    
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*

*----------
INITIALISE:
*----------

* Orden "1"
* Nombre Apellido P Apellido M
*
* Orden ""
* Apellido P Apellido M Nombre
*

    Y.ORDEN = ""
    Y.ESPACIO = " "
    
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""

    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)

RETURN

*-------
PROCESS:
*-------
    AAA.REF = AA.Framework.getRArrangementActivity()
    Y.CUST.NO = AAA.REF<AA.Framework.ArrangementActivity.ArrActCustomer>

    EB.DataAccess.FRead(FN.CUSTOMER,Y.CUST.NO,R.CUSTOMER,F.CUSTOMER,CUS.ERR)

    Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>

    Y.NAME = ""

    BEGIN CASE
        
        CASE Y.SECTOR EQ 1001 OR Y.SECTOR EQ 1100
            
            Y.SHORT.NAME = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
            IF Y.SHORT.NAME THEN
                Y.NOM<-1> = Y.SHORT.NAME
            END

            Y.NAME.ONE = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
            IF Y.NAME.ONE THEN
                Y.NOM<-1> = Y.NAME.ONE
            END

            Y.NAME.TWO = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
            IF Y.NAME.TWO THEN
                Y.NOM<-1> = Y.NAME.TWO
            END
         
            CHANGE @FM TO " " IN Y.NOM
            
            Y.NAME = Y.NOM

        CASE Y.SECTOR GE 2001 AND Y.SECTOR LE 2014
            Y.CUS.REF = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef>
            EB.Updates.MultiGetLocRef("CUSTOMER","L.NOM.PER.MORAL",NOM.PER.MORAL.POS)
            Y.NAME = Y.CUS.REF<1,NOM.PER.MORAL.POS>
        CASE Y.SECTOR EQ 2200
            Y.NAME = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
* Mandatos. Ya no se utiliza
        CASE Y.SECTOR = 5
            Y.NAME = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
    END CASE
    
    EB.SystemTables.setRNew(AA.Account.Account.AcAccountTitleOne, Y.NAME)
    EB.SystemTables.setRNew(AA.Account.Account.AcShortTitle, Y.NAME)

    
RETURN
END

