* @ValidationCode : MjotNTk4NjQ2MDEzOkNwMTI1MjoxNzYwNTQ5MDkwNjcyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Oct 2025 14:24:50
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

SUBROUTINE ABC.AA.BULK.SERVICES
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING AA.Framework
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.TransactionControl
    
    FN.BULK.LOAD='F.ABC.AA.BULK.PROCESS.LIST'
    F.BULK.LOAD=''
    EB.DataAccess.Opf(FN.BULK.LOAD,F.BULK.LOAD)

    theResponse = ""
    txnCommitted = ""
    options = ''
    options<1> = "AA.COB"
    options<4> = "HLD"

    SEL.CMD='';
    SEL.LIST='';
    SEL.CMD = 'SELECT ': FN.BULK.LOAD
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE REC.ID : REC.POS
        EB.DataAccess.FRead(FN.BULK.LOAD,REC.ID,REC.BULK.PROCESS,F.BULK.LOAD,BULK.ERR)
        LOOP
            REMOVE OFS.REQ FROM REC.BULK.PROCESS SETTING OFS.POS
        WHILE OFS.REQ : OFS.POS
            EB.Interface.OfsCallBulkManager(options,OFS.REQ,theResponse,txnCommitted)

        REPEAT
        EB.DataAccess.FDelete(FN.BULK.LOAD,REC.ID)

    REPEAT
END

