* @ValidationCode : MjotNTAzNjU3MTEyOkNwMTI1MjoxNzY4NjE3MjQ5ODAxOkVkZ2FyOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jan 2026 20:34:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcRegulatorios
SUBROUTINE ABC.OEMN.GENERA.SECC2
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING TT.Contract
    $USING AbcTable
    $USING AC.AccountOpening
    $USING EB.AbcUtil
    
    GOSUB INICIALIZACION
    GOSUB OBTIENE.PARAMETROS
    GOSUB PROCESO
    Y.NOMBRE.RUTINA = "ABC.OEMN.GENERA.SECC2"
    EB.AbcUtil.abcEscribeLogGenerico(Y.NOMBRE.RUTINA, Y.DATA.LOG)
RETURN

***************
INICIALIZACION:
***************

    Y.SEP =","
    Y.SEP2 = CHAR(10)
    Y.NA='0'
    Y.TIPO.OPERACION=""
    Y.NIVEL=4
    Y.NIVEL.0='0'
    Y.TIPO.CLIENTE=1
    GOSUB ABRIR.ARCHIVOS

RETURN

*******************
OBTIENE.PARAMETROS:
******************

    EB.DataAccess.FRead(FN.ABC.GENERAL.PARAM,'ABC.OEMN.2',R.DATOS.GP,F.ABC.GENERAL.PARAM,ERR.PARAM)
    Y.NOMB.PARAMETROS = R.DATOS.GP<AbcTable.AbcGeneralParam.NombParametro>

    FIND 'INSTITUCION' IN Y.NOMB.PARAMETROS SETTING AA, VA, SA THEN
        Y.INSTITUCION = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VA>
    END
    FIND 'CLABE' IN Y.NOMB.PARAMETROS SETTING AB, VB, SB THEN
        Y.CLABE = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VB>
    END
    FIND 'USUARIO' IN Y.NOMB.PARAMETROS SETTING AC, VC, SC THEN
        Y.USUARIO = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VC>
    END
    FIND 'COD.TRANSACCIONES' IN Y.NOMB.PARAMETROS SETTING AD, VD, SD THEN
        Y.COD.TRANS = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VD>
    END
    FIND 'SUCURSALES' IN Y.NOMB.PARAMETROS SETTING AE, VE, SE THEN
        Y.SUCURSAL = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VE>
    END
    FIND 'TITULOS.1' IN Y.NOMB.PARAMETROS SETTING AF, VF, SF THEN
        Y.TITULOS.1 = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VF>
    END
    FIND 'TITULOS.2' IN Y.NOMB.PARAMETROS SETTING AG, VG, SG THEN
        Y.TITULOS.2 = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VG>
        Y.LINEA= Y.TITULOS.1:Y.TITULOS.2
    END
    FIND 'RUTA.ARCHIVO' IN Y.NOMB.PARAMETROS SETTING AH, VH, SH THEN
        Y.RUTA.ARCHIVO = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VH>
    END
    FIND 'NOMBRE.ARCHIVO' IN Y.NOMB.PARAMETROS SETTING AH, VH, SH THEN
        Y.NOMBRE.ARCHIVO = R.DATOS.GP<AbcTable.AbcGeneralParam.DatoParametro,VH>
    END
RETURN

********
PROCESO:
********
    TODAY   = EB.SystemTables.getToday()
    Y.MES = TODAY[1,6]
*   CALL GET.LAST.DOM(Y.MES,LAST.DATE,LAST.DAY,MONTH.NAME)
    EB.AbcUtil.abcGetLastDom(Y.MES,LAST.DATE,LAST.DAY,MONTH.NAME)
    FECHA.INI = Y.MES:'01'
    FECHA.FIN = LAST.DATE

    Y.CLIENTE = ''
    Y.CUENTA=''
    Y.MONTO=''
    GOSUB LIMPIA.VAR.TT

    Y.NO.COD= DCOUNT(Y.COD.TRANS,",")
    Y.NO.SUC= DCOUNT(Y.SUCURSAL,",")
    FOR LOOP.SUC = 1 TO Y.NO.SUC
        Y.TIPO.OPERACION.AUX=''
        FOR LOOP.COD = 1 TO Y.NO.COD
            Y.SUC=''
            R.CUENTA=''
            Y.ERR.ACC=''
            Y.CATEGORIA=''
            COD.TRANS = FIELD(Y.COD.TRANS,",",LOOP.COD)
            Y.SUC=FIELD(Y.SUCURSAL,",",LOOP.SUC)
            Y.COND.SUC=' AND DEPT.CODE LIKE ':Y.SUC:'...'
            Y.DATA.LOG <-1> = "FECHA.INI=":FECHA.INI
            Y.DATA.LOG <-1> = "FECHA.FIN=":FECHA.FIN
            Y.DATA.LOG <-1> = "COD.TRANS=":COD.TRANS
            AbcRegulatorios.abcOemnSel(FECHA.INI,COD.TRANS,FECHA.FIN,LIST.TT,NO.REG.TT,Y.COND.SUC)
            Y.DATA.LOG <-1> = "LIST.TT=":LIST.TT
            Y.DATA.LOG <-1> = "NO.REG.TT=":NO.REG.TT
            Y.DATA.LOG <-1> = "Y.COND.SUC=":Y.COND.SUC
*CALL ABC.OEMN.SEL(FECHA.INI,COD.TRANS,FECHA.FIN,LIST.TT,NO.REG.TT,Y.COND.SUC)
            GOSUB LIMPIA.ACUMULADOS
            FOR LOOP.TT = 1 TO NO.REG.TT

                Y.ID.TT = LIST.TT<LOOP.TT>
                EB.DataAccess.FRead(FN.TELLER,Y.ID.TT,R.TELLER,F.TELLER,Y.ERR.TELLER)
                IF NOT (R.TELLER) THEN
                    EB.DataAccess.FRead(FN.TELLER.HIS,Y.ID.TT,R.TELLER,F.TELLER.HIS,Y.ERR.TELLER)
                END

                Y.CLIENTE= R.TELLER<TT.Contract.Teller.TeCustomerOne>
                Y.MONTO= R.TELLER<TT.Contract.Teller.TeNetAmount>
                IF Y.CLIENTE EQ '' THEN
                    Y.CLIENTE= R.TELLER<TT.Contract.Teller.TeCustomerTwo>
                    Y.CUENTA=R.TELLER<TT.Contract.Teller.TeAccountTwo>
                END ELSE
                    Y.CUENTA=R.TELLER<TT.Contract.Teller.TeAccountOne>
                END

                IF Y.CLIENTE NE '' THEN
                    EB.DataAccess.FRead(FN.ACC,Y.CUENTA,R.CUENTA,F.ACC,Y.ERR.ACC)
                    IF R.CUENTA THEN
                        Y.CATEGORIA= R.CUENTA<AC.AccountOpening.Account.Category>
                        GOSUB ACUMULA.PRODUCTO
                    END ELSE
                        EB.DataAccess.FRead(FN.ACC.HIS,Y.CUENTA:";1",R.CUENTA,F.ACC.HIS,Y.ERR.ACC)
                        Y.CATEGORIA= R.CUENTA<AC.AccountOpening.Account.Category>
                        GOSUB ACUMULA.PRODUCTO
                    END
                END ELSE
                    IF COD.TRANS EQ '10' OR COD.TRANS EQ '110' THEN
                        COD.TRANS.AUX=''
                        COD.TRANS.AUX= 'PTC'
                        Y.CATEGORIA= 'PTC'
                        GOSUB ACUMULA.PRODUCTO
                        GOSUB TIPO.OPERACION
                    END ELSE

                        Y.CATEGORIA=''
                        Y.CATEGORIA= 'CVE'
                        GOSUB ACUMULA.PRODUCTO
                    END
                END

            NEXT LOOP.TT

            GOSUB TIPO.OPERACION
            GOSUB ARMA.REGISTRO
        NEXT LOOP.COD
    NEXT LOOP.SUC
    GOSUB ARMA.REPORTE.SECC2

RETURN

***************
TIPO.OPERACION:
***************

    Y.TIPO.OPERACION=''

    BEGIN CASE
        CASE COD.TRANS EQ 5
            Y.TIPO.OPERACION = '102'

        CASE COD.TRANS EQ 10
            Y.TIPO.OPERACION = '2'
    END CASE


RETURN

******************
LIMPIA.ACUMULADOS:
******************

    Y.MONTO.0=0
    Y.MONTO.1=0
    Y.MONTO.101=0
    Y.MONTO.7=0
    Y.MONTO.8=0
    Y.MONTO.11=0
    Y.TIPO.0=''
    Y.TIPO.1=''
    Y.TIPO.7=''
    Y.TIPO.8=''
    Y.TIPO.11=''
    Y.TIPO.101=''

    Y.NO.OPERACIONES.0=''
    Y.NO.OPERACIONES.1=''
    Y.NO.OPERACIONES.101=''
    Y.NO.OPERACIONES.7=''
    Y.NO.OPERACIONES.8=''
    Y.NO.OPERACIONES.11=''

RETURN

**************
ARMA.REGISTRO:
**************

    Y.LINEA.DAT = Y.INSTITUCION:Y.SEP:FECHA.FIN
    IF Y.MONTO.1 GT 0 THEN
        IF Y.LINEA NE '' THEN
            Y.LINEA := Y.SEP2
        END
        Y.LINEA := Y.LINEA.DAT:Y.SEP:Y.TIPO.1:Y.SEP:Y.SUC:Y.SEP:Y.CLABE:Y.SEP:Y.NA:Y.SEP:Y.NIVEL.0:Y.SEP:Y.USUARIO:Y.SEP:Y.MONTO.1:Y.SEP:Y.NO.OPERACIONES.1
        Y.LINEA := Y.SEP2
        Y.LINEA := Y.LINEA.DAT:Y.SEP:Y.TIPO.101:Y.SEP:Y.SUC:Y.SEP:Y.CLABE:Y.SEP:Y.NA:Y.SEP:Y.NIVEL.0:Y.SEP:Y.USUARIO:Y.SEP:Y.MONTO.1:Y.SEP:Y.NO.OPERACIONES.1
    END

    IF Y.MONTO.0 GT 0 THEN
        IF Y.LINEA NE '' THEN
            Y.LINEA := Y.SEP2
        END
        Y.LINEA := Y.LINEA.DAT:Y.SEP:Y.TIPO.OPERACION:Y.SEP:Y.SUC:Y.SEP:Y.CLABE:Y.SEP:Y.TIPO.0:Y.SEP:Y.NIVEL:Y.SEP:Y.TIPO.CLIENTE:Y.SEP:Y.MONTO.0:Y.SEP:Y.NO.OPERACIONES.0
    END

    IF Y.MONTO.7 GT 0 THEN
        IF Y.LINEA NE '' THEN
            Y.LINEA := Y.SEP2
        END
        Y.LINEA := Y.LINEA.DAT:Y.SEP:Y.TIPO.OPERACION:Y.SEP:Y.SUC:Y.SEP:Y.CLABE:Y.SEP:Y.TIPO.7:Y.SEP:Y.NIVEL:Y.SEP:Y.TIPO.CLIENTE:Y.SEP:Y.MONTO.7:Y.SEP:Y.NO.OPERACIONES.7
    END
    IF Y.MONTO.8 GT 0 THEN
        IF Y.LINEA NE '' THEN
            Y.LINEA := Y.SEP2
        END
        Y.LINEA := Y.LINEA.DAT:Y.SEP:Y.TIPO.OPERACION:Y.SEP:Y.SUC:Y.SEP:Y.CLABE:Y.SEP:Y.TIPO.8:Y.SEP:Y.NIVEL:Y.SEP:Y.TIPO.CLIENTE:Y.SEP:Y.MONTO.8:Y.SEP:Y.NO.OPERACIONES.8
    END
    IF Y.MONTO.11 GT 0 THEN
        IF COD.TRANS.AUX EQ 'PTC' THEN
            Y.TIPO.OPERACION.AUX = '11'
            IF Y.LINEA NE '' THEN
                Y.LINEA := Y.SEP2
            END
            Y.LINEA := Y.LINEA.DAT:Y.SEP:Y.TIPO.OPERACION.AUX:Y.SEP:Y.SUC:Y.SEP:Y.CLABE:Y.SEP:Y.TIPO.11:Y.SEP:Y.NIVEL.0:Y.SEP:Y.USUARIO:Y.SEP:Y.MONTO.11:Y.SEP:Y.NO.OPERACIONES.11
        END
        IF Y.MONTO.101 GT 0 THEN
            IF Y.LINEA NE '' THEN
                Y.LINEA := Y.SEP2
            END
            Y.LINEA := Y.LINEA.DAT:Y.SEP:Y.TIPO.101:Y.SEP:Y.SUC:Y.SEP:Y.CLABE:Y.SEP:Y.NA:Y.SEP:Y.NIVEL.0:Y.SEP:Y.USUARIO:Y.SEP:Y.MONTO.1:Y.SEP:Y.NO.OPERACIONES.1
        END
    END

RETURN

*****************
ACUMULA.PRODUCTO:
*****************

    BEGIN CASE
        CASE Y.CATEGORIA EQ '6001' OR Y.CATEGORIA EQ '6002'
            Y.MONTO.0 = Y.MONTO.0 + Y.MONTO
            Y.TIPO.0=1
            Y.NO.OPERACIONES.0= Y.NO.OPERACIONES.0 +1
        CASE Y.CATEGORIA EQ '1006'
            Y.MONTO.7 = Y.MONTO.7 + Y.MONTO
            Y.TIPO.7=7
            Y.NO.OPERACIONES.7= Y.NO.OPERACIONES.7 +1
        CASE Y.CATEGORIA EQ '1004'
            Y.MONTO.8 = Y.MONTO.8 + Y.MONTO
            Y.TIPO.8=8
            Y.NO.OPERACIONES.8= Y.NO.OPERACIONES.8 +1
        CASE Y.CATEGORIA EQ 'PTC'
            Y.MONTO.11 = Y.MONTO.11 + Y.MONTO
            Y.TIPO.11=0
            Y.NO.OPERACIONES.11= Y.NO.OPERACIONES.11 +1
        CASE Y.CATEGORIA EQ 'CVE'
            Y.MONTO.1= Y.MONTO.1 + Y.MONTO
            Y.TIPO.1=1
            Y.NO.OPERACIONES.1= Y.NO.OPERACIONES.1 + 1
            Y.MONTO.101=Y.MONTO.101 + Y.MONTO
            Y.TIPO.101=101
            Y.NO.OPERACIONES.101= Y.NO.OPERACIONES.101 +1
    END CASE

RETURN

**************
LIMPIA.VAR.TT:
**************

    LIST.TT=''
    NO.REG.TT=0
    Y.ID.TT=''
    R.TELLER=''
    Y.ERR.TELLER=''

RETURN

*--------------------*
ARMA.REPORTE.SECC2:
*--------------------*

    OPEN '',Y.RUTA.ARCHIVO TO F.ARCHIVO ELSE NULL
    YSTMT.ID = Y.MES:".":Y.NOMBRE.ARCHIVO
    
    WRITE Y.LINEA TO F.ARCHIVO,YSTMT.ID
    Y.DATA.LOG <-1> = "Y.LINEA=":Y.LINEA
    CLOSE F.ARCHIVO

RETURN

*--------------------*
ABRIR.ARCHIVOS:
*--------------------*

    FN.TELLER= 'FBNK.TELLER'
    F.TELLER= ''
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

    FN.TELLER.HIS= 'FBNK.TELLER$HIS'
    F.TELLER.HIS= ''
    EB.DataAccess.Opf(FN.TELLER.HIS,F.TELLER.HIS)

    FN.ACC='F.ACCOUNT'
    F.ACC=''
    EB.DataAccess.Opf(FN.ACC,F.ACC)

    FN.ACC.HIS='F.ACCOUNT$HIS'
    F.ACC.HIS=''
    EB.DataAccess.Opf(FN.ACC.HIS,F.ACC.HIS)

    FN.ABC.GENERAL.PARAM = "F.ABC.GENERAL.PARAM"
    F.ABC.GENERAL.PARAM  = ""
    EB.DataAccess.Opf(FN.ABC.GENERAL.PARAM,F.ABC.GENERAL.PARAM)

RETURN

END

