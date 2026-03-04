* @ValidationCode : MjotMTIyMTMwNDgzMDpDcDEyNTI6MTc2MTQwMTUwOTcyNjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2025 11:11:49
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

SUBROUTINE ABC.UPDATE.CONCAT.EXT.TRANS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Nombre de Programa : ABC.UPDATE.CONCAT.EXT.TRANS
* Compania           : Uala
* Req. Jira          : ABCCORE-3693 Registro del dato EXT.TRANS.ID
* Objetivo           : Actualización de registros en ABC.AA.L.PRE.PRO con IDs de
*                      AA.ARRANGEMENT.ACTIVITY y AA.ARRANGEMENT
* Desarrollador      : Luis Cruz - FyG Solutions
* Fecha Creacion     : 2025-02-12
* Modificaciones:
*===============================================================================
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING EB.Updates
    $USING AbcTable

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------

    FN.ABC.AA.CONCAT.PRE = 'F.ABC.AA.L.PRE.PRO'
    F.ABC.AA.CONCAT.PRE = ''
    EB.DataAccess.Opf(FN.ABC.AA.CONCAT.PRE, F.ABC.AA.CONCAT.PRE)

    EB.Updates.MultiGetLocRef("ABC.AA.PRE.PROCESS", "EXT.TRANS.ID", Y.POS.EXT.TRANS.ID)

    Y.EXT.TRANS.ID = ''
    Y.ID.ABC.AA.PAGARE = ''
    Y.STATUS.ABC.PAGARE = ''
    Y.ID.AA.ARRANGEMENT = ''
    Y.STATUS.AA.ARR = ''
    Y.ID.ARR.ACT = ''
    Y.STATUS.ARR.ACT = ''
    Y.FECHA.FIN.PAGARE = ''

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    Y.ID.ABC.AA.PAGARE = EB.SystemTables.getIdNew()
    Y.EXT.TRANS.ID = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.LocalRef)<1, Y.POS.EXT.TRANS.ID>

    REC.EXT.TRANS.ID = ''
    EB.DataAccess.FRead(FN.ABC.AA.CONCAT.PRE, Y.EXT.TRANS.ID, REC.EXT.TRANS.ID, F.ABC.AA.CONCAT.PRE, CONCAT.ERR)

    Y.STATUS.ABC.PAGARE = 'AUTH'
    Y.ID.AA.ARRANGEMENT = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.ArrangementId)
    Y.STATUS.AA.ARR = 'OK'
    Y.ID.ARR.ACT = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.ActRefId)
    Y.STATUS.ARR.ACT = 'OK'
    Y.FECHA.FIN.PAGARE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
    IF Y.EXT.TRANS.ID NE '' THEN
        GOSUB UPDATE.RECORD.CONCAT
    END


RETURN
*-----------------------------------------------------------------------------
UPDATE.RECORD.CONCAT:
*-----------------------------------------------------------------------------

    REC.EXT.TRANS.ID<AbcTable.AbcAaLPrePro.StatusPreProcess>     = Y.STATUS.ABC.PAGARE
    REC.EXT.TRANS.ID<AbcTable.AbcAaLPrePro.IdAaArrangement>      = Y.ID.AA.ARRANGEMENT
    REC.EXT.TRANS.ID<AbcTable.AbcAaLPrePro.StatusAaArr>          = Y.STATUS.AA.ARR
    REC.EXT.TRANS.ID<AbcTable.AbcAaLPrePro.IdArrangementAct>     = Y.ID.ARR.ACT
    REC.EXT.TRANS.ID<AbcTable.AbcAaLPrePro.StatusArrAct>         = Y.STATUS.ARR.ACT
    REC.EXT.TRANS.ID<AbcTable.AbcAaLPrePro.FechaFinPrePro>       = Y.FECHA.FIN.PAGARE

*    WRITE REC.EXT.TRANS.ID TO F.ABC.AA.CONCAT.PRE, Y.EXT.TRANS.ID
    EB.DataAccess.FWrite(FN.ABC.AA.CONCAT.PRE,Y.EXT.TRANS.ID,REC.EXT.TRANS.ID)
RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------


RETURN
END
*-----------------------------------------------------------------------------

