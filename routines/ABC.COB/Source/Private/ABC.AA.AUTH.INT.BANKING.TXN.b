* @ValidationCode : MjotNjc4MzM3MDgyOkNwMTI1MjoxNzYwNTQ4NzQ1NTA4Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Oct 2025 14:19:05
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

SUBROUTINE ABC.AA.AUTH.INT.BANKING.TXN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Nombre de Programa:   ABC.AA.AUTH.INT.BANKING.TXN
* Objetivo:             Rutina que detecta las transacciones en inau que ingresan desde la banca en linea
* Desarrollador:        Franco Manrique - FYG Solutions
* Compania:             ABC CAPITAL
* Fecha Creacion:       2014-03-03
* Modificaciones:
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Service
    $USING AA.Framework
    $USING EB.Foundation
    $USING EB.Interface
    $USING EB.TransactionControl


    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB FINALLY
RETURN

*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***

    F.ABC.AA.PRE.PROCESS$NAU = ''
    FN.ABC.AA.PRE.PROCESS$NAU = 'F.ABC.AA.PRE.PROCESS$NAU'
    EB.DataAccess.Opf(FN.ABC.AA.PRE.PROCESS$NAU,F.ABC.AA.PRE.PROCESS$NAU)

    Y.OFS.SOURCE = 'OFS.SRC.AA.AUTH'
    Y.APPLICATION = 'ABC.AA.PRE.PROCESS'
    Y.OFS.VERSION = 'ABC.AA.PRE.PROCESS,AA'
    Y.FUNCTION = 'A'
    Y.NO.OF.AUTH = 0

*
RETURN
*** </region>
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    SEL.CMD = 'SELECT ': FN.ABC.AA.PRE.PROCESS$NAU : ' WITH RECORD.STATUS EQ "INAU" AND NEW.INTEREST.RATE EQ "" AND ARRANGEMENT.ID NE "" AND SIM.FLAG NE "YES" AND INTERNET.BANKING EQ "YES"'  ; * ITSS - ADOLFO - Added "
    SEL.LIST = ''
    NO.OF.REC = ''
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
  
*  DISPLAY "REGISTROS A PROCESAR --> " : NO.OF.REC
  
    FOR Y.AA = 1 TO NO.OF.REC
        Y.ABC.AA.PRE.PROCESS.ID = SEL.LIST<Y.AA>
        DISPLAY "SE VA A AUTORIZAR --> " : Y.ABC.AA.PRE.PROCESS.ID
        R.F.ABC.AA.PRE.PROCESS = ''
        Y.OFS.MSG = ''
        EB.Foundation.OfsBuildRecord(Y.APPLICATION, Y.FUNCTION, "PROCESS", Y.OFS.VERSION, "", Y.NO.OF.AUTH, Y.ABC.AA.PRE.PROCESS.ID, R.F.ABC.AA.PRE.PROCESS, Y.OFS.MSG)

        EB.Interface.OfsPostMessage(Y.OFS.MSG,Y.OFS.MSG.ID,Y.OFS.SOURCE,Y.OFS.OPTIONS)


    NEXT Y.AA

    EB.TransactionControl.JournalUpdate('')


*
RETURN

*-----------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END



