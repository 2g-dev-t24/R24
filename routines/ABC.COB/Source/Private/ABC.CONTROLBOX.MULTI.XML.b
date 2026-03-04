* @ValidationCode : Mjo0NzEzMjYwODY6Q3AxMjUyOjE3NjgyMzUyNjAzMjk6RWRnYXIgU2FuY2hlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2026 10:27:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Edgar Sanchez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2026. All rights reserved.
$PACKAGE AbcCob
SUBROUTINE ABC.CONTROLBOX.MULTI.XML(Y.CUS.ID)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*======================================================================================
* Nombre de Programa : ABC.CONTROLBOX.MULTI.XML
* Objetivo           : Se requiere conversi�n a multithreat para extraer informacion de
*                      customer y account en archivos XML para alimentar el sistema CONTROLBOX
* Desarrollador      : C�sar Miranda - FyG Solutions
* Fecha Creacion     : 2023-11-13
*======================================================================================
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing
    $USING ST.Customer
    $USING AbcTable
    $USING EB.Updates
    $USING EB.Service
    $USING EB.AbcUtil
    $USING EB.LocalReferences
    
    GOSUB INICIO
    GOSUB PROCESO
    GOSUB SAVE.LOG

RETURN

*******
INICIO:
*******
    Y.REC.CLIENTES        = ''
    Y.ITP                 = ''
    Y.NOMBRE.CLI          = ''
    Y.APEPAT              = ''
    Y.APEMAT              = ''
    Y.FECH.NAC.CONST.CLI  = ''
    Y.RFC.TAX.ID.CLI      = ''
    Y.FECHA.ALTA.CLI      = ''
    Y.FECHA.ALTA.REL      = ''
    Y.ID.STATUS.CLI       = ''
    Y.ERROR.P1            = ''
    R.INFO.CLIENTE        = ''
    R.ABC.ACCT.LCL.FLDS   = ''
    Y.ACC.ID              = ''
    Y.MONEDA              = ''
    Y.IDSP                = ''
    Y.ID.STATUS.ACC       = ''
    Y.IDTR                = ''
    Y.NombreTR            = ''
    Y.NOMBRE.REL          = ''
    Y.FEC.NAC.REL         = ''
    Y.XML.RELACIONADO.TEMP= ''
    Y.XML.CUENTA.TEMP     = ''
    XML.REGISTRO          = ''
    Y.REGISTROS.INCIDENCIA= ''
    XML.REGISTRO.ALERTA   = ''
    Y.ESP                 = ' '
    Y.CONT.REG            = 0
    Y.ARCHIVO.CONS        = 1
    
    yRtnName = 'ABC.CONTROLBOX.XML'
    yDataLog = ''
    
    yDataLog<-1> =   'Inicia registro ID : ': Y.CUS.ID
    Y.NO.CAT = AbcCob.getYNoCatCB()
    
    FN.ABC.ACCT.LCL.FLDS    = AbcCob.getFnAbcAcctLclFldsCB()
    FN.CUS.ACC              = AbcCob.getFnCustomerAccountCB()
    FN.CUENTA               = AbcCob.getFnAccountCB()
    FN.CLIENTE              = AbcCob.getFnCustomerCB()
    F.ABC.ACCT.LCL.FLDS    = AbcCob.getFAbcAcctLclFldsCB()
    F.CUS.ACC              = AbcCob.getFCustomerAccountCB()
    F.CUENTA               = AbcCob.getFAccountCB()
    F.CLIENTE              = AbcCob.getFCustomerCB()
    
    Y.CATEGORIAS            = AbcCob.getYCategoriasCB()
    Y.RUTA_ARCHIVO_XML      = AbcCob.getYRutaArchivoXmlCB()
*    Y.RUTA_ARCHIVO_LOG      = AbcCob.getYRutaArchivoXmlLog()

    Y.RUTA_ARCHIVO_LOG      = AbcCob.getYRutaControlboxLog()
    Y.NOMBRE_ARCHIVO_XML    = AbcCob.getYNombreArchivoXmlCB()
    Y.RUTA_ARCHIVO_XML_TEMP = AbcCob.getYRutaArchivoXmlTempCB()
    Y.RUTA_ARCHIVO_XML_ERR  = AbcCob.getYRutaArchivoXmlErrorCB()
    Y.ULTIMA_FECHA_EXTRAC   = AbcCob.getYUltimaFechaExtrac()
    
*    EB.Updates.MultiGetLocRef('CUSTOMER','CLASSIFICATION',YPOS.CLASSIFICATION) ;*Sector CUSTOMER
*    EB.Updates.MultiGetLocRef('CUSTOMER','NOM.PER.MORAL',YPOS.NOM.PER.MORAL)
    EB.LocalReferences.GetLocRef('CUSTOMER','L.NOM.PER.MORAL',YPOS.NOM.PER.MORAL)

*    EB.Updates.MultiGetLocRef('CUSTOMER','ENTITY.TYPE',YPOS.ENTITY.TYPE)
    

    
    AGENT.ID    = EB.Service.getAgentNumber()
    AGENT.NUMBER  = TIMEDATE()
    AGENT.NUMBER = EREPLACE(AGENT.NUMBER,":",'')
    AGENT.NUMBER = EREPLACE(AGENT.NUMBER," ",'')
    RANDOM.NUMBER= RND(99999)
    AGENT.NUMBER := AGENT.ID:'_':RANDOM.NUMBER
        

RETURN

********
PROCESO:
********
    EB.DataAccess.FRead(FN.CLIENTE,Y.CUS.ID,R.INFO.CLIENTE,F.CLIENTE,ERROR.CLIENTE)
    IF R.INFO.CLIENTE NE '' THEN
        Y.TIPO.PER       = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>
*     Y.ENTITY.TYPE    = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef,YPOS.ENTITY.TYPE>  ;*esanchez20251222 dejo de usarse en la migracion a R24
        Y.ENTITY.TYPE = ''
        Y.CLASSIFICATION = R.INFO.CLIENTE<ST.Customer.Customer.EbCusSector>
        
        IF Y.ENTITY.TYPE NE 2 AND (Y.CLASSIFICATION NE "" AND Y.CLASSIFICATION NE "COT") THEN
            BEGIN CASE
                CASE Y.TIPO.PER = '1001'         ;*Se mapean el tipo de personas, acorde a la especificacion del sistema CONTROL BOX (1 PF; 2 PM; 3 PFAE;4.Vector)
                    Y.ITP = 1                                       ;*1001 -> PF  Tipo 1
                CASE Y.TIPO.PER GE '2001' OR Y.TIPO.PER LE '2014'   ;*1100 -> PFAEM  Tipo 2
                    Y.ITP = 3                                       ;*2001 - 2014 -> PM   Tipo 3
                CASE Y.TIPO.PER = '1100'
                    Y.ITP = 2
                CASE Y.TIPO.PER = 4
                    Y.ITP = 3
            END CASE

            IF Y.ITP NE 2 THEN
                Y.NOMBRE.CLI = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameTwo>
                CHANGE @VM TO ' ' IN Y.NOMBRE.CLI
                Y.APEPAT = R.INFO.CLIENTE<ST.Customer.Customer.EbCusShortName>          ;*Este campo  es obligatorio
                Y.APEMAT = R.INFO.CLIENTE<ST.Customer.Customer.EbCusNameOne>    ;*Este campo es obligatorio
                IF Y.APEPAT EQ '' OR Y.APEMAT EQ '' THEN
                    Y.ERROR.P1 = '1'
                END
            END ELSE
                Y.NOMBRE.CLI = R.INFO.CLIENTE<ST.Customer.Customer.EbCusLocalRef,YPOS.NOM.PER.MORAL>
*              IF YPOS.NOM.PER.MORAL EQ '' THEN
                    
*              END
            
                    
            END
*        END
            
            Y.FECH.NAC.CONST.CLI = R.INFO.CLIENTE<ST.Customer.Customer.EbCusDateOfBirth>         ;* CLIENTE
            Y.FECH.NAC.CONST.CLI.I = Y.FECH.NAC.CONST.CLI[1,4]:"-":Y.FECH.NAC.CONST.CLI[5,2]:"-":Y.FECH.NAC.CONST.CLI[7,2]
            Y.RFC.TAX.ID.CLI = R.INFO.CLIENTE<ST.Customer.Customer.EbCusTaxId,1>
            Y.FECHA.ALTA.CLI = R.INFO.CLIENTE<ST.Customer.Customer.EbCusBirthIncorpDate>
            Y.FECHA.ALTA.CLI.I = Y.FECHA.ALTA.CLI[1,4]:"-":Y.FECHA.ALTA.CLI[5,2]:"-":Y.FECHA.ALTA.CLI[7,2]
            Y.ID.STATUS.CLI = R.INFO.CLIENTE<ST.Customer.Customer.EbCusCustomerStatus>
            BEGIN CASE
                CASE Y.ID.STATUS.CLI = 1    ;*Se mapean el tipo de personas, acorde a la especificacion del sistema CONTROL BOX (1 PF; 2 PM; 3 PFAE;4.Vector)
                    Y.ID.STATUS.CLI = 8
                CASE Y.ID.STATUS.CLI = 2
                    Y.ID.STATUS.CLI = 61
            END CASE

            IF Y.ERROR.P1 EQ '1' OR Y.CUS.ID EQ '' OR Y.TIPO.PER EQ '' OR Y.NOMBRE.CLI EQ '' OR Y.FECH.NAC.CONST.CLI EQ '' OR Y.RFC.TAX.ID.CLI EQ '' OR Y.FECHA.ALTA.CLI EQ '' THEN
                Y.REGISTROS.INCIDENCIA = Y.REGISTROS.INCIDENCIA+1
                XML.REGISTRO.ALERTA:='ID.CLIENTE: ':Y.CUS.ID:CHAR(10)
                XML.REGISTRO.ALERTA:='***************************************':CHAR(10)
                GOSUB ESCRIBE.ALERTA
            END ELSE          ;*Si no faltan datos... vemos las cuentas...
                GOSUB GENERA.REGISTRO.CLIENTE
                EB.DataAccess.FRead(FN.CUS.ACC,Y.CUS.ID,Y.REC.CUENTAS,F.CUS.ACC,ERROR.CLIENTE)
                
                Y.NO.CUENTAS = DCOUNT(Y.REC.CUENTAS,@FM)
                IF Y.NO.CUENTAS GT 0 THEN
                    FOR Y.CONT.ACC = 1 TO Y.NO.CUENTAS
                        Y.ACC.ID = Y.REC.CUENTAS<Y.CONT.ACC>
                        
                        EB.DataAccess.FRead(FN.CUENTA,Y.ACC.ID,R.ACCOUNT,F.CUENTA,ERROR.CUENTA)
                        ACCT.ARR.ID =  R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
                        R.ABC.ACCT.LCL.FLDS = AbcTable.AbcAcctLclFlds.Read(ACCT.ARR.ID, Error)
                        
*                        EB.DataAccess.FRead(FN.ABC.ACCT.LCL.FLDS,Y.ACC.ID,R.ABC.ACCT.LCL.FLDS,F.ABC.ACCT.LCL.FLDS,Y.ERROR)
                        
                        Y.IDSP = R.ACCOUNT<AC.AccountOpening.Account.Category>
                        FOR Y.CONT.CAT = 1 TO Y.NO.CAT
                            Y.CATEGORIAS = EREPLACE(Y.CATEGORIAS,',',@FM)
*                            Y.CATEG.FLD = FIELD(Y.CATEGORIAS,@FM,Y.CONT.CAT)
*                            IF Y.IDSP EQ Y.CATEG.FLD THEN
                            LOCATE Y.IDSP IN Y.CATEGORIAS SETTING LOC THEN
                                Y.MONEDA           = R.ACCOUNT<AC.AccountOpening.Account.Currency>
                                Y.FECHA.ALTA.REL   = R.ACCOUNT<AC.AccountOpening.Account.OpeningDate>
                                Y.FECHA.ALTA.REL.I = Y.FECHA.ALTA.REL[1,4]:"-":Y.FECHA.ALTA.REL[5,2]:"-":Y.FECHA.ALTA.REL[7,2]    ;* Se reutiliza fecha de alta para personas relacionadas
                                Y.ID.STATUS.ACC    = R.ACCOUNT<AC.AccountOpening.Account.PostingRestrict>
                                IF Y.ID.STATUS.ACC NE 84 THEN
                                    Y.ID.STATUS.ACC = 59    ;*Estatus Vigente
                                END ELSE
                                    Y.ID.STATUS.ACC = 56    ;* Estatus congelado
                                END
                                
                                IF Y.ERROR.P1 EQ '1' OR Y.ACC.ID EQ '' OR Y.MONEDA EQ '' OR Y.IDSP EQ '' OR Y.FECHA.ALTA.REL EQ '' THEN     ;*Valido campos requeridos
                                    Y.REGISTROS.INCIDENCIA = Y.REGISTROS.INCIDENCIA+1
                                    XML.REGISTRO.ALERTA:='ID.CLIENTE: ':Y.CUS.ID:' CUENTA:': Y.ACC.ID:CHAR(10)
                                    XML.REGISTRO.ALERTA:='***************************************':CHAR(10)
                                    GOSUB ESCRIBE.ALERTA
                                    Y.ERROR.P2 = '1'
                                    BREAK
                                END ELSE
                                    
                                    Y.CONS.REL=0  ;*Para contar el numero de relacionados
                                    
                                    GOSUB GENERA.REGISTRO.CUENTA      ;*Ahora leo los relacionados de cada cuenta
                                    GOSUB LEE.RELACIONADOS.COTITULAR
                                    GOSUB LEE.RELACIONADOS.REPRESENTANTE
                                    
                                    GOSUB LEE.RELACIONADOS.BENEFICIARIO
                                    
                                    GOSUB LEE.RELACIONADOS.FIRMANTES
                                END
                            END
                            Y.FECHA.ALTA.REL = ''
                        NEXT Y.CONT.CAT
                        IF Y.ERROR.P2 EQ '1' THEN
                            BREAK
                        END ELSE
                            Y.ERROR.P2 = '0'
                        END
                    NEXT Y.CONT.ACC
                    Y.ITP = ''
                    Y.CUS.ID = ''
                END
                IF Y.XML.RELACIONADO.TEMP NE '' THEN
                    Y.RELACIONADOS.REG = '<Relacionados>':CHAR(10):Y.XML.RELACIONADO.TEMP:'</Relacionados>':CHAR(10)
                END ELSE
                    Y.RELACIONADOS.REG = ''
                END
                IF Y.XML.CUENTA.TEMP NE '' THEN
                    Y.CUENTAS.REG = '<Cuentas>':CHAR(10):Y.XML.CUENTA.TEMP:'</Cuentas>':CHAR(10)
                END ELSE
                    Y.CUENTAS.REG = ''
                END

                IF Y.ERROR.P1 NE '1' THEN
                    XML.REGISTRO := Y.XML.CLIENTE:Y.RELACIONADOS.REG:Y.CUENTAS.REG:'</Cliente>'     ;*:CHAR(10)
                END
            END
            Y.XML.CLIENTE=''
            Y.XML.RELACIONADO.TEMP=''
            Y.XML.CUENTA.TEMP=''
        END
    END
    
    GOSUB ESCRIBE.ARCHIVO
    XML.REGISTRO = ''
    
RETURN



***************************
LEE.RELACIONADOS.COTITULAR:
***************************

    TOTAL.COTITULAR = ''

    Y.ID.COTI.CUS = ''
    
    Y.ID.COTI.CUS = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.IdCoti>
    CONVERT @SM TO @FM IN Y.ID.COTI.CUS

    TOTAL.COTITULAR = DCOUNT(Y.ID.COTI.CUS,@FM)    ;* AAR202212226 - E

    IF TOTAL.COTITULAR GT 0 THEN

        FOR CT = 1 TO TOTAL.COTITULAR
            Y.ID.CUS = ''     ;* AAR202212226 - S
            R.CUSTOMER = ''
            ERR.CUR = ''
            Y.ID.CUS = Y.ID.COTI.CUS<CT>
            EB.DataAccess.FRead(FN.CLIENTE, Y.ID.CUS, R.CUSTOMER, F.CLIENTE, ERR.CUR)   ;* AAR202212226 - E
            IF R.CUSTOMER THEN
                Y.CONS.REL = Y.CONS.REL+1
                Y.IDTR = 1    ;* COTITULAR
                Y.NombreTR = 'Cotitular'
                Y.NOMBRE.REL      = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
                Y.ApellidoPaterno = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
                Y.ApellidoMaterno = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>         ;* AAR202212226 - E
                IF Y.NOMBRE.REL EQ '' THEN
                    Y.NOMBRE.REL = 'XXXXX'
                END
                Y.FEC.NAC.REL = R.CUSTOMER<ST.Customer.Customer.EbCusDateOfBirth>      ;* AAR202212226 - E
                IF Y.FEC.NAC.REL NE '' THEN
                    Y.FEC.NAC.REL.I = Y.FEC.NAC.REL[1,4]:"-":Y.FEC.NAC.REL[5,2]:"-":Y.FEC.NAC.REL[7,2]
                END ELSE
                    Y.FEC.NAC.REL.I = Y.FECHA.ALTA.REL.I
                END

                Y.RFC.ID.REL = R.CUSTOMER<ST.Customer.Customer.EbCusTaxId><1,1>         ;* AAR202212226 - E
                IF Y.RFC.ID.REL EQ '' THEN
                    Y.RFC.ID.REL = 'XXXXXXXXXXXXX'
                END
                GOSUB GENERA.REGISTRO.RELACIONADOS
            END
        NEXT CT
    END

RETURN

*******************************
LEE.RELACIONADOS.REPRESENTANTE:
*******************************

    TOTAL.REPRESENTANTE = ''

    REP.FEC.NAC     = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.FacuFecNac>
    CONVERT @SM TO @FM IN REP.FEC.NAC
    REP.RFC         = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.FacuRfcReg>
    CONVERT @SM TO @FM IN REP.RFC
    REP.NOMBRE      = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.FacuNombre>
    CONVERT @SM TO @FM IN REP.NOMBRE
    REP.A.PATER     = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.FacuApePatern>
    CONVERT @SM TO @FM IN REP.A.PATER
    REP.A.MATER     = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.FacuApeMatern>
    CONVERT @SM TO @FM IN REP.A.MATER

    TOTAL.REPRESENTANTE = DCOUNT(REP.NOMBRE,@FM)
    IF TOTAL.REPRESENTANTE GT 0 THEN

        FOR REP = 1 TO TOTAL.REPRESENTANTE
            Y.CONS.REL = Y.CONS.REL+1
            Y.IDTR = 2        ;* REPRESENTANTE LEGAL
            Y.NombreTR = 'Representante Legal'
            Y.NOMBRE.REL = REP.NOMBRE<REP>
            Y.ApellidoPaterno = REP.A.PATER<REP>  ;*Este campo no es obligatorio
            Y.ApellidoMaterno = REP.A.MATER<REP>  ;*Este campo no es obligatorio
            IF Y.NOMBRE.REL EQ '' THEN
                Y.NOMBRE.REL = 'XXXXX'
            END
            Y.FEC.NAC.REL = REP.FEC.NAC<REP>
            IF Y.FEC.NAC.REL NE '' THEN
                Y.FEC.NAC.REL.I = Y.FEC.NAC.REL[1,4]:"-":Y.FEC.NAC.REL[5,2]:"-":Y.FEC.NAC.REL[7,2]
            END ELSE
                Y.FEC.NAC.REL.I = Y.FECHA.ALTA.REL.I
            END
            Y.RFC.ID.REL = REP.RFC<REP>
            IF Y.RFC.ID.REL EQ '' THEN
                Y.RFC.ID.REL = 'XXXXXXXXXXXXX'
            END
            GOSUB GENERA.REGISTRO.RELACIONADOS
        NEXT REP
    END

RETURN

******************************
LEE.RELACIONADOS.BENEFICIARIO:
******************************

    TOTAL.BENEFICIARIO = ''

    BEN.APE.PATERNO = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.BenApePaterno>
    CONVERT @SM TO @FM IN BEN.APE.PATERNO
    BEN.APE.MATERNO   = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.BenApeMaterno>
    CONVERT @SM TO @FM IN BEN.APE.MATERNO
    BEN.NOMBRE        = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.BenNombres>
    CONVERT @SM TO @FM IN BEN.NOMBRE
    BEN.RFC           = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.BenRfc>
    CONVERT @SM TO @FM IN BEN.RFC
    BEN.FEC.NAC       = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.BenFecNac>
    CONVERT @SM TO @FM IN BEN.FEC.NAC

    TOTAL.BENEFICIARIO = DCOUNT(BEN.NOMBRE,@FM)
    IF TOTAL.BENEFICIARIO GT 0 THEN

        FOR BEN = 1 TO TOTAL.BENEFICIARIO
            Y.CONS.REL = Y.CONS.REL+1

            Y.IDTR=3          ;* BENEFICIARIO
            Y.NombreTR = 'Beneficiario'
            Y.NOMBRE.REL = BEN.NOMBRE<BEN>
            Y.ApellidoPaterno = BEN.APE.PATERNO<BEN>
            Y.ApellidoMaterno = BEN.APE.MATERNO<BEN>
            IF Y.NOMBRE.REL EQ '' THEN
                Y.NOMBRE.REL = 'XXXXX'
            END
            Y.FEC.NAC.REL = BEN.FEC.NAC<BEN>
            IF Y.FEC.NAC.REL NE '' THEN
                Y.FEC.NAC.REL.I = Y.FEC.NAC.REL[1,4]:"-":Y.FEC.NAC.REL[5,2]:"-":Y.FEC.NAC.REL[7,2]
            END ELSE
                Y.FEC.NAC.REL.I = Y.FECHA.ALTA.REL.I
            END
            Y.RFC.ID.REL=BEN.RFC<BEN>
            IF Y.RFC.ID.REL EQ '' THEN
                Y.RFC.ID.REL = 'XXXXXXXXXXXXX'
            END
            GOSUB GENERA.REGISTRO.RELACIONADOS
        NEXT BEN
    END

RETURN

***************************
LEE.RELACIONADOS.FIRMANTES:
***************************

    TOTAL.FIRMANTES = ''

    FIR.A.PAT = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutApePat>
    CONVERT @SM TO @FM IN FIR.A.PAT
    FIR.A.MAT = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutApeMat>
    CONVERT @SM TO @FM IN FIR.A.MAT
    FIR.NOM   = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutNombre>
    CONVERT @SM TO @FM IN FIR.NOM
    FIR.NAC   = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutFecNac>
    CONVERT @SM TO @FM IN FIR.NAC
    FIR.RFC   = R.ABC.ACCT.LCL.FLDS<AbcTable.AbcAcctLclFlds.PerAutRfc>
    CONVERT @SM TO @FM IN FIR.RFC

    TOTAL.FIRMANTES = DCOUNT(FIR.NOM,@FM)
    IF TOTAL.FIRMANTES GT 0 THEN
        FOR FIR = 1 TO TOTAL.FIRMANTES
            Y.CONS.REL = Y.CONS.REL+1
            Y.IDTR = 4        ;* FIRMANTES
            Y.NombreTR = 'Firmantes'
            Y.NOMBRE.REL = FIR.NOM<FIR>
            Y.ApellidoPaterno = FIR.A.PAT<FIR>
            Y.ApellidoMaterno = FIR.A.MAT<FIR>
            IF Y.NOMBRE.REL EQ '' THEN
                Y.NOMBRE.REL = 'XXXXX'
            END
            Y.FEC.NAC.REL = FIR.NAC<FIR>
            IF Y.FEC.NAC.REL NE '' THEN
                Y.FEC.NAC.REL.I = Y.FEC.NAC.REL[1,4]:"-":Y.FEC.NAC.REL[5,2]:"-":Y.FEC.NAC.REL[7,2]
            END ELSE
                Y.FEC.NAC.REL.I = Y.FECHA.ALTA.REL.I
            END
            Y.RFC.ID.REL = FIR.RFC<FIR>
            IF Y.RFC.ID.REL EQ '' THEN
                Y.RFC.ID.REL = 'XXXXXXXXXXXXX'
            END
            GOSUB GENERA.REGISTRO.RELACIONADOS
        NEXT FIR
    END

RETURN


****************
ESCRIBE.ALERTA:
****************

    F.ERR.FILE = ''
    AGENT.ID    = EB.Service.getAgentNumber()
    AGENT.NUMBER  = TIMEDATE()
    AGENT.NUMBER = EREPLACE(AGENT.NUMBER,":",'')
    AGENT.NUMBER = EREPLACE(AGENT.NUMBER," ",'')
    RANDOM.NUMBER= RND(99999)
    AGENT.NUMBER := AGENT.ID:'_':RANDOM.NUMBER
    
    OPENSEQ Y.RUTA_ARCHIVO_XML_ERR:"ERROR.":AGENT.NUMBER TO F.ERR.FILE THEN
    END ELSE
        CREATE F.ERR.FILE ELSE
        END
    END
    Y.MSG<-1> = 'XML.REGISTRO.ALERTA--> ':XML.REGISTRO.ALERTA
    WRITESEQ XML.REGISTRO.ALERTA APPEND TO F.ERR.FILE ELSE
        DISPLAY " NO SE PUDO ESCRIBIR EN EL ARCHIVO DE ERROR:   " : XML.REGISTRO.ALERTA
    END
    CLOSESEQ F.ERR.FILE

RETURN


****************
ESCRIBE.ARCHIVO:
****************
    Y.DIA.EXTRACCION = EB.SystemTables.getToday()
*    Y.DIA.EXTRACCION = AbcCob.getYDiaExtraccionCB()
    Y.NOMBRE_ARCHIVO_XML_TEMP = Y.NOMBRE_ARCHIVO_XML        ;*NOMBRE DE ARCHIVO XML PARAMETRIZADO
    FINDSTR 'YYYYMMDD' IN Y.NOMBRE_ARCHIVO_XML SETTING Y.ENC.FECHA THEN
        CHANGE 'YYYYMMDD' TO Y.DIA.EXTRACCION IN Y.NOMBRE_ARCHIVO_XML_TEMP
    END

    FINDSTR 'NN' IN Y.NOMBRE_ARCHIVO_XML SETTING Y.ENC.CONSE THEN
        CHANGE 'NN' TO '_':AGENT.NUMBER IN Y.NOMBRE_ARCHIVO_XML_TEMP
    END
    Y.MSG<-1> = '////////Y.NOMBRE_ARCHIVO_XML_TEMP --> :':Y.NOMBRE_ARCHIVO_XML_TEMP
    GOSUB GENERA.XML
    GOSUB ESCRIBE.ARCHIVO.XML

    XML.REGISTRO=''


RETURN

***********
GENERA.XML:
***********

    Y.XML.ARCHIVO  =''
    Y.XML.ARCHIVO :=XML.REGISTRO
    CHANGE '&' TO '&amp;' IN Y.XML.ARCHIVO

RETURN

********************
ESCRIBE.ARCHIVO.XML:
********************
 
    F.XML.FILE = ''
    
    OPENSEQ Y.RUTA_ARCHIVO_XML_TEMP:Y.NOMBRE_ARCHIVO_XML_TEMP TO F.XML.FILE THEN
    END ELSE
        CREATE F.XML.FILE ELSE
        END
    END
   
    Y.FINAL = Y.XML.ARCHIVO
    Y.MSG<-1> = '////////Y.FINAL --> ':Y.FINAL
    
    WRITESEQ Y.FINAL APPEND TO F.XML.FILE ELSE
        DISPLAY " NO SE PUDO ESCRIBIR EN EL ARCHIVO XML:   " : Y.FINAL
        Y.BANDERA.XML=1
    END
    CLOSESEQ F.XML.FILE

    Y.XML.ARCHIVO=''
    Y.FINAL=''

RETURN


************************
GENERA.REGISTRO.CLIENTE:
************************

    Y.XML.CLIENTE  = ''
    Y.XML.CLIENTE := '<Cliente':Y.ESP
    Y.XML.CLIENTE := 'IdCliente="':Y.CUS.ID:'"':Y.ESP
    Y.XML.CLIENTE := 'IdTipoPersona="':Y.ITP:'"':Y.ESP
    Y.XML.CLIENTE := 'Nombre="':Y.NOMBRE.CLI:'"':Y.ESP
    Y.XML.CLIENTE := 'ApellidoPaterno="':Y.APEPAT:'"':Y.ESP
    Y.XML.CLIENTE := 'ApellidoMaterno="':Y.APEMAT:'"':Y.ESP
    Y.XML.CLIENTE := 'FechaNacConst="':Y.FECH.NAC.CONST.CLI.I:'"':Y.ESP
    Y.XML.CLIENTE := 'RfcTaxId="':Y.RFC.TAX.ID.CLI:'"':Y.ESP
    Y.XML.CLIENTE := 'FechaAlta="':Y.FECHA.ALTA.CLI.I:'"':Y.ESP
    Y.XML.CLIENTE := 'IdStatus="':Y.ID.STATUS.CLI:'"':Y.ESP
    Y.XML.CLIENTE := '>'
    Y.XML.CLIENTE := CHAR(10)

    Y.NOMBRE.CLI          =''
    Y.APEPAT =''
    Y.APEMAT =''
    Y.FECH.NAC.CONST.CLI   =''
    Y.RFC.TAX.ID.CLI        =''
    Y.FECHA.ALTA.CLI       =''
    Y.ID.STATUS.CLI          =''

RETURN

***********************
GENERA.REGISTRO.CUENTA:
***********************

    Y.XML.CUENTA  = ''
    Y.XML.CUENTA := '<Cuenta':Y.ESP
    Y.XML.CUENTA := 'IdCliente="':Y.CUS.ID:'"':Y.ESP
    Y.XML.CUENTA := 'Cuenta="':Y.ACC.ID:'"':Y.ESP
    Y.XML.CUENTA := 'Moneda="':Y.MONEDA:'"':Y.ESP
    Y.XML.CUENTA := 'IdServicioProducto="':Y.IDSP:'"':Y.ESP
    Y.XML.CUENTA := 'FechaAlta="':Y.FECHA.ALTA.REL.I:'"':Y.ESP
    Y.XML.CUENTA := 'IdStatus="':Y.ID.STATUS.ACC:'"':Y.ESP
    Y.XML.CUENTA := '/>'
    Y.XML.CUENTA := CHAR(10)
    Y.XML.CUENTA.TEMP := Y.XML.CUENTA

    Y.MONEDA                  =''
    Y.IDSP      =''
    Y.FECHA.ALTA.REL               =''
    Y.ID.STATUS.ACC                =''

RETURN

*****************************
GENERA.REGISTRO.RELACIONADOS:
*****************************

    Y.IdRelacionado    = Y.ACC.ID:Y.CONS.REL

    Y.XML.RELACIONADO  = ''
    Y.XML.RELACIONADO := '<Relacionado':Y.ESP
    Y.XML.RELACIONADO := 'IdCliente="':Y.CUS.ID:'"':Y.ESP
    Y.XML.RELACIONADO := 'IdRelacionado="':Y.IdRelacionado:'"':Y.ESP
    Y.XML.RELACIONADO := 'IdTipoRelacion="':Y.IDTR:'"':Y.ESP
    Y.XML.RELACIONADO := 'NombreTipoRelacion="':Y.NombreTR:'"':Y.ESP
    Y.XML.RELACIONADO := 'IdTipoPersona="':Y.ITP:'"':Y.ESP
    Y.XML.RELACIONADO := 'Nombre="':Y.NOMBRE.REL:'"':Y.ESP
    Y.XML.RELACIONADO := 'ApellidoPaterno="':Y.ApellidoPaterno:'"':Y.ESP
    Y.XML.RELACIONADO := 'ApellidoMaterno="':Y.ApellidoMaterno:'"':Y.ESP
    Y.XML.RELACIONADO := 'FechaNacConst="':Y.FEC.NAC.REL.I:'"':Y.ESP
    Y.XML.RELACIONADO := 'RfcTaxId="':Y.RFC.ID.REL:'"':Y.ESP
    Y.XML.RELACIONADO := 'FechaAlta="':Y.FECHA.ALTA.REL.I:'"':Y.ESP
    Y.XML.RELACIONADO := '/>'
    Y.XML.RELACIONADO := CHAR(10)
    Y.XML.RELACIONADO.TEMP :=Y.XML.RELACIONADO

    Y.IdRelacionado           =''
    Y.IDTR                    =''
    Y.NombreTR                =''
    Y.NOMBRE.REL              =''
    ApellidoPaterno           =''
    ApellidoMaterno           =''
    Y.FEC.NAC.REL             =''
    Y.FEC.NAC.REL.I           =''
    Y.RFC.ID.REL              =''

RETURN
*-----------------------------------------------------------------------------
SAVE.LOG:
*-----------------------------------------------------------------------------
    yDataLog<-1> = 'Termina registro ID : ' : Y.CUS.ID
    EB.AbcUtil.abcEscribeLogGenerico(yRtnName, yDataLog)

RETURN
END

