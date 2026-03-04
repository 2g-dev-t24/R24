*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.REVERSA.AUTH.ID
*===============================================================================
* Descripción:          Rutina que lee el AUTH.ID recibido en ORIG.AUTH.ID y lo
* reversa mediante OFS.POST.MESSAGE
*===============================================================================

    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING AbcGetGeneralParam
    $USING EB.SystemTables
    $USING EB.Interface
    $USING AbcTable
    $USING AC.AccountOpening

    GOSUB INICIO
    IF Y.ORIG.AUTH.ID NE '' THEN
        GOSUB PROCESO
        GOSUB FINAL
    END

    RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    FN.ABC.CONCAT.GALILEO = 'F.ABC.CONCAT.GALILEO'
    F.ABC.CONCAT.GALILEO  = ''
    EB.DataAccess.Opf(FN.ABC.CONCAT.GALILEO, F.ABC.CONCAT.GALILEO)

    EB.LocalReferences.GetLocRef("AC.LOCKED.EVENTS", "ORIG.AUTH.ID", YPOS.ORIG.AUTH.ID)

    Y.USR = ''
    Y.PWD = ''
    Y.OFS.SOURCE = ''
    Y.NOMB.PARAM = ''
    Y.DATA.PARAM = ''
    Y.ID.COM.PARAM = 'ABC.REV.AUTH.ID.PARAM'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.COM.PARAM, Y.NOMB.PARAM, Y.DATA.PARAM)

    LOCATE "USUARIO.OFS" IN Y.NOMB.PARAM SETTING POS THEN
        Y.USR = Y.DATA.PARAM<POS>
    END

    LOCATE "PASSWORD.OFS" IN Y.NOMB.PARAM SETTING POS THEN
        Y.PWD = Y.DATA.PARAM<POS>
    END

    LOCATE "OFS.SOURCE" IN Y.NOMB.PARAM SETTING POS THEN
        Y.OFS.SOURCE = Y.DATA.PARAM<POS>
    END

    Y.ORIG.AUTH.ID = ''
    Y.ORIG.AUTH.ID = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)<1, YPOS.ORIG.AUTH.ID>

    RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    GOSUB OBTEN.ORIG.ACLK.ID
    IF Y.ORIG.ACLK.ID NE '' THEN
        OFS.MSG.ID = ''
        Y.OFS.OPTIONS = ''
        Y.OFS.MSG  = "AC.LOCKED.EVENTS,/R/PROCESS//0,"
        Y.OFS.MSG := Y.USR : "/" : Y.PWD : "," : Y.ORIG.ACLK.ID
        EB.Interface.OfsPostMessage(Y.OFS.MSG, OFS.MSG.ID, Y.OFS.SOURCE, Y.OFS.OPTIONS)
        PRINT OFS.MSG.ID
    END

    RETURN

*-----------------------------------------------------------------------------
OBTEN.ORIG.ACLK.ID:
*-----------------------------------------------------------------------------

    REC.AUTHID = ''
    Y.ORIG.ACLK.ID = ''
    EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, Y.ORIG.AUTH.ID, REC.AUTHID, F.ABC.CONCAT.GALILEO, Y.ERR.GALI)
    IF REC.AUTHID THEN
        Y.ORIG.ACLK.ID = REC.AUTHID<AbcTable.AbcConcatGalile.AclkId>
    END

    RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


    RETURN
END
*-----------------------------------------------------------------------------
