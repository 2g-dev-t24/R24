* @ValidationCode : Mjo1MjgyMDg5OTg6Q3AxMjUyOjE3NjQxMjY4OTExMTY6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Nov 2025 00:14:51
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
$PACKAGE AbcRegulatorios

SUBROUTINE ABC.GENERA.REPORTE.CEDES.LOAD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AbcGetGeneralParam
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Security
    
*-----------------------------------------------------------------------------

    GOSUB INICIALIZA
    GOSUB OBTIENE.PARAM
    GOSUB LEE.NOMBRE.FICHERO
    GOSUB FINALLY
RETURN
***********
INICIALIZA:
***********

    FN.AA.ARR.ACT = 'F.AA.ARRANGEMENT.ACTIVITY'F.AA.ARR.ACT = '' EB.DataAccess.Opf(FN.AA.ARR.ACT,F.AA.ARR.ACT)
    FN.ACTI.HIS   = 'F.AA.ACTIVITY.HISTORY'     F.ACTI.HIS  = '' EB.DataAccess.Opf(FN.ACTI.HIS,F.ACTI.HIS)
    FN.PARA.PROD  = 'F.ABC.PARAM.CONT.PROD'     F.PARA.PROD = '' EB.DataAccess.Opf(FN.PARA.PROD,F.PARA.PROD)
    FN.DAO        = 'F.DEPT.ACCT.OFFICER'       F.DAO       = '' EB.DataAccess.Opf(FN.DAO,F.DAO)
    FN.PRODUCTO   = 'F.AA.PRODUCT'              F.PRODUCTO  = '' EB.DataAccess.Opf(FN.PRODUCTO,F.PRODUCTO)
    FN.CLIENTE    = 'F.CUSTOMER'                F.CLIENTE   = '' EB.DataAccess.Opf(FN.CLIENTE,F.CLIENTE)
    FN.CUENTA     = 'F.ACCOUNT'                 F.CUENTA    = '' EB.DataAccess.Opf(FN.CUENTA,F.CUENTA)
    FN.TAX        = 'F.TAX'                     F.TAX       = '' EB.DataAccess.Opf(FN.TAX,F.TAX)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'      F.AA.ARRANGEMENT = '' EB.DataAccess.Opf(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.ACTI.HIS.HIS   = 'F.AA.ACTIVITY.HISTORY.HIST' F.ACTI.HIS.HIS = '' EB.DataAccess.Opf(FN.ACTI.HIS.HIS,F.ACTI.HIS.HIS)

    AbcRegulatorios.setFnAaArrAct(FN.AA.ARR.ACT);
    AbcRegulatorios.setFnActiHis(FN.ACTI.HIS);
    AbcRegulatorios.setFnParaProd(FN.PARA.PROD);
    AbcRegulatorios.setFnDao(FN.DAO);
    AbcRegulatorios.setFnProducto(FN.PRODUCTO);
    AbcRegulatorios.setFnCliente(FN.CLIENTE);
    AbcRegulatorios.setFnCuenta(FN.CUENTA);
    AbcRegulatorios.setFnTax(FN.TAX);
    AbcRegulatorios.setFnAaArrangement(FN.AA.ARRANGEMENT);
    AbcRegulatorios.setFnActiHisHis(FN.ACTI.HIS.HIS);
 
    AbcRegulatorios.setFAaArrAct(F.AA.ARR.ACT);
    AbcRegulatorios.setFAaActivityHistory(F.ACTI.HIS);
    AbcRegulatorios.setFAbcParamContProd(F.PARA.PROD);
    AbcRegulatorios.setFDeptAcctOfficer(F.DAO);
    AbcRegulatorios.setFAaProduct(F.PRODUCTO);
    AbcRegulatorios.setFCustomer(F.CLIENTE);
    AbcRegulatorios.setFAccount(F.CUENTA);
    AbcRegulatorios.setFTax(F.TAX);
    AbcRegulatorios.setFAaArrangement(F.AA.ARRANGEMENT);
    AbcRegulatorios.setFAaActivityHistoryHis(F.ACTI.HIS.HIS);

    EB.Updates.MultiGetLocRef('ACCOUNT','EXENTO.IMPUESTO',YPOS.EXENTO.IMPUESTO)
    AbcRegulatorios.setYposExentoImpuesto(YPOS.EXENTO.IMPUESTO);
RETURN

**************
OBTIENE.PARAM:
**************
*DEBUG
    Y.SALTO.LINEA = CHAR(10)
    CONTA = 0
    CONTADOR.NOPROCESADO = 0
    Y.LOG.FINAL = ''
    Y.DATE.HOUR = ''
    Y.LIST.PARAMS = ''
    Y.LIST.VALUES = ''
    Y.ID.PARAM = 'ABC.PARAMETROS.REPO.INV'
    AbcGetGeneralParam.AbcGetGeneralParam(Y.ID.PARAM, Y.LIST.PARAMS, Y.LIST.VALUES)
    NUM.LINEAS = DCOUNT(Y.LIST.PARAMS,FM)

    LOCATE "RUTA_PDF" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.PDF =  Y.LIST.VALUES<POS>
**AbcGetGeneralParam(RUTA.PDF)
    END

    LOCATE "RUTA_XML" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.XML = Y.LIST.VALUES<POS>
*AbcGetGeneralParam(RUTA.XML)
    END

    LOCATE "RUTA_JRXML" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.JRXML = Y.LIST.VALUES<POS>
*AbcGetGeneralParam(RUTA.JRXML)
    END

    LOCATE "NOMBRE_PAGARE_VECTOR" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.JR.PAG = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_PDF_PAGARE" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.PDF.PAG = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_CEDE_F_VECTOR" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.JR.F = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_REP_CEDES" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.PDF.F = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_CEDE_VECTOR" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.JR.CEDE = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_REP_CEDES" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.PDF.CEDE = Y.LIST.VALUES<POS>
    END

    LOCATE "NOMBRE_JAR" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.JAR = Y.LIST.VALUES<POS>
    END

    LOCATE "RUTA_IMAGEN_JR" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.IMAGEN.JR = Y.LIST.VALUES<POS>
*AbcGetGeneralParam(RUTA.IMAGEN.JR)
    END

    LOCATE "RUTA_SUBREPORTE_JR" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.SUBREPORTE.JR = Y.LIST.VALUES<POS>
*AbcGetGeneralParam(RUTA.SUBREPORTE.JR )
    END

    LOCATE "RUTA_FICHERO_VECTOR" IN Y.LIST.PARAMS SETTING POS THEN
        RUTA.FICHERO.VECTOR = Y.LIST.VALUES<POS>
*AbcGetGeneralParam(RUTA.FICHERO.VECTOR)
    END

    LOCATE "NOMBRE_FICHERO_VECTOR" IN Y.LIST.PARAMS SETTING POS THEN
        NOMBRE.FICHERO.VECTOR = Y.LIST.VALUES<POS>
    END
    AbcRegulatorios.setRutaPdf(RUTA.PDF)
    AbcRegulatorios.setRutaXml(RUTA.XML)
    AbcRegulatorios.setRutaJrxml(RUTA.JRXML)

    AbcRegulatorios.setNombreJrPag(NOMBRE.JR.PAG)
    AbcRegulatorios.setNombrePdfPag(NOMBRE.PDF.PAG)

    AbcRegulatorios.setNombreJrF(NOMBRE.JR.F)
    AbcRegulatorios.setNombrePdfF(NOMBRE.PDF.F)

    AbcRegulatorios.setNombreJrCede(NOMBRE.JR.CEDE)
    AbcRegulatorios.setNombrePdfCede(NOMBRE.PDF.CEDE)

    AbcRegulatorios.setNombreJar(NOMBRE.JAR)

    AbcRegulatorios.setRutaImagenJr(RUTA.IMAGEN.JR)
    AbcRegulatorios.setRutaSubreporteJr(RUTA.SUBREPORTE.JR)
    AbcRegulatorios.setRutaFicheroVector(RUTA.FICHERO.VECTOR)
    AbcRegulatorios.setNombreFicheroVector(NOMBRE.FICHERO.VECTOR)

RETURN

****************
LEE.NOMBRE.FICHERO:
******************
    Y.LECT.ARCHIVO = RUTA.FICHERO.VECTOR: 'INV_TEMP_DATA.txt'

    OPENSEQ Y.LECT.ARCHIVO TO ARCH.TEMP  THEN
        LOOP
            READSEQ Y.LINEA FROM ARCH.TEMP THEN STATE=STATUS() ELSE EXIT
        UNTIL STATE=1
            NOMBRE.FICHERO = FIELD(Y.LINEA,'',1)
            NOMB.FOLDER = FIELD(Y.LINEA,'.txt',1)
        REPEAT
    END
    CLOSESEQ ARCH.TEMP
    
    AbcRegulatorios.setNombreFichero(NOMBRE.FICHERO)
    AbcRegulatorios.setNombFolder(NOMB.FOLDER)
RETURN

*-------------------------------------------------------------------------
*Last Step in Program
*-------------------------------------------------------------------------
FINALLY:
*-----------------------------------------------------------------------------

*Do Not Add Return :)

END

