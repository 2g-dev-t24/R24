$PACKAGE AbcBi
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.CTA.DES.VAL.IMP.CTA
*---------------------------------------------------------------------------------------
* Descripcion    : Rutina para llenar la tabla que sirve para impresion de Altas y
*                  modificaciones de cuentas destino.
*---------------------------------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AbcTable
    
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*********************************************
INIT:
*********************************************

    FN.ABC.CUENTAS.DESTINO = "F.ABC.CUENTAS.DESTINO"
    F.ABC.CUENTAS.DESTINO = ""
    EB.DataAccess.Opf(FN.ABC.CUENTAS.DESTINO,F.ABC.CUENTAS.DESTINO)

    FN.BAN.INT.IMP = "F.ABC.BANC.INT.IMP"
    F.BAN.INT.IMP = ""
    EB.DataAccess.Opf(FN.BAN.INT.IMP,F.BAN.INT.IMP)

    Y.EST.CONT = ''
    Y.EST.IMP.CONT = ''
    Y.ID.CTE = ''
    Y.TIPO.CUENTA = ''
    Y.ARR.CTAS = ''
    Y.TIP.MOD = ''

    Y.TIP.ALTA = 'A'
    Y.TIP.MODIF = 'M'
    Y.TIP.BAJA = 'B'
    REC.BAN.INT.IMP = ''

    ID.NEW = EB.SystemTables.getIdNew()
    ID.OLD = EB.SystemTables.getIdOld()

    RETURN
*********************************************
PROCESS:
*********************************************
    TODAY = EB.SystemTables.getToday()
    Y.ID.CTE = FIELD(ID.NEW,'.',1):'.':TODAY
    Y.TIPO.CUENTA =  EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.TipoCta)
    Y.CTA.ID = FIELD(ID.NEW,'.',2)

    IF ID.OLD NE '' THEN
        IF EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.RecordStatus) EQ "RNAU" THEN
            Y.TIP.MOD = Y.TIP.BAJA
            GOSUB BUSCA.CTA
        END ELSE
            Y.TIP.MOD = Y.TIP.MODIF
        END

        IF EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Alias) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Alias) THEN
            GOSUB BUSCA.CTA
        END
        IF EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Beneficiario) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Beneficiario) THEN
            GOSUB BUSCA.CTA
        END
        IF EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Email) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Email) THEN
            GOSUB BUSCA.CTA
        END
        IF EB.SystemTables.getROld(AbcTable.AbcCuentasDestino.Movil) NE EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Movil) THEN
            GOSUB BUSCA.CTA
        END

    END ELSE

        Y.TIP.MOD = Y.TIP.ALTA
        Y.ARR.CTAS<-1> = Y.CTA.ID

    END


    IF Y.ARR.CTAS NE '' THEN
        EB.DataAccess.FRead(FN.BAN.INT.IMP, Y.ID.CTE, REC.BAN.INT.IMP, F.BAN.INT.IMP, Y.ERR.BAN)
        Y.EST.CONT = REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.EstCont>
        Y.EST.IMP.CONT = REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.EstImpCont>

        GOSUB ARMA.REGISTRO

        EB.DataAccess.FWrite(FN.BAN.INT.IMP,Y.ID.CTE,REC.BAN.INT.IMP)
    END

*
    RETURN

*--------------
ARMA.REGISTRO:
*--------------
    REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.EstCont> = Y.EST.CONT
    REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.EstImpCont> = Y.EST.IMP.CONT



    FOR YNO = 1 TO DCOUNT(Y.ARR.CTAS,@FM)
        ID.CTA = FIELD(Y.ARR.CTAS,@FM,YNO)
        FIND ID.CTA IN REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.IdCta> SETTING Ap, Vp THEN
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.IdCta, Vp> = ID.CTA
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.TipoCta, Vp> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.TipoCta)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Banco, Vp> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Banco)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Status, Vp> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Status)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Alias, Vp> =  EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Alias)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Beneficiario, Vp> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Beneficiario)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Rfc, Vp> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Rfc)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Email, Vp> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Email)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Movil, Vp> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Movil)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.TipMod, Vp> = Y.TIP.MOD

        END ELSE
            MAX.CTA = DCOUNT(REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.IdCta>,@VM)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.IdCta, MAX.CTA + 1> = ID.CTA
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.TipoCta, MAX.CTA + 1> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.TipoCta)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Banco, MAX.CTA + 1> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Banco)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Status, MAX.CTA + 1> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Status)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Alias, MAX.CTA + 1> =  EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Alias)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Beneficiario, MAX.CTA + 1> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Beneficiario)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Rfc, MAX.CTA + 1> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Rfc)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Email, MAX.CTA + 1> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Email)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.Movil, MAX.CTA + 1> = EB.SystemTables.getRNew(AbcTable.AbcCuentasDestino.Movil)
            REC.BAN.INT.IMP<AbcTable.AbcBancIntImp.TipMod, MAX.CTA + 1> = Y.TIP.MOD
        END
    NEXT YNO

*
    RETURN

*----------
BUSCA.CTA:
*----------
    FIND Y.CTA.ID IN Y.ARR.CTAS SETTING Ap, Vp ELSE
        Y.ARR.CTAS = Y.CTA.ID
    END
    RETURN

END
