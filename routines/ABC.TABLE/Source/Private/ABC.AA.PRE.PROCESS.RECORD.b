* @ValidationCode : MjotOTAyNjE5NjU4OkNwMTI1MjoxNzU3NjA4NDE1MDE3Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Sep 2025 13:33:35
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

$PACKAGE AbcTable

SUBROUTINE ABC.AA.PRE.PROCESS.RECORD
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
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.FUNCTION  = EB.SystemTables.getVFunction()
    PGM.VERSION = EB.SystemTables.getPgmVersion()
    
    FN.BANK.PARAM   = 'F.ABC.PARAM.PROCESO'
    F.BANK.PARAM    = ''
    EB.DataAccess.Opf(FN.BANK.PARAM,F.BANK.PARAM)
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    tmp     = EB.SystemTables.getT(AbcTable.AbcAaPreProcess.DateConvention)
    tmp<3>  = "NOINPUT"
    EB.SystemTables.setT(AbcTable.AbcAaPreProcess.DateConvention, tmp)
    EB.Display.RebuildScreen()

    IF Y.FUNCTION EQ 'I' OR Y.FUNCTION EQ 'R' THEN

        CAT.PROD        = ''
        R.BANK.PARAM    = ''
        EB.DataAccess.FRead(FN.BANK.PARAM,'MX0010001',R.BANK.PARAM,F.BANK.PARAM,BANK.PARAM.ERR)

        BEGIN CASE
            CASE PGM.VERSION EQ ',PRO' OR PGM.VERSION EQ ',PRO.SIM'
                CAT.PROD ='6605'
            CASE PGM.VERSION EQ ',CDF' OR PGM.VERSION EQ ',CDF.SIM'
                CAT.PROD ='6606'
            CASE PGM.VERSION EQ ',CDV' OR PGM.VERSION EQ ',CDV.SIM'
                CAT.PROD ='6607'
            CASE PGM.VERSION EQ ',CDR' OR PGM.VERSION EQ ',CDR.SIM'
                CAT.PROD ='6608'
        END CASE
        
        CATEGORIA = RAISE(R.BANK.PARAM<AbcTable.AbcParamProceso.Categoria>)
        
        LOCATE CAT.PROD IN CATEGORIA SETTING APP.POS THEN
            PROD.STATUS = R.BANK.PARAM<AbcTable.AbcParamProceso.Estatus,APP.POS>
            IF PROD.STATUS EQ 'ACTIVA' THEN
                PRO.IN = R.BANK.PARAM<AbcTable.AbcParamProceso.HoraIni,APP.POS>
                PRO.IN = PRO.IN[1,2]:":":PRO.IN[3,2]:":":PRO.IN[5,2]
                PRO.OUT = R.BANK.PARAM<AbcTable.AbcParamProceso.HoraFin,APP.POS>
                PRO.OUT = PRO.OUT[1,2]:":":PRO.OUT[3,2]:":":PRO.OUT[5,2]
                CURR.TIME = OCONV(TIME(), "MTS")
                IF CURR.TIME GE PRO.IN AND CURR.TIME LE PRO.OUT ELSE
                    E ='No se permite hacer transacciones en este momento'
                    EB.SystemTables.setE(E)
                    EB.ErrorProcessing.Err()
                END
            END
        END
    END
RETURN
*-----------------------------------------------------------------------------
END