* @ValidationCode : MjoyNTM4MzExNDE6Q3AxMjUyOjE3NjEzNTI2NTMwODg6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Oct 2025 21:37:33
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


SUBROUTINE ABC.B.AA.BULK.SERVICES.SELECT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*===============================================
* Nombre de Programa:   ABC.B.AA.BULK.SERVICES.SELECT
* Objetivo:
* Desarrollador:        ISAIAS RODRIGUEZ - FYG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       2016-10-05
* Modificaciones:
*===============================================
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    
    
    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALLY

RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    Y.LISTA.FULL.LINE = ''
    FN.BULK.LOAD = AbcCob.getFnBulkLoad()
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    SEL.CMD = 'SELECT ': FN.BULK.LOAD
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)


    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE REC.ID : REC.POS
        EB.DataAccess.FRead(FN.BULK.LOAD,REC.ID,REC.BULK.PROCESS,F.BULK.LOAD,BULK.ERR)
        LOOP
            REMOVE OFS.REQ FROM REC.BULK.PROCESS SETTING OFS.POS
        WHILE OFS.REQ : OFS.POS
            Y.LISTA.FULL.LINE<-1> = OFS.REQ
        REPEAT
        EB.DataAccess.FDelete(FN.BULK.LOAD,REC.ID)
    REPEAT

    EB.Service.BatchBuildList('',Y.LISTA.FULL.LINE)

RETURN
*-----------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------
RETURN

END

