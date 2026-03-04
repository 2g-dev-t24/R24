* @ValidationCode : MjotMzY5NzgwODczOkNwMTI1MjoxNzU3Mzg2OTAzNzgwOkx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Sep 2025 00:01:43
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

$PACKAGE AbcTeller

SUBROUTINE ABC.TRAE.DATOS.LECTORA(Y.ID.ACCT)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    $USING TT.Contract
    $USING AbcTable
    $USING AbcSpei
    $USING EB.Updates
    $USING AbcTeller
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.SEPA1 = ":"
    Y.SEPA2 = "<"
    Y.SEPA3 = "."
    Y.APPL  = "TELLER"

    Y.NUM.BNK           = ""
    Y.NOM.ARCH.B        = ""
    Y.NOM.ARCH.F        = ""
    Y.CVE.TXN.CHQ       = ""
    Y.COD.SEG.CHQ       = ""
    Y.DRAW.CHQ.NO       = ""
    Y.DRAW.ACCT.NO      = ""
    Y.DIG.PREMARCADO    = ""
    Y.PLAZA.COMP.CHQ    = ""
    Y.DIG.INTRCAM.CHQ   = ""

    FN.TMP.LEC = "F.ABC.TMP.LECTORA.CHQ"
    F.TMP.LEC  = ""
    EB.DataAccess.Opf(FN.TMP.LEC,F.TMP.LEC)

    FN.BANCOS = "FBNK.ABC.BANCOS"
    F.BANCOS  = ""
    EB.DataAccess.Opf(FN.BANCOS,F.BANCOS)

* Obtengo Posicion en Campos Locales.
    Y.APP       = "TELLER"
    Y.FLD       = "DRAW.CHQ.NO" :@VM: "DRAW.ACCT.NO" :@VM: "DRAW.BANK" :@VM: "COD.SEG.CHQ" :@VM: "DIG.PREMARCADO" :@VM: "CVE.TXN.CHQ" :@VM: "PLAZA.COMP.CHQ" :@VM: "DIG.INTRCAM.CHQ"
    Y.POS.FLD   = ''
    EB.Updates.MultiGetLocRef(Y.APP, Y.FLD, Y.POS.FLD)
    
    Y.POS.DRAW.CHQ.NO     = Y.POS.FLD<1,1>
    Y.POS.DRAW.ACCT.NO    = Y.POS.FLD<1,2>
    Y.POS.DRAW.BANK       = Y.POS.FLD<1,3>
    Y.POS.COD.SEG.CHQ     = Y.POS.FLD<1,4>
    Y.POS.DIG.PREMARCADO  = Y.POS.FLD<1,5>
    Y.POS.CVE.TXN.CHQ     = Y.POS.FLD<1,6>
    Y.POS.PLAZA.COMP.CHQ  = Y.POS.FLD<1,7>
    Y.POS.DIG.INTRCAM.CHQ = Y.POS.FLD<1,8>
    
    OPERATOR = EB.SystemTables.getOperator()
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.MODULO    = "IP.CAJA"
    Y.SEPARADOR = "#"
    Y.OPERATOR = OPERATOR

    Y.CAMPOS:= Y.OPERATOR : Y.SEPARADOR
    AbcSpei.AbcTraeGeneralParam(Y.MODULO, Y.CAMPOS, Y.DATOS)
    Y.ID.TMP.LEC = FIELD(Y.DATOS,Y.SEPARADOR,1)

    REC.ACCT = AC.AccountOpening.Account.Read(Y.ID.ACCT, ERR.ACCT)
    
    TT.TE.LOCAL.REF = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)

    IF ERR.ACCT THEN
* Elimino la inforacion del cheque si no existe el banco
        COMI = ""
        EB.SystemTables.setComi(COMI)
        TT.TE.LOCAL.REF<1,Y.POS.DRAW.CHQ.NO>    = ""
        TT.TE.LOCAL.REF<1,Y.POS.DRAW.ACCT.NO>   = ""
        TT.TE.LOCAL.REF<1,Y.POS.DRAW.BANK>      = ""
        TT.TE.LOCAL.REF<1,Y.POS.COD.SEG.CHQ>    = ""
        TT.TE.LOCAL.REF<1,Y.POS.DIG.PREMARCADO> = ""
        TT.TE.LOCAL.REF<1,Y.POS.CVE.TXN.CHQ>    = ""
        TT.TE.LOCAL.REF<1,Y.POS.PLAZA.COMP.CHQ> = ""
        TT.TE.LOCAL.REF<1,Y.POS.DIG.INTRCAM.CHQ>= ""
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.TE.LOCAL.REF)

        EXECUTE "delete " : FN.TMP.LEC : " "     : Y.ID.TMP.LEC
        EXECUTE "clear.file " : FN.TMP.LEC : "$HIS "        ;* : Y.ID.TMP.LEC : ";1"

        ETEXT = "La Cuenta Numero: ": Y.ID.ACCT :" no Existe"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        EB.DataAccess.FRead(FN.TMP.LEC,Y.ID.TMP.LEC,REC.TMP.LEC,F.TMP.LEC,ERR.TMP.LEC)

        IF ERR.TMP.LEC THEN
            Y.DATO.CHEQ = TT.TE.LOCAL.REF<1,Y.POS.DRAW.CHQ.NO>

            IF Y.DATO.CHEQ EQ "" THEN
                COMI  = ""
                EB.SystemTables.setComi(COMI)
                ETEXT = "Se debe Escanear Primero el Cheque"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE

            Y.CADENA.CHEQ = REC.TMP.LEC<AbcTable.AbcTmpLectoraChq.CadenaChq>

            Y.COD.SEG.CHQ    = Y.CADENA.CHEQ[1,3]
            Y.DIG.PREMARCADO = Y.CADENA.CHEQ[4,1]
            Y.CVE.TXN.CHQ    = Y.CADENA.CHEQ[6,2]
            Y.PLAZA.COMP.CHQ = Y.CADENA.CHEQ[8,3]
            Y.DIG.INTRCAM.CHQ= Y.CADENA.CHEQ[14,1]

            Y.SECC1 = FIELD(Y.CADENA.CHEQ,Y.SEPA2,1)
            Y.SECC2 = FIELD(Y.CADENA.CHEQ,Y.SEPA2,2)

            Y.DRAW.CHQ.NO  = Y.SECC2
            Y.DRAW.ACCT.NO = FIELD(Y.SECC1,Y.SEPA1,3)

            Y.VAL2.SECC1 = FIELD(Y.SECC1,Y.SEPA1,2)
            Y.NUM.BNK    = Y.VAL2.SECC1[6,3]

* El numero 40 es el ID para bancos en la tabla ABC.BANCOS
            AbcTeller.AbcRetornaTipoInst(Y.NUM.BNK, OUT.TIPO.INST)
            Y.ID.BANCOS = OUT.TIPO.INST: Y.NUM.BNK
            EB.DataAccess.FRead(FN.BANCOS,Y.ID.BANCOS,REC.BANCOS,F.BANCOS,ERR.BANCOS)

            IF ERR.BANCOS THEN
* Elimino la inforacion del cheque si no existe el banco
                TT.TE.LOCAL.REF<1,Y.POS.DRAW.CHQ.NO>    = ""
                TT.TE.LOCAL.REF<1,Y.POS.DRAW.ACCT.NO>   = ""
                TT.TE.LOCAL.REF<1,Y.POS.DRAW.BANK>      = ""
                TT.TE.LOCAL.REF<1,Y.POS.COD.SEG.CHQ>    = ""
                TT.TE.LOCAL.REF<1,Y.POS.DIG.PREMARCADO> = ""
                TT.TE.LOCAL.REF<1,Y.POS.CVE.TXN.CHQ>    = ""
                TT.TE.LOCAL.REF<1,Y.POS.PLAZA.COMP.CHQ> = ""
                TT.TE.LOCAL.REF<1,Y.POS.DIG.INTRCAM.CHQ>= ""
                EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.TE.LOCAL.REF)
                
                COMI = ""
                EB.SystemTables.setComi(COMI)
                
                EXECUTE "delete " : FN.TMP.LEC : " "     : Y.ID.TMP.LEC
                EXECUTE "clear.file " : FN.TMP.LEC : "$HIS "          ;* : Y.ID.TMP.LEC : ";1"

                ETEXT = " El Banco Numero: ": Y.ID.BANCOS : " no esta Dado de Alta en ABC.BANCOS"
                EB.SystemTables.setEtext(ETEXT)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END ELSE
                Y.DRAW.BANK = Y.ID.BANCOS
            END

* Asigno los valores a los Campos Conforme a los Datos de la cadena del Cheque
            TT.TE.LOCAL.REF<1,Y.POS.DRAW.CHQ.NO>    = Y.DRAW.CHQ.NO
            TT.TE.LOCAL.REF<1,Y.POS.DRAW.ACCT.NO>   = Y.DRAW.ACCT.NO
            TT.TE.LOCAL.REF<1,Y.POS.DRAW.BANK>      = Y.DRAW.BANK
            TT.TE.LOCAL.REF<1,Y.POS.COD.SEG.CHQ>    = Y.COD.SEG.CHQ
            TT.TE.LOCAL.REF<1,Y.POS.DIG.PREMARCADO> = Y.DIG.PREMARCADO
            TT.TE.LOCAL.REF<1,Y.POS.CVE.TXN.CHQ>    = Y.CVE.TXN.CHQ
            TT.TE.LOCAL.REF<1,Y.POS.PLAZA.COMP.CHQ> = Y.PLAZA.COMP.CHQ
            TT.TE.LOCAL.REF<1,Y.POS.DIG.INTRCAM.CHQ>= Y.DIG.INTRCAM.CHQ
            EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.TE.LOCAL.REF)

* Armo el Nombre y doy Permisos a los Archivos Creados.
            Y.NOM.ARCH.B = Y.NUM.BNK : Y.DRAW.ACCT.NO : Y.DRAW.CHQ.NO : "b.TIF"
            Y.NOM.ARCH.F = Y.NUM.BNK : Y.DRAW.ACCT.NO : Y.DRAW.CHQ.NO : "f.TIF"

            EXECUTE "chmod 777 ../../ArchivosT24/CECOBAN/ImagenesSuc/":Y.NOM.ARCH.F
            EXECUTE "chmod 777 ../../ArchivosT24/CECOBAN/ImagenesSuc/":Y.NOM.ARCH.B
        END
    END
    
RETURN
*-----------------------------------------------------------------------------
END