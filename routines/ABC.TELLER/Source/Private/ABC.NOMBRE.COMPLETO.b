*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.NOMBRE.COMPLETO(YINPUT.DATA)
*===============================================================================
* Rutina         : 
* Requerimiento  : 
* Banco          : 
* Modificado por : 
* Tipo           : 
* Fecha          : 
* Descripcion    : 
*===============================================================================

    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.Updates

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB PROCESS

    RETURN

*----------
INITIALIZE:
*----------

    Y.LOCAL.REF.APP   = 'CUSTOMER'
    Y.LOCAL.REF.FIELD =  'L.NOM.PER.MORAL'
    Y.LOCAL.REF.POS   = ''

    EB.Updates.MultiGetLocRef(Y.LOCAL.REF.APP,Y.LOCAL.REF.FIELD,Y.LOCAL.REF.POS)

    Y.NOM.PER.MORAL.POS  = Y.LOCAL.REF.POS   ;* Posicion campo L.NOM.PER.MORAL

    RETURN

*----------
OPEN.FILES:
*----------


    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    EB.DataAccess.Opf(FN.CUSTOMER,F.CUSTOMER)

    RETURN

*-------
PROCESS:
*-------
    Y.SHORT.NAME = ''
    Y.NAME.ONE = ''
    Y.NAME.TWO = ''

    Y.ID.CUSTOMER = TRIM(YINPUT.DATA)
    
    
    EB.DataAccess.FRead(FN.CUSTOMER, Y.ID.CUSTOMER, R.CUSTOMER, F.CUSTOMER, Y.ERR.CUSTOMER)
    IF R.CUSTOMER NE '' THEN
       
       Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
       Y.SECTOR = TRIM(Y.SECTOR)

       BEGIN CASE
         CASE Y.SECTOR EQ '1001' OR Y.SECTOR EQ '1100'
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

           YINPUT.DATA = Y.NOM
         CASE Y.SECTOR GE '2001' AND Y.SECTOR LE '2014'
           YINPUT.DATA = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef,Y.NOM.PER.MORAL.POS>
       END CASE

    RETURN

END
