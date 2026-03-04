* @ValidationCode : MjotNzU5NTM1NjY0OkNwMTI1MjoxNzU1MDIwOTA0NjYyOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Aug 2025 14:48:24
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

SUBROUTINE ABC.VALIDA.CUST.IUB.N4
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING EB.ErrorProcessing

    $USING AbcTable
    $USING ABC.BP
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.ABC.BIOMETRICOS = 'F.ABC.BIOMETRICOS'
    F.ABC.BIOMETRICOS = ''
    EB.DataAccess.Opf(FN.ABC.BIOMETRICOS, F.ABC.BIOMETRICOS)

    Y.NIVEL.CTA = ''
    Y.ID.CUST = ''
    Y.IUB.CUS = ''
    Y.BIO.LAT = ''
    Y.BIO.LON = ''
    R.CUSTOMER = ''

*LEEMOS EL CAMPO CUSTOMER
    Y.NIVEL.CTA = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Nivel)
    Y.ID.CUST = EB.SystemTables.getRNew(AbcTable.AbcAcctLclFlds.Customer)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF (Y.NIVEL.CTA NE 'NIVEL.1') AND (Y.NIVEL.CTA NE 'NIVEL.2') THEN
        IF Y.ID.CUST THEN
            ABC.BP.AbcValidaClienteEnrol(Y.ID.CUST, Y.ESTATUS)
            IF Y.ESTATUS NE '' THEN
                IF Y.ESTATUS MATCHES "ENCONTRADO" THEN
                    Y.IUB.CUS = FIELD(Y.ID.CUST, @FM, 2)
                    GOSUB LEE.BIOMETRICO
                    GOSUB LLENA.LAT.LON
                    RETURN
                END ELSE
                    EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
                    EB.SystemTables.setAv(0)
                    E = Y.ESTATUS
                    EB.SystemTables.setE(E)
                    EB.ErrorProcessing.Err()
                END
            END
        END
    END
    
RETURN
*---------------------------------------------------------------
LEE.BIOMETRICO:
*---------------------------------------------------------------
*SI CUSTOMER TIENE REGISTRADO UN IUB LEEMOS EL REGISTRO PARA OBTENER DATOS DE LATITUD Y LONGITUD
    EB.DataAccess.FRead(FN.ABC.BIOMETRICOS, Y.IUB.CUS, R.IUB.BIOM, F.ABC.BIOMETRICOS, ERR.BIOM)
    IF R.IUB.BIOM THEN
        Y.BIO.LAT = R.IUB.BIOM<ABC.BP.AbcBiometricos.AbcBiomLatitud>
        Y.BIO.LON = R.IUB.BIOM<ABC.BP.AbcBiometricos.AbcBiomLongitud>
    END ELSE
        EB.SystemTables.setAf(AbcTable.AbcAcctLclFlds.Customer)
        EB.SystemTables.setAv(0)
        EB.SystemTables.setAs(0)
        E = "REGISTRO DE BIOMETRICOS NO ENCONTRADO"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
    END

RETURN
*---------------------------------------------------------------
LLENA.LAT.LON:
*---------------------------------------------------------------
*LLENAMOS LOS DATOS DE LATITUD Y LONGITUD EN CAMPO GEOLOCALIZACION DE ACCOUNT
    IF Y.BIO.LAT AND Y.BIO.LON THEN
        Y.VAL.GEO = Y.BIO.LAT : "," : Y.BIO.LON
        EB.SystemTables.setRNew(AbcTable.AbcAcctLclFlds.Geolocalizacion, Y.VAL.GEO)
    END

RETURN
*-----------------------------------------------------------------------------
END