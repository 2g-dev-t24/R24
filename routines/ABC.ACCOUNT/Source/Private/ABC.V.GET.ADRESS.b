* @ValidationCode : MjotNDQzMzU2NDg5OkNwMTI1MjoxNzU1NzM5Njk3OTQ1Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Aug 2025 22:28:17
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

$PACKAGE AbcAccount

SUBROUTINE ABC.V.GET.ADRESS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.SEP        = "|"
    Y.SEPA       = "-"
    Y.FLAG       = 0
    Y.FLAG.LOC.REF  = 0

    FN.ABC.CODIGO.POSTAL = 'F.ABC.CODIGO.POSTAL'
    F.ABC.CODIGO.POSTAL = ''
    EB.DataAccess.Opf(FN.ABC.CODIGO.POSTAL, F.ABC.CODIGO.POSTAL)

    FN.ABC.CIUDAD = 'F.ABC.CIUDAD'
    F.ABC.CIUDAD = ''
    EB.DataAccess.Opf(FN.ABC.CIUDAD, F.ABC.CIUDAD)

    YPOS.CODIGO.POSTAL = ''
    YVAL.CODIGO.POSTAL = EB.SystemTables.getComi()

    AF = EB.SystemTables.getAf()
    AV = EB.SystemTables.getAv()

    AF120   = AbcTable.AbcAcctLclFlds.CotCodPos
    AF42    = AbcTable.AbcAcctLclFlds.BenCodPos
    AF149   = AbcTable.AbcAcctLclFlds.CpFonTer
    AF68    = AbcTable.AbcAcctLclFlds.PerAutCp
    
    PGM.VERSION = EB.SystemTables.getPgmVersion()
    MESSAGE = EB.SystemTables.getMessage()

    IF PGM.VERSION EQ ",ABC.DEPOSITOS.COTITULARES" OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT" AND AF EQ AF120) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PF" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PM" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA" AND AF EQ AF120) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MOD" AND AF EQ AF120) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL.MOD" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.2BR.ANOCHQ.SINT" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA.MAN" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA.ACT" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO.MOD" AND AF EQ AF120) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU" AND AF EQ AF120) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU.MOD" AND AF EQ AF120) OR (PGM.VERSION EQ ",ABC.MANTENIMIENTO.CUENTA" AND AF EQ AF120)  THEN
        Y.POS.COT.EDO   = AbcTable.AbcAcctLclFlds.CotEstado
        Y.POS.COT.MPIO  = AbcTable.AbcAcctLclFlds.CotMunicipio
        Y.POS.COT.COL   = AbcTable.AbcAcctLclFlds.CotColonia
        Y.POS.COT.CD    = AbcTable.AbcAcctLclFlds.CotCiudad
        Y.POS.COT.CP    = AbcTable.AbcAcctLclFlds.CotCodPos
        Y.POS.COT.PAIS  = AbcTable.AbcAcctLclFlds.CotPais
        
        Y.FLAG.LOC.REF = 1
    END

    IF PGM.VERSION EQ ",ABC.DEPOSITOS.BENEFICIARIOS"  OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT" AND AF EQ AF42) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PF" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PM" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA" AND AF EQ AF42) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MOD" AND AF EQ AF42) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL.MOD" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.2BR.ANOCHQ.SINT" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA.MAN" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA.ACT" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO.MOD" AND AF EQ AF42) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU" AND AF EQ AF42) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU.MOD" AND AF EQ AF42) OR (PGM.VERSION EQ ",ABC.MANTENIMIENTO.CUENTA" AND AF EQ AF42) THEN
        Y.POS.COT.EDO   = AbcTable.AbcAcctLclFlds.BenEstado
        Y.POS.COT.MPIO  = AbcTable.AbcAcctLclFlds.BenMunicipio
        Y.POS.COT.COL   = AbcTable.AbcAcctLclFlds.BenColonia
        Y.POS.COT.CD    = AbcTable.AbcAcctLclFlds.BenCiudad
        Y.POS.COT.CP    = AbcTable.AbcAcctLclFlds.BenCodPos
        Y.POS.COT.PAIS  = AbcTable.AbcAcctLclFlds.BenPais

        Y.FLAG.LOC.REF = 1
    END

    IF PGM.VERSION EQ ",ABC.DEPOSITOS.USO" OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT" AND AF EQ AF149) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PF" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PM" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA" AND AF EQ AF149) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MOD" AND AF EQ AF149) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL.MOD" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.2BR.ANOCHQ.SINT" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA.MAN" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA.ACT" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO.MOD" AND AF EQ AF149) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU" AND AF EQ AF149) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU.MOD" AND AF EQ AF149) OR (PGM.VERSION EQ ",ABC.MANTENIMIENTO.CUENTA" AND AF EQ AF149) THEN
        Y.POS.COT.EDO   = AbcTable.AbcAcctLclFlds.EstFonTer
        Y.POS.COT.MPIO  = AbcTable.AbcAcctLclFlds.DelMunFonTer
        Y.POS.COT.COL   = AbcTable.AbcAcctLclFlds.ColFonTer
        Y.POS.COT.CD    = AbcTable.AbcAcctLclFlds.CiudadFonTer
        Y.POS.COT.CP    = AbcTable.AbcAcctLclFlds.CpFonTer

        Y.FLAG = 1
        Y.FLAG.LOC.REF = 1
    END

    IF PGM.VERSION EQ ",ABC.DEPOSITOS.PERSONA" OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT" AND AF EQ AF68) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PF" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.EJE.PM" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA" AND AF EQ AF68) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MOD" AND AF EQ AF68) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.MORAL.MOD" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.2BR.ANOCHQ.SINT" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.BASICA.MAN" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.NOMINA.ACT" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.CUENTA.AHORRO.MOD" AND AF EQ AF68) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU" AND AF EQ AF68) OR (PGM.VERSION EQ ",BA.CUENTA.CHQ.SIN.INT.FIDU.MOD" AND AF EQ AF68) OR (PGM.VERSION EQ ",ABC.MANTENIMIENTO.CUENTA" AND AF EQ AF68) THEN
        Y.POS.COT.EDO   = AbcTable.AbcAcctLclFlds.PerAutEstado
        Y.POS.COT.MPIO  = AbcTable.AbcAcctLclFlds.PerAutMun
        Y.POS.COT.COL   = AbcTable.AbcAcctLclFlds.PerAutMun
        Y.POS.COT.CD    = AbcTable.AbcAcctLclFlds.PerAutCd
        Y.POS.COT.CP    = AbcTable.AbcAcctLclFlds.PerAutCp
        Y.POS.COT.PAIS  = AbcTable.AbcAcctLclFlds.PerAutPais
        
        Y.FLAG.LOC.REF = 1
    END
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF MESSAGE EQ 'VAL' OR Y.FLAG.LOC.REF EQ 0 THEN
        RETURN
    END ELSE
        YVAL.CODIGO.POSTAL = FMT(YVAL.CODIGO.POSTAL,"5'0'R")
        Y.CADENA.DIRECCION = ''
        GOSUB GET.ADRESS

        POS.COT.EDO     = EB.SystemTables.getRNew(Y.POS.COT.EDO)
        POS.COT.MPIO    = EB.SystemTables.getRNew(Y.POS.COT.MPIO)
        POS.COT.COL     = EB.SystemTables.getRNew(Y.POS.COT.COL)
        POS.COT.CD      = EB.SystemTables.getRNew(Y.POS.COT.CD)
        POS.COT.CP      = EB.SystemTables.getRNew(Y.POS.COT.CP)
        POS.COT.PAIS    = EB.SystemTables.getRNew(Y.POS.COT.PAIS)

        IF Y.CADENA.DIRECCION EQ ""  THEN
            
            POS.COT.CP<1,AV>   = ""
            POS.COT.EDO<1,AV>  = ""
            POS.COT.MPIO<1,AV> = ""
            POS.COT.COL<1,AV>  = ""
            POS.COT.CD<1,AV>   = ""

            IF Y.FLAG NE  1 THEN
                POS.COT.PAIS<1,AV>   = ""
            END
        END ELSE

            Y.ESTADO    = FIELD(Y.CADENA.DIRECCION,Y.SEP, 1)
            Y.CD.DESC   = FIELD(Y.CADENA.DIRECCION,Y.SEP, 2)
            Y.CIUDAD    = FIELD(Y.CD.DESC,Y.SEPA,1)
            Y.MUNICIPIO = FIELD(Y.CADENA.DIRECCION,Y.SEP, 3)
            Y.COLONIA   = FIELD(Y.CADENA.DIRECCION,Y.SEP, 4)
            Y.PAIS      = FIELD(Y.CADENA.DIRECCION,Y.SEP, 5)

            POS.COT.CP<1,AV>   = YVAL.CODIGO.POSTAL
            POS.COT.EDO<1,AV>  = Y.ESTADO
            POS.COT.MPIO<1,AV> = Y.MUNICIPIO
            POS.COT.COL<1,AV>  = Y.COLONIA
            POS.COT.CD<1,AV>   = Y.CIUDAD

            IF Y.FLAG NE  1 THEN
                POS.COT.PAIS<1,AV>   = Y.PAIS
            END
        END
    
        EB.SystemTables.setRNew(Y.POS.COT.CP, POS.COT.CP)
        EB.SystemTables.setRNew(Y.POS.COT.EDO, POS.COT.EDO)
        EB.SystemTables.setRNew(Y.POS.COT.MPIO, POS.COT.MPIO)
        EB.SystemTables.setRNew(Y.POS.COT.COL, POS.COT.COL)
        EB.SystemTables.setRNew(Y.POS.COT.CD, POS.COT.CD)
        EB.SystemTables.setRNew(Y.POS.COT.PAIS, POS.COT.PAIS)
        
    END

    EB.Display.RebuildScreen()
*    CALL REFRESH.GUI.OBJECTS

RETURN
*-----------------------------------------------------------------------------
GET.ADRESS:
*-----------------------------------------------------------------------------
    YVAL.CODIGO.POSTAL = FMT(YVAL.CODIGO.POSTAL,"5'0'R")
    EB.DataAccess.FRead(FN.ABC.CODIGO.POSTAL, YVAL.CODIGO.POSTAL, R.ADRESS, F.ABC.CODIGO.POSTAL, ERR.COD.POS)

    IF R.ADRESS EQ '' THEN
        Y.CADENA.DIRECCION = ""
    END ELSE
        Y.ID.EDO  = R.ADRESS<AbcTable.AbcCodigoPostal.Estado>
        IF Y.ID.EDO GT 0 AND Y.ID.EDO LE 32 THEN
            Y.ID.PAIS = "MX"
        END
        Y.ID.CD   = R.ADRESS<AbcTable.AbcCodigoPostal.Ciudad>

        EB.DataAccess.FRead(FN.ABC.CIUDAD, Y.ID.CD, R.CD, F.ABC.CIUDAD, ERR.CD.POS)
        Y.CD.DESC = R.CD<AbcTable.AbcCiudad.Ciudad>

        Y.ID.MPIO = R.ADRESS<AbcTable.AbcCodigoPostal.Municipio>
        Y.ID.COL  = R.ADRESS<AbcTable.AbcCodigoPostal.Colonia>

        Y.CANT.COL = DCOUNT(Y.ID.COL,VM)
        IF Y.CANT.COL GT 1 THEN
            Y.ID.COL = ""
        END
        Y.CADENA.DIRECCION = Y.ID.EDO : Y.SEP : Y.ID.CD : "-" : Y.CD.DESC : Y.SEP : Y.ID.MPIO : Y.SEP : Y.ID.COL : Y.SEP : Y.ID.PAIS
    END
    
RETURN
*-----------------------------------------------------------------------------
END