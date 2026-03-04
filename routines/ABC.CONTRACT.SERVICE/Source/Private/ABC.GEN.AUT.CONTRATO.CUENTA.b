* @ValidationCode : MjotMTAzNTkwNDU2NTpDcDEyNTI6MTc2NDM4NTk5Nzg0MzpVc3VhcmlvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Nov 2025 21:13:17
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
*===============================================================================
$PACKAGE AbcContractService
SUBROUTINE ABC.GEN.AUT.CONTRATO.CUENTA(ID.CONTRACT.ACCT)
*===============================================================================
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING EB.Interface
    $USING AA.Framework
    $USING EB.SystemTables
*===============================================================================
* Desarrollador:        FyG Solutions - LUIS CRUZ
* Compania:             ABC Capital
* Fecha:                2021-04-19
* Descripci�n:          Rutina de TSA.SERVICE que lista los archivos temporales
*                       de cada cuenta creada y ejecuta el enquiry de contrato para cada uno
*===============================================================================
* Fecha Modificacion : LFCR_20240226_CARATULA
* Modificaciones     : Se modifica rutina para agregar generacion de caratula
*===============================================================================
* Fecha Modificacion : LFCR_20240604_MULTITHREAD
* Modificaciones     : Se modifica rutina para migrarla de Single a Multithread
*===============================================================================
* Subroutine Type : MULTITHREAD SERVICE ROUTINE
* Attached to : TSA.SERVICE/BATCH>ABC.GENERA.CONTRATO
* Attached as : MULTITHREAD SERVICE ROUTINE
* Primary Purpose : Rutina para ejecutar enquiry de contratos para contratos digitales
*-----------------------------------------------------------------------
* Luis Cruz
* 26/09/2025
* Revision de rutina componentizada por 2G
*-----------------------------------------------------------------------
*****
   
*****

    GOSUB INICIO
    GOSUB PROCESO
    GOSUB FINAL

RETURN

*-----------------------------------------------------------------------------
INICIO:
*-----------------------------------------------------------------------------
    
    CRT "RUNNING REC RTN"
    Y.F.EBLOOKUP = AbcContractService.getFEbLookup()
    Y.FN.EBLOOKUP = AbcContractService.getFnEbLookup()
    Y.TEMP.FILE = ''
    Y.ID.CUENTA = ''
    ID.CUENTA = ''
    ENQ.ID = ''
    SEL.CRITERIA = ''
    RETURN.ARRAY = ''
    SYNTAX = ''

RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------
    
    CRT "EXEC REC RTN FOR->":ID.CONTRACT.ACCT
    FN.ACCOUNT     = AbcContractService.getFnAccount()
    F.ACCOUNT      = AbcContractService.getFAccount()
    FN.ACCOUNT.NAU = AbcContractService.getFnAccountNau()
    F.ACCOUNT.NAU  = AbcContractService.getFAccountNau()
    Y.PATH.EXEC    = AbcContractService.getPathExec()
    
    Y.TEMP.FILE = ID.CONTRACT.ACCT
    Y.ID.CUENTA = ID.CONTRACT.ACCT
    CRT "Y.ID.CUENTA-> " : Y.ID.CUENTA
    
    Y.EXTENSION.ID = FIELD(Y.ID.CUENTA, '*', 1)
    Y.ID.CUENTA = FIELD(Y.ID.CUENTA, '*', 2)
    Y.TIPO.CONTRATO = FIELD(Y.ID.CUENTA, '_', 1)
    Y.ID.FIRMANTE = '8'
    CRT "Y.ID.CUENTA-> " : Y.ID.CUENTA
    CRT "Y.EXTENSION.ID-> " : Y.EXTENSION.ID
    
    IF Y.EXTENSION.ID EQ 'PDF' THEN
        
        IF Y.TIPO.CONTRATO EQ 'CARA' THEN   ;*LFCR_20240226_CARATULA S
            
            ID.ARRANGEMENT = FIELD(Y.ID.CUENTA, '_', 2)
            IF ID.ARRANGEMENT[1,2] EQ 'AA' THEN
                CRT "ID.ARRANGEMENT-> " : ID.ARRANGEMENT
                R.ARRANGEMENT = AA.Framework.Arrangement.Read(ID.ARRANGEMENT, Error)
                ID.CUENTA = R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedApplId>
            END ELSE
                ID.CUENTA = FIELD(Y.ID.CUENTA, '_', 2)
            END

            ENQ.ID = 'ENQ.NOFILE.REP.CONT.CAR'
            SEL.CRITERIA = 'ID.CUENTA:EQ:=' : ID.CUENTA
            GOSUB GEN.CARAT.CONTRATO.OFS
        END ELSE
            
            ID.ARRANGEMENT = FIELD(Y.ID.CUENTA, '.', 1)
            IF ID.ARRANGEMENT[1,2] EQ 'AA' THEN
                CRT "ID.ARRANGEMENT-> " : ID.ARRANGEMENT
                R.ARRANGEMENT = AA.Framework.Arrangement.Read(ID.ARRANGEMENT, Error)
                ID.CUENTA = R.ARRANGEMENT<AA.Framework.Arrangement.ArrLinkedApplId>
            END ELSE
                ID.CUENTA = Y.ID.CUENTA
            END
            CRT "ID.CUENTA-> " : ID.CUENTA
            REC.CUENTA = AC.AccountOpening.Account.Read(ID.CUENTA, YF.ERR)
            IF REC.CUENTA EQ '' THEN
                REC.CUENTA = AC.AccountOpening.Account.ReadNau(ID.CUENTA, YF.ERR)
            END
            IF REC.CUENTA NE '' THEN
                CRT "REC.CUENTA NE ''-> " : ID.CUENTA
                ENQ.ID = 'ENQ.NOFILE.REP.CONT'
                SEL.CRITERIA = 'ID.CUENTA:EQ:=' : ID.CUENTA : ',FIRMANTE.1:EQ:=' : Y.ID.FIRMANTE : ',FIRMANTE.2:EQ:=' : Y.ID.FIRMANTE
                GOSUB GEN.CARAT.CONTRATO.OFS          ;* LFCR_20240226_CARATULA E
            END
        END
    END

    Y.ID.CUENTA = ''

RETURN
*-----------------------------------------------------------------------------
GEN.CARAT.CONTRATO.OFS:
*-----------------------------------------------------------------------------
    
    Y.OFS.REQUEST = "ENQUIRY.SELECT,,/," : ENQ.ID : "," : SEL.CRITERIA

    Y.OFS.SOURCE = AbcContractService.getOfsSource()

    options<1> = Y.OFS.SOURCE
    theRequest = Y.OFS.REQUEST
    theResponse = ""
    txnCommitted = ""
    
    CRT "theRequest REC-> " : theRequest
    
    EB.Interface.OfsCallBulkManager(options, theRequest, theResponse, txnCommitted)
*    CRT "ENQ.ID->" : ENQ.ID
*    CRT "SEL.CRITERIA->" : SEL.CRITERIA
    Y.MSG.OUT.OFS = "theResponse REC-> " : theResponse
    CRT Y.MSG.OUT.OFS
    Y.MSG.OUT.OFS = "theResponse REC upcase-> " : theResponse
    CRT Y.MSG.OUT.OFS
    FINDSTR "EXITOSA" IN Y.MSG.OUT.OFS SETTING AP THEN
        EB.DataAccess.FDelete(Y.FN.EBLOOKUP, ID.CONTRACT.ACCT)
    END

RETURN
*-----------------------------------------------------------------------------
FINAL:
*-----------------------------------------------------------------------------

RETURN
