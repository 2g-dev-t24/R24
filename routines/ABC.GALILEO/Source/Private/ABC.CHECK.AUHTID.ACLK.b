*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcGalileo
    SUBROUTINE ABC.CHECK.AUHTID.ACLK
*===============================================================================
* Nombre de Programa : ABC.CHECK.AUHTID.ACLK
* Objetivo           : ID RTN que busca el AUTH.ID recibido y lo cambia por el ID
*                      del bloqueo ACLK de compra
*===============================================================================

    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING AbcTable


    GOSUB INICIALIZA
    GOSUB CHECK.ID

    IF Y.SE.ENCONTRO EQ '' THEN
        ETEXT = Y.MSG.ERROR
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.ABC.CONCAT.GALILEO = 'F.ABC.CONCAT.GALILEO'
    F.ABC.CONCAT.GALILEO = ''
    EB.DataAccess.Opf(FN.ABC.CONCAT.GALILEO, F.ABC.CONCAT.GALILEO)

    FN.ACLK = 'F.AC.LOCKED.EVENTS'
    F.ACLK = ''
    EB.DataAccess.Opf(FN.ACLK, F.ACLK)

    Y.ID.COMPRA   = ''
    Y.ID.COMPRA = EB.SystemTables.getComi()
    Y.MSG.ERROR = "COMPRA NO ENCONTRADA PARA: " : Y.ID.COMPRA

    RETURN
*---------------------------------------------------------------
CHECK.ID:
*---------------------------------------------------------------

    Y.SE.ENCONTRO = ''

    EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, Y.ID.COMPRA, REC.AUTHID, F.ABC.CONCAT.GALILEO, ERR.READ)
    IF REC.AUTHID THEN
        IF REC.AUTHID<AbcTable.AbcConcatGalile.AclkId> NE '' THEN
            EB.SystemTables.setComi(REC.AUTHID<AbcTable.AbcConcatGalile.AclkId>)
            Y.ID.COMPRA = EB.SystemTables.getComi()
            Y.SE.ENCONTRO = 1
        END
    END

    IF Y.ID.COMPRA[1,4] EQ 'ACLK' THEN
        EB.DataAccess.FRead(FN.ACLK, Y.ID.COMPRA, REC.ACLK, F.ACLK, ERR.READ)
        IF REC.ACLK THEN
            Y.SE.ENCONTRO = 1
            RETURN
        END ELSE
            Y.MSG.ERROR = "COMPRA: ": Y.ID.COMPRA :" YA APLICADA"
            Y.SE.ENCONTRO = ''
        END
    END

    RETURN

