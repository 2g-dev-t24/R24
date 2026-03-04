* @ValidationCode : Mjo2NTc2MDcxODpDcDEyNTI6MTc2MDM3NzU5MTQyMjpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Oct 2025 14:46:31
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
$PACKAGE AbcAccount

SUBROUTINE ABC.INPUT.EXT.TRANSID.PAG
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING AbcGetGeneralParam
    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------

    Y.MESSAGE = EB.SystemTables.getMessage()
    IF Y.MESSAGE EQ "VAL" THEN RETURN
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

    Y.FUNCTION          = ''
    Y.VERSION.PAGARE    = ''
    Y.EXT.TRANS.ID      = ''
    Y.ID.ABC.AA.PAGARE  = ''
    Y.STATUS.ABC.PAGARE = ''
    Y.FECHA.INIC.PAGARE = ''
    Y.FECHA.FIN.PAGARE  = ''
    Y.ID.AA.ARRANGEMENT = ''
    Y.STATUS.AA.ARR     = ''
    Y.ID.ARR.ACT        = ''
    Y.STATUS.ARR.ACT    = ''

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------

    Y.VERSION.PAGARE    = EB.SystemTables.getPgmVersion()
    Y.FUNCTION          = EB.SystemTables.getVFunction()
    Y.ID.ABC.AA.PAGARE  = EB.SystemTables.getIdNew()
    Y.EXT.TRANS.ID      = EB.SystemTables.getComi()

    REC.EXT.TRANS.ID = ''
    EB.DataAccess.FRead(FN.ABC.AA.CONCAT.PRE, Y.EXT.TRANS.ID, REC.EXT.TRANS.ID, F.ABC.AA.CONCAT.PRE, CONCAT.ERR)
    
    
    BEGIN CASE
        CASE Y.VERSION.PAGARE EQ ',PRO' AND Y.FUNCTION EQ 'I'
            IF REC.EXT.TRANS.ID NE '' THEN
                ETEXT = "EXT TRANS ID: " : Y.EXT.TRANS.ID : " YA REGISTRADO EN OTRA INVERSION"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END ELSE
                Y.FECHA.INIC.PAGARE = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.EffectiveDate)
                Y.FECHA.FIN.PAGARE  = EB.SystemTables.getRNew(AbcTable.AbcAaPreProcess.MatDate)
                Y.STATUS.ABC.PAGARE = 'INAU'
                IF Y.EXT.TRANS.ID NE '' THEN
                    GOSUB INPUT.RECORD.CONCAT
                END
            END

        CASE Y.VERSION.PAGARE EQ ',PRO' AND Y.FUNCTION EQ 'D'
            RETURN
    END CASE

RETURN
*-----------------------------------------------------------------------------
INPUT.RECORD.CONCAT:
*-----------------------------------------------------------------------------
    REC.CONCAT.PAGARE = ''
    REC.CONCAT.PAGARE<AbcTable.AbcAaLPrePro.IdAaPreProcess>     = Y.ID.ABC.AA.PAGARE
    REC.CONCAT.PAGARE<AbcTable.AbcAaLPrePro.FechaInicPrepro>    = Y.FECHA.INIC.PAGARE
    REC.CONCAT.PAGARE<AbcTable.AbcAaLPrePro.FechaFinPrePro>     = Y.FECHA.FIN.PAGARE
    REC.CONCAT.PAGARE<AbcTable.AbcAaLPrePro.StatusPreProcess>   = Y.STATUS.ABC.PAGARE

    EB.DataAccess.FWrite(FN.ABC.AA.CONCAT.PRE,Y.EXT.TRANS.ID,REC.CONCAT.PAGARE)
    
RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------

RETURN
END
*-----------------------------------------------------------------------------
