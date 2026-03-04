* @ValidationCode : MjotMTM3MTI1OTAzMTpDcDEyNTI6MTc1ODgzNTU4MTg1MjpVc3VhcmlvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Sep 2025 16:26:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Usuario
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcContractService
SUBROUTINE ABC.NOFILE.RUTA.CONTR(R.DATA)

    $USING EB.Reports
    $USING EB.SystemTables
    
    GOSUB INICIALIZA
    GOSUB PROCESS
    GOSUB FINALLY
    
***********
INICIALIZA:
***********

RETURN

***********
PROCESS:
***********
    D.FIELDS = EB.Reports.getDFields()
    D.RANGE.AND.VALUE = EB.Reports.getDRangeAndValue()
        
    LOCATE "RUTA.ARCHIVO" IN D.FIELDS<1> SETTING POSITION THEN
        Y.RUTA = D.RANGE.AND.VALUE<POSITION>
    END
        
    R.DATA = Y.RUTA
        
RETURN

************
FINALLY:
************

RETURN

END
