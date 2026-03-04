*-----------------------------------------------------------------------------
* <Rating>70</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ET.SAP.CONSULTA.CUENTA(RESULT)

    $USING EB.Reports
    $USING EB.DataAccess
    $USING AbcTable
    $USING EB.SystemTables
    $USING EB.Template

*    $INCLUDE I_F.ET.SAP.CARD.ID
*    $INCLUDE I_F.ET.SAP.TARJETA

    GOSUB INIT
    GOSUB OPEN
    GOSUB PROCESO

    RETURN
*----------------------------------------------------------------
INIT:

    RESULT = ''

    FN.CARD = 'F.ET.SAP.CARD.ID'
    FV.CARD = ''

    FN.TARJETA = 'F.ET.SAP.TARJETA'
    FV.TARJETA = ''
    
    SEL.FIELDS  = EB.Reports.getDFields()
    SEL.VALUES  = EB.Reports.getDRangeAndValue()

    RETURN
*----------------------------------------------------------------
OPEN:

    EB.DataAccess.Opf(FN.CARD,FV.CARD)
    EB.DataAccess.Opf(FN.TARJETA,FV.TARJETA)

    RETURN
*----------------------------------------------------------------
PROCESO:

        LOCATE "NUMERO" IN SEL.FIELDS<1> SETTING IND.POS THEN
        IN.NUMERO = SEL.VALUES<IND.POS>
    END

    IF IN.NUMERO THEN

        EB.DataAccess.FRead(FN.CARD, IN.NUMERO, REC.CARD, FV.CARD, Y.ERR.CARD)
        IF REC.CARD THEN
            ID.TARJETA = REC.CARD<AbcTable.EtSapCardId.Descripcion>
            EB.DataAccess.FRead(FN.TARJETA, ID.TARJETA, REC.TARJETA, FV.TARJETA, Y.ERR.FV.TARJETA)
            IF REC.TARJETA THEN
                EDO.TAR = REC.TARJETA<AbcTable.EtSapTarjeta.EdoTarjeta>
                IF EDO.TAR NE 'ACTIVA' THEN
                    RESULT = 'TARJETA ':EDO.TAR:'**'
                END ELSE
                    RESULT = ID.TARJETA :'*': IN.NUMERO :'*': REC.TARJETA<AbcTable.EtSapTarjeta.AccountId>
                END
            END
        END ELSE
            RESULT = 'TARJETA NO EXISTE**'
        END
    END

    RETURN
    
*----------------------------------------------------------------
END
