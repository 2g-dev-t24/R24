* @ValidationCode : MjoxNDQwNzE4NDU3OkNwMTI1MjoxNzU5Njk5MzcxMDU3Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Oct 2025 18:22:51
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
SUBROUTINE ABC.REP.MULTI.R24D24.41.42.SELECT

    $USING EB.DataAccess
    $USING EB.Service
    $USING AbcTable
    $USING AbcGetGeneralParam
    
    GOSUB PROCESO.EXTRACCION

RETURN

*******************
PROCESO.EXTRACCION:
*******************

    FN.ACCOUNT = AbcCob.getFnAccountR24()
    FN.ABC.AA.PRE.PROCESS = 'F.ABC.AA.PRE.PROCESS'
    F.ABC.AA.PRE.PROCESS = ''
    EB.DataAccess.Opf(FN.ABC.AA.PRE.PROCESS,F.ABC.AA.PRE.PROCESS)
    
    Y.ARR.NOM.PARAM = ''
    Y.ARR.DAT.PARAM = ''
    Y.ID.PARAM = 'PARAMETROS.R2441.R2442'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.ARR.NOM.PARAM, Y.ARR.DAT.PARAM)
    LOCATE "CATEGORIAS.2441" IN Y.ARR.NOM.PARAM SETTING POS THEN
        J.CATEG.2441 = Y.ARR.DAT.PARAM<POS>
        CHANGE "," TO "' '" IN J.CATEG.2441
    END
    
    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH CATEGORY EQ '":J.CATEG.2441:"' BY @ID"

    EB.DataAccess.Readlist(SEL.CMD,LIST.AC,'',NO.ACC,ERR.SEL)

    SEL.CMD.AA = "SELECT ":FN.ABC.AA.PRE.PROCESS:" WITH INTERNET.BANKING EQ 'YES'"
    EB.DataAccess.Readlist(SEL.CMD.AA,LIST.AA,'',NO.AA,ERR.SEL.AA)

    YARR.AA.BANCA = ''
    FOR I.AA = 1 TO NO.AA
        PRINT "ABC.AA.PRE.PROCESS: ":I.AA:" DE ":NO.AA
        Y.ID.AA.PRE.PROCESS = LIST.AA<I.AA>
        EB.DataAccess.FRead(FN.ABC.AA.PRE.PROCESS,Y.ID.AA.PRE.PROCESS,REC.AA.PREPROCESS,F.ABC.AA.PRE.PROCESS,ERR.AA.PREPROCES)
        YARR.AA.BANCA := REC.AA.PREPROCESS<AbcTable.AbcAaPreProcess.ActRefId>[1,16]
        IF I.AA NE NO.AA THEN YARR.AA.BANCA := @FM
    NEXT I.AA
    AbcCob.setYArrAABanca(YARR.AA.BANCA)
    EB.Service.BatchBuildList('',LIST.AC)

RETURN

END
