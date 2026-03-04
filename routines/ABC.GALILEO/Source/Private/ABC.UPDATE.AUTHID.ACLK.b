*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.UPDATE.AUTHID.ACLK
*===============================================================================
* Nombre de Programa : ABC.UPDATE.AUTHID.ACLK
* Objetivo           : Auth Rtn para crear el registro de AUTH.ID-ACLK ID en la tabla
*                      concat ABC.CONCAT.GALILEO para el proyecto GALILEO
*===============================================================================

    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.SystemTables
    $USING AbcTable
    $USING AC.AccountOpening

    GOSUB INICIALIZA
    GOSUB UPDATE.CONCAT
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.ABC.GAL.AUTHID.ACLK = 'F.ABC.CONCAT.GALILEO'
    F.ABC.GAL.AUTHID.ACLK  = ''
    EB.DataAccess.Opf(FN.ABC.GAL.AUTHID.ACLK, F.ABC.GAL.AUTHID.ACLK)

    EB.LocalReferences.GetLocRef('AC.LOCKED.EVENTS', 'AUTH.ID', POS.AUTH.ID)

    RETURN
*---------------------------------------------------------------
UPDATE.CONCAT:
*---------------------------------------------------------------

    Y.AUTH.ID = ''
    Y.ACLK.ID = ''
    Y.FECHA   = ''
    REG.AUTH  = ''

    Y.AUTH.ID = EB.SystemTables.getRNew(AC.AccountOpening.LockedEvents.LckLocalRef)<1, POS.AUTH.ID>
    Y.ACLK.ID = EB.SystemTables.getIdNew()
    Y.FECHA   = OCONV(DATE(), 'DY4') : FMT(OCONV(DATE(), "DM"), "2'0'R") : FMT(OCONV(DATE(), "DD"), "2'0'R")

    REC.AUTH<AbcTable.AbcConcatGalile.AclkId> = Y.ACLK.ID
    REC.AUTH<AbcTable.AbcConcatGalile.Fecha> = Y.FECHA
    REC.AUTH<AbcTable.AbcConcatGalile.Estatus> = "PENDIENTE"

    IF Y.AUTH.ID NE '' THEN
        EB.DataAccess.FWrite(FN.ABC.GAL.AUTHID.ACLK,Y.AUTH.ID,REC.AUTH)
    END

    RETURN
