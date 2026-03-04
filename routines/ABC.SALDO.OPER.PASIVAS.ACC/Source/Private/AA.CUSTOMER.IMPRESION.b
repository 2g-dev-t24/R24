* @ValidationCode : MjotMTc5OTUzNjI0ODpDcDEyNTI6MTc1OTAyNTc5NDEzMjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Sep 2025 23:16:34
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
$PACKAGE AbcSaldoOperPasivasAcc

SUBROUTINE AA.CUSTOMER.IMPRESION(ID.CLIENTE,NOMBRE.CLIENTE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING ST.Customer
    $USING EB.Updates
*-----------------------------------------------------------------------------

    GOSUB INICIALIZA
    GOSUB LEE.CLIENTE

RETURN
***********
INICIALIZA:
***********

    FN.CLIENTE = 'F.CUSTOMER'
    F.CLIENTE = ''
    EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)

    EB.Updates.MultiGetLocRef('CUSTOMER','CLASSIFICATION',YPOS.CLASSIFICATION)
    EB.Updates.MultiGetLocRef('CUSTOMER','FORMER.NAME',YPOS.FORMER.NAME)
    EB.Updates.MultiGetLocRef('CUSTOMER','NOM.PER.MORAL',YPOS.NOM.PER.MORAL)
    
     

RETURN
************
LEE.CLIENTE:
************

    NOMBRE.1 = ''; NOMBRE.2 = ''; APELLIDO.P = ''; APELLIDO.M = ''; ERROR.CLIENTE  = '';
    CLASSIFICATION = ''; R.INFO.CLIENTE = ''; NOMBRE.CLIENTE = '';

    IF ID.CLIENTE NE '' THEN
        EB.DataAccess.FRead(FN.CLIENTE,ID.CLIENTE,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
        Y.LOCAL.REF = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef>
        
        IF ERROR.CLIENTE EQ '' THEN
            APELLIDO.P = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusShortName,1>)
            APELLIDO.M = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne,1>)
            NOMBRE.1 = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameTwo,1>)
            NOMBRE.2 = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameTwo,2>)
            NOMBRE.3 = TRIM(R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameTwo,3>)
            
            CLASSIFICATION = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>
            IF CLASSIFICATION EQ 1001 OR CLASSIFICATION EQ 1100 THEN
                NOMBRE.CLIENTE = TRIM(NOMBRE.1:' ':NOMBRE.2:' ':NOMBRE.3:' ':APELLIDO.P:' ':APELLIDO.M)
            END ELSE
                IF CLASSIFICATION GE 2001 AND  CLASSIFICATION LE 2014 THEN
                    NOMBRE.CLIENTE = APELLIDO.P
                    IF NOMBRE.CLIENTE EQ '' THEN
                        NOMBRE.CLIENTE = TRIM(Y.LOCAL.REF<YPOS.NOM.PER.MORAL,1>)
                    END
                END ELSE
* IF CLASSIFICATION EQ 4 OR CLASSIFICATION EQ 5 THEN
                    NOMBRE.CLIENTE = APELLIDO.P
*  END
                END
            END
        END
    END

RETURN
**********
END

