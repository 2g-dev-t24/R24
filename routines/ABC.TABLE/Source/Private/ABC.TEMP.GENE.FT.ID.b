* @ValidationCode : MjotODA0MDMwODE6Q3AxMjUyOjE3NTkyNTQxMDg2OTk6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 30 Sep 2025 14:41:48
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
$PACKAGE AbcTable
SUBROUTINE ABC.TEMP.GENE.FT.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.Display
    $USING EB.Updates
    $USING EB.Interface
    
    
    $USING AbcTable
*-----------------------------------------------------------------------------
    DEFFUN System.setVariable()
    GOSUB INITIALISE
    GOSUB CHECK.ID
    System.setVariable('Y.AUTHID.NUEVO.REVE',Y.AUTHID.NUEVO.REVE)
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ''
    EB.DataAccess.Opf(FN.FT,F.FT)

    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FT.HIS = ''
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)

    FN.GENE = "F.ABC.TEMP.GENE.FT"
    F.GENE = ''
    EB.DataAccess.Opf(FN.GENE,F.GENE)

    FN.ACLK = "F.AC.LOCKED.EVENTS"
    F.ACLK = ''
    EB.DataAccess.Opf(FN.ACLK,F.ACLK)

    FN.ABC.PEND.GALILEO = "F.ABC.PENDIENTES.GALILEO"
    F.ABC.PEND.GALILEO = ""
    EB.DataAccess.Opf(FN.ABC.PEND.GALILEO, F.ABC.PEND.GALILEO)

    FN.ABC.CONCAT.GALILEO = "F.ABC.CONCAT.GALILEO"
    F.ABC.CONCAT.GALILEO = ""
    EB.DataAccess.Opf(FN.ABC.CONCAT.GALILEO, F.ABC.CONCAT.GALILEO)
    
    LREF.TABLE = "FUNDS.TRANSFER":@FM:"AC.LOCKED.EVENTS"
    LREF.FIELD = "ORIG.AMOUNT":@VM:"ORIG.CURRENCY":@VM:"COMISION":@VM:"TIPO.CAMB":@VM:"AUTH.ID":@FM:"AT.UNIQUE.ID":@VM:"AT.AUTH.CODE":@VM:"ORIG.AMOUNT":@VM:"ORIG.CURRENCY":@VM:"TIPO.CAMB":@VM:"MCC":@VM:"COMISION":@VM:"AUTH.ID"
    EB.Updates.MultiGetLocRef(LREF.TABLE, LREF.FIELD, LREF.POS)
    POS.ORIG.MONTO     = LREF.POS<1,1>
    POS.ORIG.CURRN     = LREF.POS<1,2>
    POS.COMI.CAJERO    = LREF.POS<1,3>
    POS.TIPO.CAMBG     = LREF.POS<1,4>
    POS.AUTH.IDFT      = LREF.POS<1,5>
    POS.UNIQUE.ID      = LREF.POS<2,1>
    POS.AUTH.CODE      = LREF.POS<2,2>
    POS.ORIG.MONTO.AC  = LREF.POS<2,3>
    POS.ORIG.CURRN.AC  = LREF.POS<2,4>
    POS.TIPO.CAMB.AC   = LREF.POS<2,5>
    POS.MCC            = LREF.POS<2,6>
    POS.ACLK.COMIS     = LREF.POS<2,7>
    POS.ACLK.AUTHID    = LREF.POS<2,8>

RETURN
*-----------------------------------------------------------------------------
CHECK.ID:
*----------------------------------------------------------------------------
* Validation and changes of the ID entered.  Sets V$ERROR to 1 if in error.

    EB.SystemTables.setE('')
    ID.FT.C = EB.SystemTables.getComi()
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    IF Y.V.FUNCTION EQ "S" THEN
        GOSUB VAL.ID.ACLK.FT
    END ELSE
        GOSUB VAL.ID.ACLK.FT
        IF ID.FT.C[1,2] EQ 'FT' THEN
            EB.DataAccess.FRead(FN.FT, ID.FT.C, REC.FT, F.FT, ERR.FT)
            Y.AUTHID.NUEVO.REVE = REC.FT<FT.Contract.FundsTransfer.LocalRef, POS.AUTH.IDFT>
            IF NOT(REC.FT) THEN
                EB.DataAccess.FRead(FN.GENE, ID.FT.C, REC.GENE, F.GENE, ERR.GENE)
                IF REC.GENE THEN
                    J.STATUS = REC.GENE<AbcTable.AbcTempGeneFt.Status>
                    IF J.STATUS EQ "GENERADO" THEN
                        EB.SystemTables.setE("TRANSFERENCIA REVERSADA Y GENERADA")
                    END
                END ELSE
                    EB.SystemTables.setE("LA TRANSFERENCIA NO EXISTE")
                END
            END
        END ELSE
            IF ID.FT.C[1,4] EQ 'ACLK' THEN
                EB.DataAccess.FRead(FN.ACLK, ID.FT.C, REC.ACLK, F.ACLK, ERR.ACLK)
                Y.AUTHID.NUEVO.REVE = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ACLK.AUTHID>
                IF NOT(REC.ACLK) THEN
                    EB.DataAccess.FRead(FN.GENE, ID.FT.C, REC.GENE, F.GENE, ERR.GENE)
                    IF REC.GENE THEN
                        J.STATUS = REC.GENE<AbcTable.AbcTempGeneFt.Status>
                        IF (J.STATUS EQ "GENERADO") OR (J.STATUS EQ "REVERSADO") THEN
                            EB.SystemTables.setE("BLOQUEO REVERSADO")
                        END
                    END ELSE
                        EB.SystemTables.setE("EL BLOQUEO NO EXISTE")
                    END
                END
            END
        END
    END

    IF EB.SystemTables.getE() THEN
        EB.ErrorProcessing.Err()
    END

RETURN
*-----------------------------------------------------------------------------
VAL.ID.ACLK.FT:
*-----------------------------------------------------------------------------

    Y.VERSION = '' ; Y.VRSNS.AUTHID.BLOQ = '' ; Y.VRSNS.POS = '' ; Y.VRSINS.ATM = ''
    REC.AUTHID = '' ; Y.ESTATUS.AUTHID = ''
    Y.GUARDA.AUTHID.REVE = '' ; Y.EXISTE.REVE = ''
    Y.VERSION = EB.SystemTables.getPgmVersion()
    Y.VRSN.APLI.POS = ",APLICA.COMPRA.MC"
    Y.VRSN.REVE.POS = ",REVERSO.COMPRA.MC"
    Y.VRSN.APLI.ATM = ",APLICA.RETIRO.ATM.MC"
    Y.VRSN.REVE.ATM = ",REVERSO.ATM.MC"
    Y.VRSNS.REVE.BLOQ = Y.VRSN.REVE.POS : @VM : Y.VRSN.REVE.ATM
    Y.VRSNS.AUTHID.BLOQ  = Y.VRSN.APLI.ATM : @VM : Y.VRSN.APLI.POS : @VM
    Y.VRSNS.AUTHID.BLOQ := Y.VRSNS.REVE.BLOQ
    Y.VRSNS.POS = Y.VRSN.APLI.POS : @VM : Y.VRSN.REVE.POS
    Y.VRSINS.ATM = Y.VRSN.APLI.ATM : @VM : Y.VRSN.REVE.ATM

    IF ((ID.FT.C[1,2] NE 'FT') AND (ID.FT.C[1,4] NE 'ACLK')) AND (Y.VERSION MATCHES Y.VRSNS.AUTHID.BLOQ) THEN

        OFS.RECIBIDO = EB.Interface.getOfsParentReq()
        Y.MONTO.REVE.PARCIAL = FIELD(OFS.RECIBIDO,'MONTO.REV.PARCIAL',2)
        Y.MONTO.REVE.PARCIAL = FIELD(FIELD(Y.MONTO.REVE.PARCIAL, ',', 1), '=', 2)
        Y.AUTH.ID.ORIGINAL = FIELD(OFS.RECIBIDO,'ORIG.AUTH.ID',2)
        Y.AUTH.ID.ORIGINAL = FIELD(FIELD(Y.AUTH.ID.ORIGINAL,',', 1),'=',2)

        Y.A.ORIG.AMOUNT.REV = FIELD(OFS.RECIBIDO,'ORIG.AMOUNT',2)
        Y.A.ORIG.AMOUNT.REV = FIELD(FIELD(Y.A.ORIG.AMOUNT.REV,',', 1),'=',2)

        IF Y.VERSION EQ Y.VRSN.REVE.POS AND (Y.MONTO.REVE.PARCIAL NE '') AND (Y.AUTH.ID.ORIGINAL NE '') AND (Y.MONTO.REVE.PARCIAL NE '0') AND (Y.AUTH.ID.ORIGINAL NE '0') THEN
            Y.AUTHID.NUEVO.REVE = ID.FT.C
            AUTH.ID.AUX = Y.AUTH.ID.ORIGINAL
            GOSUB VALIDA.EXISTE.ORIG.AUTHID

            IF Y.ERROR.EXISTE.ORIG.AUTHID NE '' THEN
                EB.SystemTables.setE(Y.ERROR.EXISTE.ORIG.AUTHID)
            END

            GOSUB VALIDA.ESTATUS.AUTHID
            IF Y.ERROR.ESTATUS NE '' THEN
                EB.SystemTables.setE(Y.ERROR.ESTATUS)
            END

            AUTH.ID.AUX = Y.AUTHID.NUEVO.REVE
            GOSUB VALIDA.ESTATUS.AUTHID
            IF Y.ERROR.ESTATUS NE '' THEN
                EB.SystemTables.setE(Y.ERROR.ESTATUS)
                RETURN
            END
            GOSUB VALIDA.EXISTE.REVE.PAR.PEND

            AUTH.ID.AUX = Y.AUTH.ID.ORIGINAL


            IF (Y.EXISTE.AUTH.ID EQ 'NO') AND (Y.EXISTE.AUTH.ID.REVE.PAR EQ 'NO') THEN
                Y.AUTH.ID.PEND = "REVE.":Y.AUTHID.NUEVO.REVE
                Y.ID.ACLK = "SIN BLOQUEO"
                TRANSACTION.TYPE = "REV PARCIAL POS"
                ID.ACC = Y.AUTH.ID.ORIGINAL
                A.DEBIT.AMOUNT = Y.MONTO.REVE.PARCIAL
                A.ORIG.AMOUNT = Y.A.ORIG.AMOUNT.REV
                Y.FECHA.APL = OCONV(DATE(),'DY4'):FMT(OCONV(DATE(),"DM"),"2'0'R"):FMT(OCONV(DATE(),"DD"),"2'0'R")
                Y.ESTATUS.GUARDA.PEND = "REV PARCIAL PEND"
                Y.MSG.ERR = "1_REVERSO PARCIAL SIN ACLK"
                Y.SAVE.AUDIT.FLDS = 1

*GOSUB GUARDA.APLC.PENDIENTE
                EB.SystemTables.setE("NO EXISTE BLOQUEO PARA AUTH.ID " : Y.AUTH.ID.ORIGINAL)

                RETURN
            END
            ID.FT.C = Y.AUTH.ID.ORIGINAL
        END
        Y.AUTHID.NUEVO.REVE = ID.FT.C
        AUTH.ID.ACLK = ID.FT.C
        AUTH.ID.AUX = AUTH.ID.ACLK
        GOSUB VALIDA.ESTATUS.AUTHID
        IF Y.ERROR.ESTATUS NE '' THEN
            EB.SystemTables.setE(Y.ERROR.ESTATUS)
            RETURN
        END

        IF REC.AUTHID THEN
            Y.FT.GENERADO = REC.AUTHID<AbcTable.AbcConcatGalile.FtGenerado>
            ID.FT.C = REC.AUTHID<AbcTable.AbcConcatGalile.AclkId>
            GOSUB VALIDA.TIPO.BLOQUEO
            EB.SystemTables.setIdNew(ID.FT.C)
            RETURN
        END ELSE

            IF Y.VERSION MATCHES Y.VRSNS.REVE.BLOQ THEN
                GOSUB VALIDA.EXISTE.REVE
                IF Y.EXISTE.REVE EQ 1 THEN
                    EB.SystemTables.setE("REVERSO DE BLOQUEO YA RECIBIDO")
                END ELSE
                    Y.GUARDA.AUTHID.REVE = "SI"
                END
            END ELSE
                EB.SystemTables.setE("NO EXISTE BLOQUEO PARA AUTH.ID INGRESADO")
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXISTE.ORIG.AUTHID:
*-----------------------------------------------------------------------------

    Y.EXISTE.AUTH.ID = ''
    EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, Y.AUTH.ID.ORIGINAL, REC.AUTHID, F.ABC.CONCAT.GALILEO, ERR.AUTHID)
    IF NOT(REC.AUTHID) THEN
        Y.ERROR.EXISTE.ORIG.AUTHID = "NO EXISTE BLOQUEO PARA AUTH.ID " : Y.AUTH.ID.ORIGINAL
        Y.EXISTE.AUTH.ID = 'NO'
        RETURN
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXISTE.REVE.PAR.PEND:
*-----------------------------------------------------------------------------

    Y.EXISTE.AUTH.ID.REVE.PAR = '' ; REC.AUTHID.PEND = ''
    EB.DataAccess.FRead(FN.ABC.PEND.GALILEO, Y.AUTH.ID.ORIGINAL, REC.AUTHID.PEND, F.ABC.PEND.GALILEO, ERR.AUTHID.PEND)
    IF NOT(REC.AUTHID.PEND) THEN
        Y.EXISTE.AUTH.ID.REVE.PAR = 'NO'
        RETURN
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.ESTATUS.AUTHID:
*-----------------------------------------------------------------------------

    Y.ERROR.ESTATUS = ''
    EB.DataAccess.FRead(FN.ABC.CONCAT.GALILEO, AUTH.ID.AUX, REC.AUTHID, F.ABC.CONCAT.GALILEO, ERR.AUTHID)
    IF REC.AUTHID THEN
        Y.ESTATUS.AUTHID = REC.AUTHID<AbcTable.AbcConcatGalile.Estatus>
        IF (Y.ESTATUS.AUTHID NE "PENDIENTE") AND (Y.ESTATUS.AUTHID NE "") AND (Y.ESTATUS.AUTHID NE 'REVERSO PARCIAL') THEN
            Y.ERROR.ESTATUS = "AUTH.ID " : AUTH.ID.AUX : " YA REGISTRADO CON ESTATUS: " : Y.ESTATUS.AUTHID
            RETURN
        END
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.TIPO.BLOQUEO:
*-----------------------------------------------------------------------------

    Y.TIPO.BLOQ = ''

    IF Y.VERSION MATCHES Y.VRSNS.POS THEN
        Y.TIPO.BLOQ = "ACTD"
    END

    IF Y.VERSION MATCHES Y.VRSINS.ATM THEN
        Y.TIPO.BLOQ = "ACAT"
    END

    ID.ACLK = ID.FT.C
    ACLK.FILE = FN.ACLK
    GOSUB LEE.REC.ACLK
    IF (TRANSACTION.TYPE NE Y.TIPO.BLOQ) AND (TRANSACTION.TYPE NE "") THEN
        EB.SystemTables.setE("TIPO DE TRANSACCION NO PERMITIDA")
    END

RETURN
*-----------------------------------------------------------------------------
VALIDA.EXISTE.REVE:
*-----------------------------------------------------------------------------

    Y.REG.REVE = ''
    EB.DataAccess.FRead(FN.ABC.PEND.GALILEO, AUTH.ID.ACLK, Y.REG.REVE, F.ABC.PEND.GALILEO, ERR.AUTHID.PEND)
    IF Y.REG.REVE THEN
        Y.EXISTE.REVE = 1
    END

RETURN

*-------------------------------------
LEE.REC.ACLK:
*-------------------------------------

    EB.DataAccess.FRead(FN.ACLK, ID.ACLK, REC.ACLK, F.ACLK, ERR.ACLK)
    IF REC.ACLK THEN
        
        TRANSACTION.TYPE = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.UNIQUE.ID>
        Y.TIPO.BLOQUEO = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.AUTH.CODE>
        ID.ACC = REC.ACLK<AC.AccountOpening.LockedEvents.LckAccountNumber>
        J.DESC = REC.ACLK<AC.AccountOpening.LockedEvents.LckDescription>
        LOC.AMT = REC.ACLK<AC.AccountOpening.LockedEvents.LckLockedAmount>

        ACLK.ORIG.AMOUNT = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ORIG.MONTO.AC>
        ACLK.ORIG.CURRENCY = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ORIG.CURRN.AC>
        ACLK.TIPO.CAMBIO = LOC.AMT / ACLK.ORIG.AMOUNT       ;*SE VUELVE A CALCULAR TIPO DE CAMBIO DE BLOQUEO
        ACLK.MCC = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.MCC>


        ACLK.COMISION = REC.ACLK<AC.AccountOpening.LockedEvents.LckLocalRef, POS.ACLK.COMIS>

        ACLK.DATE=REC.ACLK<AC.AccountOpening.LockedEvents.LckFromDate>
        J.DESC=EREPLACE (J.DESC,CHAR(34),"")
        J.DESC.DET= J.DESC:"*FECHA OPERACION*":ACLK.DATE
        J.DESC=J.DESC[1,35]


    END
RETURN

END