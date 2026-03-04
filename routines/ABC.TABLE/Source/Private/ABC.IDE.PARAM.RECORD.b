* @ValidationCode : MjotNzE5ODM4MjY6Q3AxMjUyOjE3NTk3ODc0NDczNjg6THVpcyBDYXByYTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Oct 2025 18:50:47
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

SUBROUTINE ABC.IDE.PARAM.RECORD
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    AF = EB.SystemTables.getAf()
    COMI = EB.SystemTables.getComi()
    BEGIN CASE
        CASE AF = AbcTable.AbcIdeParam.TipoPersona
            IF COMI = "PM" THEN
                EB.SystemTables.setComiEnri("PERSONA MORAL")
            END ELSE
                IF COMI = "PF" THEN
                    EB.SystemTables.setComiEnri("PERSONA FISICA")
                END
            END

    END CASE

    STR.TIPO = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.TipoPersona)
    NO.TIPO = DCOUNT(STR.TIPO, @VM)
    Y.TIPO = ""
    FOR I.TIPO = 1 TO NO.TIPO
        Y.CNT.TIPO = 0
        Y.TIPO = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.TipoPersona)<1, I.TIPO>
        Y.CNT.TIPO = COUNT(STR.TIPO, Y.TIPO)
        IF Y.CNT.TIPO > 1 THEN
            ETEXT = "TIPO DE PERSONA DUPLICADO"
            EB.SystemTables.setEtext(ETEXT)
            EB.ErrorProcessing.StoreEndError()
            BREAK
        END
    NEXT
    Y.MTO.ANT = EB.SystemTables.getROld(AbcTable.AbcIdeParam.MtoLimite)
    Y.PRC.ANT = EB.SystemTables.getROld(AbcTable.AbcIdeParam.PorcCobro)
    Y.MTO.NVO = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.MtoLimite)
    Y.PRC.NVO = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcCobro)
    TODAY   = EB.SystemTables.getToday()
    IF Y.PRC.ANT AND Y.MTO.ANT THEN
        IF (Y.MTO.ANT <> Y.MTO.NVO OR Y.PRC.ANT <> Y.PRC.NVO) THEN
            IF DCOUNT(EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcCobroFec),VM) > 0 THEN
                Y.COBROFEC.NEW = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcCobroFec)
                Y.COBROFEC.NEW<1,1> = TODAY
                Y.COBROFEC.NEW<1,2> = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcCobroFec)
                EB.SystemTables.setRNew(AbcTable.AbcIdeParam.PorcCobroFec,Y.COBROFEC.NEW)
                
                Y.LIMITE.NEW = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcLimite)
                Y.LIMITE.NEW<1,1> = Y.MTO.ANT
                Y.LIMITE.NEW<1,2> = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcLimite)
                EB.SystemTables.setRNew(AbcTable.AbcIdeParam.PorcLimite,Y.LIMITE.NEW)

                Y.COBRO.HIS.NEW = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcCobroHis)
                Y.COBRO.HIS.NEW<1,1> = Y.PRC.ANT
                Y.COBRO.HIS.NEW<1,2> = EB.SystemTables.getRNew(AbcTable.AbcIdeParam.PorcCobroHis)
                EB.SystemTables.setRNew(AbcTable.AbcIdeParam.PorcCobroHis,Y.COBRO.HIS.NEW)

            END ELSE
                EB.SystemTables.setRNew(AbcTable.AbcIdeParam.PorcCobroFec,TODAY)
                EB.SystemTables.setRNew(AbcTable.AbcIdeParam.PorcLimite,Y.MTO.ANT)
                EB.SystemTables.setRNew(AbcTable.AbcIdeParam.PorcCobroHis,Y.PRC.ANT)
            END
        END
    END


RETURN
END
