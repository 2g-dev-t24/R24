* @ValidationCode : MjotNjYzOTQ3ODIwOkNwMTI1MjoxNzYwMzk3NTY3MDEwOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Oct 2025 20:19:27
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
$PACKAGE AbcCob

SUBROUTINE ABC.CARGA.DET.CTA.BEN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.Service
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING ST.Config
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB FINALLY

RETURN


*---------------
INITIALISE:
*---------------

    Y.SEP = ','
    SEP.TAB = CHAR(9)




    Y.ID.PARAM = 'ABC.CARGA.DET.CLI.CTA.BEN'
    Y.LIST.PARAMS = '' ; Y.LIST.VALUES = ''
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    
    LOCATE "RUTA.CARGA.DETALLE.CLI.CTA.BEN" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "FILE.NAME" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME = Y.LIST.VALUES<YPOS.PARAM>
    END
    
    LOCATE "RUTA.IPAB.CARGA" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.RUTA.IPAB.CARGA = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "FILE.NAME.CLIENTE" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME.CLIENTE = Y.LIST.VALUES<YPOS.PARAM>
    END
    LOCATE "RUTA.IPAB" IN Y.LIST.PARAMS SETTING YPOS.PARAM THEN
        Y.FILE.NAME.CLIENTE.MV = Y.LIST.VALUES<YPOS.PARAM>
    END



    FECHA.FILE = FMT(OCONV(DATE(), "DD"),"2'0'R"):".":FMT(OCONV(DATE(), "DM"),"2'0'R"):".":OCONV(DATE(), "DY4")
    str_filename = Y.FILE.NAME:"." : FECHA.FILE : ".log"
    SEQ.FILE.NAME = Y.RUTA

    OPENSEQ SEQ.FILE.NAME,str_filename TO FILE.VAR1 ELSE
        CREATE FILE.VAR1 ELSE
        END
    END

    Y.FILE.PATH    = Y.RUTA.IPAB.CARGA
    Y.FILE.NAME    = Y.FILE.NAME.CLIENTE
    Y.FILE.PATHMV    = Y.FILE.NAME.CLIENTE.MV

RETURN

*---------------
OPENFILES:
*---------------

    FN.ABC.IPAB.CTA.BEN = 'F.ABC.IPAB.CTA.BEN'
    F.ABC.IPAB.CTA.BEN = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.CTA.BEN,F.ABC.IPAB.CTA.BEN)

    FN.ABC.IPAB.CLI.CTA.BEN = 'F.ABC.IPAB.CLI.CTA.BEN'
    F.ABC.IPAB.CLI.CTA.BEN = ''
    EB.DataAccess.Opf(FN.ABC.IPAB.CLI.CTA.BEN,F.ABC.IPAB.CLI.CTA.BEN)

RETURN


*---------------
LIMPIA.VARIABLES:
*---------------

    Y.CLIENTE = ''
    Y.CLI.PERSONALIDAD = ''
    Y.CUENTA = ''
    Y.CTA.SALDO.CUENTA = ''
    Y.CTA.INTERESES = 0
    Y.CTA.RETENCION.IMPUESTO = 0
    Y.CTA.SALDO.NETO = ''
    Y.CTA.FECHA.CORTE = ''
    Y.CTA.TASA = ''
    Y.CTA.SALDO.PROMEDIO = ''

RETURN


*---------------
PROCESS:
*---------------

    EB.Service.ClearFile(FN.ABC.IPAB.CTA.BEN, F.ABC.IPAB.CTA.BEN)
    EB.Service.ClearFile(FN.ABC.IPAB.CLI.CTA.BEN, F.ABC.IPAB.CLI.CTA.BEN)

    OPENSEQ Y.FILE.PATH,Y.FILE.NAME TO Y.PUNTERO THEN
        MENSAJE = "***********************************************************"
        GOSUB BITACORA
        MENSAJE = "INICIO"
        GOSUB BITACORA
        MENSAJE = "***********************************************************"
        GOSUB BITACORA
        LOOP
        WHILE NOT(EOF) DO
            READSEQ REC.LINE FROM Y.PUNTERO THEN
                GOSUB LIMPIA.VARIABLES
                Y.COUNT += 1
                Y.CUENTA = FIELD(REC.LINE,Y.SEP,1)
                IF ISDIGIT(Y.CUENTA) AND Y.CUENTA.AUX NE Y.CUENTA THEN
                    Y.CUENTA = FMT(Y.CUENTA,"11'0'R")
                    Y.CLIENTE = FIELD(REC.LINE,Y.SEP,2)
                    Y.CLI.PERSONALIDAD = FIELD(REC.LINE,Y.SEP,15)
                    Y.CTA.SALDO.CUENTA = FIELD(REC.LINE,Y.SEP,7)
                    Y.CTA.SALDO.NETO = FIELD(REC.LINE,Y.SEP,5)
                    Y.CTA.FECHA.CORTE = FIELD(REC.LINE,Y.SEP,12)
                    Y.CTA.TASA = FIELD(REC.LINE,Y.SEP,10)
                    Y.CTA.SALDO.PROMEDIO = FIELD(REC.LINE,Y.SEP,8)

                    IF Y.CLI.PERSONALIDAD EQ 'PERSONA MORAL' THEN
                        Y.CLI.PERSONALIDAD = 'M'
                    END ELSE
                        Y.CLI.PERSONALIDAD = 'F'
                    END

                    IF Y.CLIENTE.AUX EQ Y.CLIENTE THEN
                        Y.CLI.SALDO.COMPENSADO += Y.CTA.SALDO.CUENTA
                    END ELSE
                        Y.CLI.SALDO.COMPENSADO = Y.CTA.SALDO.CUENTA
                    END

                    GOSUB ARMA.REG.CLIENTE
                    GOSUB ARMA.REG.CUENTA

                    Y.CLIENTE.AUX = Y.CLIENTE
                    Y.CUENTA.AUX = Y.CUENTA
                END
            END ELSE
                EOF = 1
            END
        REPEAT
    END

RETURN

*****************
ARMA.REG.CLIENTE:
*****************

    REC.CLI.CTA.BEN = ''
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.Personalidad> = Y.CLI.PERSONALIDAD
    REC.CLI.CTA.BEN<AbcTable.AbcIpabCliCtaBen.SaldoCompensado> = Y.CLI.SALDO.COMPENSADO

    WRITE REC.CLI.CTA.BEN TO F.ABC.IPAB.CLI.CTA.BEN, Y.CLIENTE

RETURN

****************
ARMA.REG.CUENTA:
****************

    REC.CTA.BEN = ''
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.Cliente> = Y.CLIENTE
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.SaldoCuenta> = Y.CTA.SALDO.CUENTA
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.Intereses> = Y.CTA.INTERESES
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.RetencionImpuestos> = Y.CTA.RETENCION.IMPUESTO
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.SaldoNeto> = Y.CTA.SALDO.NETO
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.FechaCorte> = Y.CTA.FECHA.CORTE
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.Tasa> = Y.CTA.TASA
    REC.CTA.BEN<AbcTable.AbcIpabCtaBen.SaldoPromedio> = Y.CTA.SALDO.PROMEDIO

    WRITE REC.CTA.BEN TO F.ABC.IPAB.CTA.BEN, Y.CUENTA

RETURN

*********
BITACORA:
*********

    WRITESEQ TIMEDATE():" ":MENSAJE APPEND TO FILE.VAR1 ELSE
    END
    MENSAJE = ''
RETURN

********
FINALLY:
********

    EXECUTE "mv ":Y.FILE.PATH:Y.FILE.NAME:" ":Y.FILE.PATHMV:"Cuenta_Global_IPAB_2019.":FECHA.FILE:".":TIMEDATE()[1,2]:TIMEDATE()[4,2]:TIMEDATE()[7,2]:".csv" CAPTURING Y.RESPONSE.MV
    IF Y.RESPONSE.MV THEN
        MENSAJE = "RESPUESTA DE MOVIMIENTO: ":Y.RESPONSE.MV
        DISPLAY MENSAJE
        GOSUB BITACORA
    END

RETURN

END

