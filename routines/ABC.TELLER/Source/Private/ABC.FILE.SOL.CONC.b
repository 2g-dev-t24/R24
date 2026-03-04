* @ValidationCode : MjotNDE0NDc3NTg1OkNwMTI1MjoxNzcxNDQxNDIxMDkxOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Feb 2026 16:03:41
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

$PACKAGE AbcTeller

SUBROUTINE ABC.FILE.SOL.CONC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    
    $USING AbcTable
    $USING EB.Updates
    $USING EB.Security
    $USING ST.Config
    $USING TT.Config
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
*Abrimos tabla donde se guardan las solicitudes de CONCENTRACIONES y
*DOTACIONES de las sucursales

    FN.ABC.2BR.BOVEDAS = "F.ABC.2BR.BOVEDAS"
    F.ABC.2BR.BOVEDAS = ""
    EB.DataAccess.Opf(FN.ABC.2BR.BOVEDAS,F.ABC.2BR.BOVEDAS)

*Tabla para extraer el nombre del solicitante

    F.USER = ""
    FN.USER = "F.USER"
    EB.DataAccess.Opf(FN.USER,F.USER )

*Tabla de Deptos. para sacar el nombre de sucursal

    F.DAO = ""
    FN.DAO = "F.DEPT.ACCT.OFFICER"
    EB.DataAccess.Opf(FN.DAO,F.DAO)

*Tabla para extraer CALLE, NUMERO,COLONIA DE LA SUCURSAL

    F.ABC.2BR.CHQ.PROVEEDOR = ""
    FN.ABC.2BR.CHQ.PROVEEDOR = "F.ABC.2BR.CHQ.PROVEEDOR"
    EB.DataAccess.Opf(FN.ABC.2BR.CHQ.PROVEEDOR,F.ABC.2BR.CHQ.PROVEEDOR )

*Tabla donde se guardan denominaciones por moneda

    F.TELLER.DENOMINATION = ""
    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION,F.TELLER.DENOMINATION)

***Tabla de parametria
    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM  = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

***
*Variables de inicio
***
    Y.DATOS.PLANO   = ""
    SEL.LIST        = ""
    NUM.REC         = 0
    Y.BOV.ID        = ""
    R.BOVEDA        = ""
    BOV.ERR1        = ""
    
**Manejo de archivo
    R.DATOS = ''
    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,'ABC.FILE.SOL.CONC',R.DATOS,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.NOMB.PARAMETROS = R.DATOS<AbcTable.AbcGeneralParam.NombParametro>
    FIND 'RUTA.ARCHIVO' IN Y.NOMB.PARAMETROS SETTING AH, VH, SH THEN
        Y.RUTA.ARCHIVO = R.DATOS<AbcTable.AbcGeneralParam.DatoParametro,VH>
    END

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
***
*Leemos registros de la tabla de solicitudes con estado (A)ceptada
***
    Y.ESTADO    = 'A'
    Y.ESTADO1   = 'T'
    SEL.CMD = "SELECT ":FN.ABC.2BR.BOVEDAS:" WITH ESTADO EQ '":Y.ESTADO:"'":" OR ESTADO EQ ":DQUOTE(Y.ESTADO1)  ; * ITSS - ADOLFO - Added DQUOTE / SQUOTE
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NUM.REC,RET.CODE)

    LOOP
        REMOVE Y.BOV.ID FROM SEL.LIST SETTING POS
    WHILE Y.BOV.ID:POS
        EB.DataAccess.FRead(FN.ABC.2BR.BOVEDAS,Y.BOV.ID,R.BOVEDA,F.ABC.2BR.BOVEDAS,BOV.ERR1)
***
*Por medio del tipo grabo si es (C)ONCENTRACION o (D)OTACION y concateno
*con los 2 ultimos digitos del folio de la solicitud
***
        BVD.TIPO = R.BOVEDA<AbcTable.Abc2brBovedas.Tipo>
        IF BVD.TIPO = "C" THEN
            Y.TIPO.OPER = "C"
        END
        IF BVD.TIPO = "D" THEN
            Y.TIPO.OPER = "D"
        END
        Y.TIPO.OPER = Y.TIPO.OPER:SUBSTRINGS(Y.BOV.ID,LEN(Y.BOV.ID)-1,2)
***
* Acceso a F.USER con usuario que solicita, para sacar nombre del usuario
* y codigo de departamento
***
        Y.NAME.USUARIO  = ""
        USR.SOLICITA    = R.BOVEDA<AbcTable.Abc2brBovedas.UsrSolicita>
        EB.DataAccess.FRead(FN.USER,USR.SOLICITA,Y.REG.USER,F.USER,USR.ERR)
        IF Y.REG.USER THEN
            Y.NAME.USUARIO      = Y.REG.USER<EB.Security.User.UseUserName>
            USE.DEPARTMENT.CODE = Y.REG.USER<EB.Security.User.UseDepartmentCode>
            Y.DEPT = SUBSTRINGS(USE.DEPARTMENT.CODE,1,5)
        END
***
* Acceso a F.DAO con Y.DEPT para sacar nombre de la sucursal
***
        Y.NOMB.SUCURSAL = ""
        EB.DataAccess.FRead(FN.DAO,Y.DEPT,Y.REG.SUC,F.DEPT.ACCT.OFFICER,ERR2)
        Y.NOMB.SUCURSAL = Y.REG.SUC<ST.Config.DeptAcctOfficer.EbDaoName>
***
* Acceso a F.ABC.2BR.CHQ.PROVEEDOR con Y.DEPT para direccion de la sucursal
***
        Y.CALLE.SUC     = ""
        Y.NUMERO.SUC    = ""
        Y.COLONIA.SUC   = ""
        Y.DELMUN.SUC    = ""
        Y.ESTADO.SUC    = ""
        EB.DataAccess.FRead(FN.ABC.2BR.CHQ.PROVEEDOR,Y.DEPT,Y.DOM.SUC,F.ABC.2BR.CHQ.PROVEEDOR,ERR2)
        Y.CALLE.SUC = Y.DOM.SUC<AbcTable.Abc2BrChqProveedor.Calle>
        Y.NUMERO.SUC = Y.DOM.SUC<AbcTable.Abc2BrChqProveedor.NumExt>
        Y.COLONIA.SUC = Y.DOM.SUC<AbcTable.Abc2BrChqProveedor.Colonia>
***
* Multiplico por 100 para dejar monto con 2 decimales en texto plano
***
        Y.TOTAL = R.BOVEDA<AbcTable.Abc2brBovedas.Monto>
        Y.TOTAL = (Y.TOTAL)*100
        Y.FOLIO = R.BOVEDA<AbcTable.Abc2brBovedas.Referencia>
***
* Construyo parte del registro a grabar
***
        Y.CADENA  = FMT(Y.DEPT,"R%6")
        Y.CADENA := FMT(Y.NOMB.SUCURSAL,"L#20")
        Y.CADENA := FMT(Y.CALLE.SUC,"L#30")
        Y.CADENA := FMT(Y.NUMERO.SUC,"R#30")
        Y.CADENA := FMT(Y.COLONIA.SUC,"L#30")
        Y.CADENA := FMT(Y.DELMUN.SUC,"L#30")
        Y.CADENA := FMT(Y.ESTADO.SUC,"L#30")
        Y.CADENA := Y.TIPO.OPER
        Y.CADENA := FMT(Y.NAME.USUARIO,"L#30")
        Y.CADENA := FMT(Y.TOTAL,"R%15")
        Y.CADENA := FMT(Y.FOLIO,"R#12")
***
* Acceso FN.TELLER.DENOMINATION con el tipo de moneda
***
        Y.CURRENCY  = R.BOVEDA<AbcTable.Abc2brBovedas.Moneda>
        YLD.NO      = ''
        YLD.ID      = ''
        SELECT.CMD  = "SELECT ":FN.TELLER.DENOMINATION:" WITH @ID LIKE ":DQUOTE(SQUOTE(Y.CURRENCY):"..."):" BY-DSND VALUE"  ;*  ; * ITSS - ADOLFO - Added DQUOTE / SQUOTE
        EB.DataAccess.Readlist(SELECT.CMD,YLD.ID,'',YLD.NO,'')
        Y.NUM.DENOMINACION  = YLD.NO
        Y.ID.DENOMINACION   = YLD.ID
        
        BVD.DENOMINACION    = R.BOVEDA<AbcTable.Abc2brBovedas.Denominacion>
        BVD.MONTO.DENOM     = R.BOVEDA<AbcTable.Abc2brBovedas.MontoDenom>
        Y.TOT.DEN = DCOUNT(BVD.DENOMINACION, @VM)
        FOR Y.CON.DENOMINACION = 1 TO Y.NUM.DENOMINACION
            Y.DEN.TMP = Y.ID.DENOMINACION<Y.CON.DENOMINACION>
            EB.DataAccess.FRead(FN.TELLER.DENOMINATION,Y.DEN.TMP,Y.REG.DENO,F.TELLER.DENOMINATION,TT.DEN.ERR)
            
            IF Y.REG.DENO THEN
                Y.VAL = Y.REG.DENO<TT.Config.TellerDenomination.DenValue>
                Y.CANT = BVD.MONTO.DENOM<1,Y.CON.DENOMINACION>
                Y.MONTO.DEN = (Y.VAL * Y.CANT)*100
                Y.CADENA :=FMT(Y.CANT, "R%6"):FMT(Y.MONTO.DEN, "R%15")
            END
        NEXT Y.CON.DENOMINACION
        Y.DATOS.PLANO<-1> = Y.CADENA

    REPEAT
***
*Genero el nombre del archivo
***
    Y.TIME = TIMEDATE()
    CHANGE ' ' TO '' IN Y.TIME
    CHANGE ':' TO '' IN Y.TIME
    Y.NOMBRE.ARCHIVO = "SOL-":SUBSTRINGS(Y.TIME,7,9):SUBSTRINGS(Y.TIME,1,6)
    
***
*Abrimos archivo plano
***
*    OPEN '',"ABC.SOLBOV" TO F.EXTRACTO ELSE Y.MENSAJE="ERROR AL ABRIR ARCHIVO PLANO"

    OPEN '',Y.RUTA.ARCHIVO TO F.EXTRACTO ELSE Y.MENSAJE="ERROR AL ABRIR ARCHIVO PLANO"
   
***
*Grabo el registro en el archivo
***
    WRITE Y.DATOS.PLANO TO F.EXTRACTO,Y.NOMBRE.ARCHIVO

    TEXT = "Archivo generado de solicitudes: ":Y.NOMBRE.ARCHIVO
    EB.SystemTables.setText(TEXT)
    EB.Display.Rem()

RETURN
*-----------------------------------------------------------------------------
END
