* @ValidationCode : MjoxNjE4MTk0MTI2OkNwMTI1MjoxNzU2MTcwNTE0OTcyOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Aug 2025 22:08:34
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

$PACKAGE AbcAccount

SUBROUTINE BA.GET.ID.CTA.AHORRO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    $USING AbcTable
    $USING EB.Updates
    $USING EB.Security
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() NE 'I' THEN RETURN
    
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.ABC.DC = "F.ABC.DC"
    F.ABC.DC  = ""
    EB.DataAccess.Opf(FN.ABC.DC,F.ABC.DC)
    
    FN.BA.AC.FOLIOS= 'F.BA.AC.FOLIOS'
    FV.BA.AC.FOLIOS = ''
    EB.DataAccess.Opf(FN.BA.AC.FOLIOS,FV.BA.AC.FOLIOS)

    FN.BA.AC.SUCURSALES = 'F.BA.AC.SUCURSALES'
    FV.BA.AC.SUCURSALES = ''
    EB.DataAccess.Opf(FN.BA.AC.SUCURSALES,FV.BA.AC.SUCURSALES)
    
    Y.VERSION  = EB.SystemTables.getPgmVersion()
    Y.PRODUCTO = '' ;* Producto de la cuenta
    R.USER = EB.SystemTables.getRUser()
    Y.SUCURSAL = R.USER<EB.Security.User.UseDepartmentCode>[1,5]
    
    Y.BA.AC.FOL.REC = ''
    Y.PROD.REC      = ''
    Y.ID.CUENTA     = ''
    Y.FOLIO         = ''
    Y.LEN.CUENTA    = ''
    Y.SUMA.DIGITOS  = 0
    Y.MODULO = ''
    Y.SEL.CMD = ''
    Y.SEL.SUC = ''
    Y.NO.FOLIOS = 0
    Y.LIST.FOLIOS = ''
    Y.NO.SUC = 0
    Y.LIST.SUC = ''
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*Se ignora logica de account en este nivel
RETURN
***************

Y.SEL.SUC = "SSELECT ":FN.BA.AC.SUCURSALES:" WITH SUCURSAL EQ ":DQUOTE(Y.SUCURSAL)
EB.DataAccess.Readlist(Y.SEL.SUC,Y.LIST.SUC,'',Y.NO.SUC,'')

IF Y.LIST.SUC EQ '' OR Y.NO.SUC EQ 0 THEN
    E = "NO HAY SUCURSALES ASIGNADAS PARA ESTE USUARIO"
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.StoreEndError()
END

IF Y.LIST.SUC NE '' AND Y.NO.SUC GT 1 THEN
    E = "EXISTEN MAS DE 1 SUCURSAL CONFIGURADAS PARA ESTE USUARIO"
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.StoreEndError()
END

Y.SUCURSAL = Y.LIST.SUC<1>

Y.SEL.CMD = "SSELECT ":FN.BA.AC.FOLIOS:" WITH VERSION LIKE ":DQUOTE('...':SQUOTE(Y.VERSION))
EB.DataAccess.Readlist(Y.SEL.CMD,Y.LIST.FOLIOS,'',Y.NO.FOLIOS,'')

IF Y.LIST.FOLIOS EQ '' OR Y.NO.FOLIOS EQ 0 THEN
    E = "NO HAY FOLIOS CONFIGURADOS PARA LA VERSION"
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.StoreEndError()
END

IF Y.LIST.FOLIOS NE '' AND Y.NO.FOLIOS GT 1 THEN
    E = "EXISTEN MAS DE 1 FOLIO CONFIGURADO PARA LA MISMA VERSION"

END

Y.PRODUCTO = Y.LIST.FOLIOS<1>

EB.DataAccess.FRead(FN.BA.AC.FOLIOS,Y.PRODUCTO,Y.BA.AC.FOL.REC,FV.BA.AC.FOLIOS,Y.BA.AC.FOL.ERR)

IF Y.BA.AC.FOL.REC EQ '' THEN
    EB.SystemTables.setAf(0)
    E = "NO EXISTEN FOLIOS PARA ESTE PRODUCTO"
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.StoreEndError()
END

FIND Y.SUCURSAL IN Y.BA.AC.FOL.REC SETTING Ap, Vp, Sp THEN

    Y.FOLIO = Y.BA.AC.FOL.REC<AbcTable.BaAcFolios.Folio,Vp>

*Es el nmero mmo de cuentas que pueden abrirse por sucursal y producto
    IF Y.FOLIO EQ 99999 THEN
        E = "SE HA LLEGADO AL NUM. MAXIMO DE FOLIOS PARA LA SUCURSAL"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.StoreEndError()
    END

    IF Y.FOLIO LT 0 THEN
        E = "EL FOLIO NO PUEDE SER MENOR A CERO"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.StoreEndError()
    END

    Y.FOLIO = Y.FOLIO + 1
    Y.FOLIO = FMT(Y.FOLIO,"5'0'R")

    Y.BA.AC.FOL.REC<AbcTable.BaAcFolios.Folio,Vp> = Y.FOLIO

*Solucion del consecutivo de la cuenta JOR. 20160504
*************************************************************
    WRITE Y.BA.AC.FOL.REC TO FV.BA.AC.FOLIOS,Y.PRODUCTO
*************************************************************
    Y.ID.CUENTA = Y.SUCURSAL:Y.PRODUCTO:Y.FOLIO

*Obtenemos el dto verificador en base 10
    GOSUB GET.DIGITO.VERIFICADOR
    EB.SystemTables.setComi(Y.ID.CUENTA)
END ELSE
    EB.SystemTables.setAf(0)
    E = "NO EXISTEN FOLIOS PARA LA SUCURSAL"
    EB.SystemTables.setE(E)
    EB.ErrorProcessing.StoreEndError()
END

RETURN
*-----------------------------------------------------------------------------
GET.DIGITO.VERIFICADOR:
*-----------------------------------------------------------------------------
    Y.LEN.CUENTA = LEN(Y.ID.CUENTA)

    FOR YNO = 1 TO Y.LEN.CUENTA
        Y.SUMA.DIGITOS = Y.SUMA.DIGITOS + Y.ID.CUENTA[YNO,1]
    NEXT YNO

    Y.MODULO = MOD(Y.SUMA.DIGITOS,10)

    Y.ID.CUENTA := Y.MODULO
    
RETURN
*-----------------------------------------------------------------------------
END