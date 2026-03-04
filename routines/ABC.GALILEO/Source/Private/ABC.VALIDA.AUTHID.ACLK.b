*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.VALIDA.AUTHID.ACLK
*===============================================================================
* Nombre de Programa : ABC.VALIDA.AUTHID.ACLK
* Objetivo           : Validation Rtn para validar que no exista previamente el AUTH.ID en
*                      concat ABC.CONCAT.GALILEO para el proyecto GALILEO
*===============================================================================

    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.SystemTables
    $USING AbcTable
    $USING EB.ErrorProcessing

    GOSUB INICIALIZA
    GOSUB VALIDA.AUTH.ID

    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.ABC.CONCAT.GALILEO = 'F.ABC.CONCAT.GALILEO'
    F.ABC.CONCAT.GALILEO  = ''
    EB.DataAccess.Opf(FN.ABC.CONCAT.GALILEO, F.ABC.CONCAT.GALILEO)

    EB.LocalReferences.GetLocRef('AC.LOCKED.EVENTS', 'AUTH.ID', POS.AUTH.ID)

    Y.AUTH.ID = ''
    Y.ACLK.CONCAT = ''
    Y.ACLK.NUEVO = ''
    Y.STAT.CONCAT = ''
    REG.AUTH  = ''

    RETURN
*---------------------------------------------------------------
VALIDA.AUTH.ID:
*---------------------------------------------------------------

    Y.AUTH.ID = EB.SystemTables.getComi()
    Y.ACLK.NUEVO = EB.SystemTables.getIdNew()

    EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, Y.AUTH.ID, REG.AUTH, F.ABC.CONCAT.GALILEO, Y.ERR.CONGAL)
    IF REG.AUTH THEN
        Y.ACLK.CONCAT = REG.AUTH<AbcTable.AbcConcatGalile.AclkId>
        Y.STAT.CONCAT = REG.AUTH<AbcTable.AbcConcatGalile.Estatus>
        IF Y.ACLK.NUEVO NE Y.ACLK.CONCAT THEN
            ETEXT = "AUTH.ID YA EXISTE CON ESTATUS: " : Y.STAT.CONCAT
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END
    END

    RETURN
