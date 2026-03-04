$PACKAGE AbcTeller
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.TRAE.DAT.CHQ
*===============================================================================
* Nombre de Programa : ABC.TRAE.DAT.CHQ
* Objetivo           : Rutina que llena los datos del cheque
*===============================================================================

    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcSpei
    $USING AbcTable
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    GOSUB INITIALIZE
    GOSUB PROCESS
    GOSUB FINALIZE

    RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    Y.ID.NEW = EB.SystemTables.getIdNew()

    FN.BANCOS = "F.ABC.BANCOS"
    F.BANCOS  = ""
    EB.DataAccess.Opf(FN.BANCOS,F.BANCOS)

    FN.TELLER = "F.TELLER"
    F.TELLER  = ""
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)

    FN.ABC.TMP.SIMULA.TT = "F.ABC.TMP.SIMULA.TT"
    F.ABC.TMP.SIMULA.TT  = ""
    EB.DataAccess.Opf(FN.ABC.TMP.SIMULA.TT,F.ABC.TMP.SIMULA.TT)

    FN.ABC.TMP.SIMULA.TT$NAU = "F.ABC.TMP.SIMULA.TT$NAU"
    F.ABC.TMP.SIMULA.TT$NAU  = ""
    EB.DataAccess.Opf(FN.ABC.TMP.SIMULA.TT$NAU,F.ABC.TMP.SIMULA.TT$NAU)

    FN.ABC.TMP.LECTORA.CHQ = "F.ABC.TMP.LECTORA.CHQ"
    F.ABC.TMP.LECTORA.CHQ  = ""
    EB.DataAccess.Opf(FN.ABC.TMP.LECTORA.CHQ,F.ABC.TMP.LECTORA.CHQ)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    EB.DataAccess.FRead(FN.ABC.TMP.LECTORA.CHQ,Y.ID.NEW,REC.ABC.TMP.LECTORA.CHQ,F.ABC.TMP.LECTORA.CHQ,CHQ.ERR)

    IF REC.ABC.TMP.LECTORA.CHQ THEN
        NO.CHEQUE = REC.ABC.TMP.LECTORA.CHQ<AbcTable.AbcTmpLectoraChq.CadenaChq>
        NO.CHEQUE.GIRA = FIELD(NO.CHEQUE,'<',2)
        Y.BANDA.CHEQUE = FIELD(NO.CHEQUE,'<',1)
        NO.CUENTA.GIRA = FIELD(Y.BANDA.CHEQUE,':',3)
        Y.ID.BANCO = FIELD(Y.BANDA.CHEQUE,':',2)
        Y.ID.BANCO3 = Y.ID.BANCO[6,3]
        AbcTeller.AbcRetornaTipoInst(Y.ID.BANCO3, OUT.TIPO.INST)
        Y.ID.BANCO = OUT.TIPO.INST:Y.ID.BANCO3

        Y.COD.SEG.CHQ    = NO.CHEQUE[1,3]
        Y.DIG.PREMARCADO = NO.CHEQUE[4,1]
        Y.CVE.TXN.CHQ    = NO.CHEQUE[6,2]
        Y.PLAZA.COMP.CHQ = NO.CHEQUE[8,3]
        Y.DIG.INTRCAM.CHQ= NO.CHEQUE[14,1]

        Y.SELECT.SIMULA.TT = "SELECT " :FN.ABC.TMP.SIMULA.TT: " WITH NO.CHEQUE.GIRADOR EQ " :DQUOTE(NO.CHEQUE.GIRA): " AND WITH  NO.CTA.GIRADOR EQ " :DQUOTE(NO.CUENTA.GIRA): " AND WITH NO.BANCO EQ " :DQUOTE(Y.ID.BANCO)
        
        EB.DataAccess.Readlist(Y.SELECT.SIMULA.TT,Y.LIST.SIMULA.TT,"",Y.NO.SIMULA.TT,Y.CO.SIMULA.TT)

        IF Y.NO.SIMULA.TT GE 1 THEN
            Y.ID.EXISTE.SIMULA = Y.LIST.SIMULA.TT<1,1>
            ETEXT = " Este Cheque ya se Capturo en la tabla: " :FN.ABC.TMP.SIMULA.TT :" Con el ID de registro: ": Y.ID.EXISTE.SIMULA
            EB.SystemTables.setEtext(ETEXT)
            EB.SystemTables.setE(ETEXT)
            EB.ErrorProcessing.StoreEndError()
        END ELSE
            Y.SELECT.SIMULA.TT$NAU = "SELECT " :FN.ABC.TMP.SIMULA.TT$NAU: " WITH NO.CHEQUE.GIRADOR EQ " :DQUOTE(NO.CHEQUE.GIRA): " AND WITH  NO.CTA.GIRADOR EQ " :DQUOTE(NO.CUENTA.GIRA): " AND WITH NO.BANCO EQ " :DQUOTE(Y.ID.BANCO)
            EB.DataAccess.Readlist(Y.SELECT.SIMULA.TT$NAU,Y.LIST.SIMULA.TT$NAU,"",Y.NO.SIMULA.TT$NAU,Y.CO.SIMULA.TT$NAU)
            IF Y.NO.SIMULA.TT$NAU GE 1 THEN
                Y.ID.EXISTE.SIMULA$NAU = Y.LIST.SIMULA.TT$NAU<1,1>
                ETEXT = " Este Cheque ya se Capturo en la tabla: " :FN.ABC.TMP.SIMULA.TT$NAU :" Con el ID de registro: ": Y.ID.EXISTE.SIMULA$NAU
                EB.SystemTables.setEtext(ETEXT)
                EB.SystemTables.setE(ETEXT)
                EB.ErrorProcessing.StoreEndError()
            END ELSE
                Y.SELECT.TT = "SELECT " :FN.TELLER: " WITH DRAW.CHQ.NO EQ " :DQUOTE(NO.CHEQUE.GIRA): " AND WITH  DRAW.ACCT.NO EQ " :DQUOTE(NO.CUENTA.GIRA): " AND WITH DRAW.BANK EQ " :DQUOTE(Y.ID.BANCO)
                EB.DataAccess.Readlist(Y.SELECT.TT,Y.LIST.TT,"",Y.NO.TT,Y.CO.TT)

                IF Y.NO.TT GE 1 THEN
                    Y.ID.EXISTE = Y.LIST.TT<1,1>
                    ETEXT = " Este Cheque ya se Capturo en la tabla: " :FN.TELLER :" Con el ID de registro: ": Y.ID.EXISTE
                    EB.SystemTables.setEtext(ETEXT)
                    EB.SystemTables.setE(ETEXT)
                    EB.ErrorProcessing.StoreEndError()
                END ELSE
                    EB.DataAccess.FRead(FN.BANCOS,Y.ID.BANCO,REC.BANCOS,F.BANCOS,ERR.BANCOS)
                    IF REC.BANCOS THEN
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.NoChequeGirador, NO.CHEQUE.GIRA)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.NoCtaGirador, NO.CUENTA.GIRA)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.NoBanco, Y.ID.BANCO)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.CodSegChq, Y.COD.SEG.CHQ)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.DigPremarcado, Y.DIG.PREMARCADO)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.CveTxnChq, Y.CVE.TXN.CHQ)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.PlazaCompChq, Y.PLAZA.COMP.CHQ)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.DigIntrcamChq, Y.DIG.INTRCAM.CHQ)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.DigIntrcamChq, Y.DIG.INTRCAM.CHQ)
                        EB.SystemTables.setRNew(AbcTable.AbcTmpSimulaTt.IdImgChq, Y.ID.BANCO3:NO.CUENTA.GIRA:NO.CHEQUE.GIRA:"f.TIF")
                    END ELSE
                        ETEXT = "ERROR EN LOS DATOS DEL CHEQUE"
                        EB.SystemTables.setEtext(ETEXT)
                        EB.SystemTables.setE(ETEXT)
                        EB.ErrorProcessing.StoreEndError()
                    END
                END
            END
        END
    END ELSE
        ETEXT = "EL REGISTRO: ":Y.ID.NEW:" NO EXISTE EN LA TABLA ABC.TMP.LECTORA.CHQ"
        EB.SystemTables.setEtext(ETEXT)
        EB.SystemTables.setE(ETEXT)
        EB.ErrorProcessing.StoreEndError()
    END
    RETURN

*-----------------------------------------------------------------------------
FINALIZE:
*-----------------------------------------------------------------------------

    RETURN

END
