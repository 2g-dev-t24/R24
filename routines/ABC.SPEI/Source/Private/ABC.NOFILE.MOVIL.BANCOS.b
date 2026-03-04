* @ValidationCode : MjoyNDY0MTM4Mzk6Q3AxMjUyOjE3NTk4ODYxNTI0MTg6bWF1cmljaW8ubG9wZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Oct 2025 22:15:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcSpei

SUBROUTINE ABC.NOFILE.MOVIL.BANCOS(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.Template
    
    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB FINAL
    
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

    FN.LOOKUP    = 'F.EB.LOOKUP'
    F.LOOKUP    = ''
    EB.DataAccess.Opf(FN.LOOKUP,F.LOOKUP)

    SEL.FIELDS              = EB.Reports.getDFields()
    SEL.VALUES              = EB.Reports.getDRangeAndValue()

    R.DATA = ''
    Y.SEP = '*'

    Y.POS = ''
    Y.TIPO.SEL = ''
    Y.BAN.STATUS.SEL = ''
    Y.LOOKUP.ID.SEL = ''

    LOCATE 'TIPO' IN SEL.FIELDS<1,1> SETTING Y.POS THEN
        Y.TIPO.SEL = SEL.VALUES<1,Y.POS.TIPO>
    END

    Y.POS = ''

    LOCATE 'BAN.STATUS' IN SEL.FIELDS<1,1> SETTING Y.POS THEN
        Y.BAN.STATUS.SEL = SEL.VALUES<1,Y.POS.TIPO>
    END

    Y.POS = ''

    LOCATE 'LOOKUP.ID' IN SEL.FIELDS<1,1> SETTING Y.POS THEN
        Y.LOOKUP.ID.SEL = SEL.VALUES<1,Y.POS.TIPO>
    END

RETURN

*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------

    IF Y.LOOKUP.ID.SEL THEN
        Y.SEL.CMD = "SELECT " : FN.LOOKUP : " @ID EQ CLB.BANK.CODE*":Y.LOOKUP.ID.SEL
    END ELSE
        Y.SEL.CMD = "SELECT " : FN.LOOKUP : " @ID LIKE CLB.BANK.CODE*..."
    END
    
    Y.REG.LIST = '' ; Y.NO.REG = ''
    
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    
    Y.I = 1
    Y.COUNT = 0
    LOOP
    WHILE Y.I LE Y.NO.REG
        Y.REG.ACT = Y.REG.LIST<Y.I>
        Y.R.EB.LOOKUP   = EB.Template.Lookup.Read(Y.REG.ACT, Y.READ.ERROR)
        IF Y.R.EB.LOOKUP NE '' THEN
            Y.LOOKUP.ID = Y.R.EB.LOOKUP<EB.Template.Lookup.LuLookupId>
            
            GOSUB OBTEN.CAMPOS.ADICIONALES
            
            IF Y.LOOKUP.ID NE '' AND Y.BAN.ESTATUS EQ 'A' THEN
                IF (NOT(Y.TIPO.SEL) OR (Y.TIPO.SEL AND Y.TIPO.SEL EQ Y.TIPO)) AND (NOT(Y.BAN.STATUS.SEL) OR (Y.BAN.STATUS.SEL AND Y.BAN.STATUS.SEL EQ Y.BAN.ESTATUS)) THEN
                    Y.COUNT++
                    R.DATA<Y.COUNT> = Y.LOOKUP.ID : Y.SEP : Y.BANCO : Y.SEP : Y.TIPO : Y.SEP : Y.BAN.ESTATUS
                END
            END
        END
        Y.I++
    REPEAT
    
    IF NOT(R.DATA) THEN
        EB.Reports.setEnqError("EB-NO.REC.SELECT")
    END

RETURN

*---------------------------------------------------------------
OBTEN.CAMPOS.ADICIONALES:
*---------------------------------------------------------------

    Y.TIPO = ''
    Y.BAN.ESTATUS = ''
    
    Y.DATA.NAME = Y.R.EB.LOOKUP<EB.Template.Lookup.LuDataName>
    Y.DATA.VALUES = Y.R.EB.LOOKUP<EB.Template.Lookup.LuDataValue>
    
    LOCATE 'TIPO' IN Y.DATA.NAME<1,1> SETTING Y.POS.TIPO THEN
        Y.TIPO = Y.DATA.VALUES<1,Y.POS.TIPO>
    END
    
    LOCATE 'BAN.ESTATUS' IN Y.DATA.NAME<1,1> SETTING Y.POS.ESTATUS THEN
        Y.BAN.ESTATUS = Y.DATA.VALUES<1,Y.POS.ESTATUS>
    END

    Y.BANCO = Y.R.EB.LOOKUP<EB.Template.Lookup.LuDescription, 1>

RETURN

*---------------------------------------------------------------
FINAL:
*---------------------------------------------------------------

END