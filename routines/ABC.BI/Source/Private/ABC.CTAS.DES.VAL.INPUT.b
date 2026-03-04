$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.CTAS.DES.VAL.INPUT
*-----------------------------------------------------------------------------
* Descripcion : INPUT ROUTINE para marcar de donde proviene el registro,
*               si es un Alta, modificacion o baja
*-----------------------------------------------------------------------------
 
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.ErrorProcessing
    $USING EB.Versions

    FN.ABC.CUENTAS.DESTINO = "F.ABC.CUENTAS.DESTINO"
    F.ABC.CUENTAS.DESTINO = ""
    EB.DataAccess.Opf(FN.ABC.CUENTAS.DESTINO,F.ABC.CUENTAS.DESTINO)

    FN.VERSION = "F.VERSION"
    F.VERSION = ""
    EB.DataAccess.Opf(FN.VERSION,F.VERSION)

    Y.ABC.CTAS.DES.REC = ''
    Y.REC = ''
    Y.ID = EB.SystemTables.getIdNew()
    Y.FUNC = EB.SystemTables.getVFunction()
    APPLICATION = EB.SystemTables.getApplication()
    PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.APP = APPLICATION:PGM.VERSION
    Y.REC.APP = ''
    Y.ERR = ''
    Y.TIP.OPE = ''
    
    EB.DataAccess.FRead(FN.ABC.CUENTAS.DESTINO, ID.NEW, Y.ABC.CTAS.DES.REC, F.ABC.CUENTAS.DESTINO, Y.ERR.ABC.CUENTAS.DESTINO)

    IF Y.ABC.CTAS.DES.REC EQ '' THEN
        Y.TIP.OPE = 'ALT'
    END ELSE
        IF Y.FUNC EQ 'R' THEN
            Y.TIP.OPE = 'BAJ'
        END ELSE
            IF Y.FUNC EQ 'A' AND EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.RecordStatus) EQ "RNAU" THEN
                Y.TIP.OPE = 'BAJ'
            END ELSE

                Y.TIP.OPE = 'ACT'
            END
        END
    END


    EB.DataAccess.FRead(FN.VERSION, Y.APP, Y.REC.APP, F.VERSION, Y.ERR.VERSION)
    IF Y.REC.APP EQ '' THEN
        ETEXT = 'LA VERSION NO EXISTE'
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END

    BEGIN CASE
    CASE Y.FUNC MATCHES 'I':@VM:'R':@VM:''
        IF EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.TipVersion) NE '' AND (EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.TipVersion) NE Y.TIP.OPE) THEN
            E = 'EL REGISTRO HA SIDO MODIFICADO POR OTRA PANTALLA, PRIMERO AUTORICE'
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END ELSE

            IF Y.REC.APP<EB.Versions.Version.VerNoOfAuth> EQ 0 THEN
                EB.SystemTables.setRNew(AbcTable.AbcCuentasDestino.TipVersion, '')
            END ELSE
                EB.SystemTables.setRNew(AbcTable.AbcCuentasDestino.TipVersion, Y.TIP.OPE)
            END
        END

    CASE Y.FUNC EQ 'A'
        IF Y.TIP.OPE NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.TipVersion) THEN
            E = 'NO SE PUEDE AUTORIZAR LA OPERACION DE OTRA PANTALLA'
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()
        END ELSE
            EB.SystemTables.setRNew(AbcTable.AbcCuentasDestino.TipVersion, '')
        END

    END CASE


    RETURN
END
