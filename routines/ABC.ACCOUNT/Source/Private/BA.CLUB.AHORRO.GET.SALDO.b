* @ValidationCode : MjotMTM1MDUwOTA3MzpDcDEyNTI6MTc1OTExNjAyNzUxMzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 29 Sep 2025 00:20:27
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

SUBROUTINE BA.CLUB.AHORRO.GET.SALDO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display

    $USING AbcTable
    $USING EB.Reports
    $USING AA.Framework
    $USING AA.TermAmount
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.BA.CLUB.REC   = ''
    Y.LD.AMOUNT     = 0
    Y.BA.CLUB.ACCT  = ''
    Y.GRUPO.AHORRO  = ''
    Y.BANDERA       = ''

    FN.ABC.CLUB.AHORRO = 'F.ABC.CLUB.AHORRO'
    F.ABC.CLUB.AHORRO = ''
    EB.DataAccess.Opf(FN.ABC.CLUB.AHORRO,F.ABC.CLUB.AHORRO)

    FN.INVT.ACC='F.ABC.CLUB.INVST.ACCOUNT'
    F.INVT.ACC=''
    EB.DataAccess.Opf(FN.INVT.ACC,F.INVT.ACC)
    
    O.DATA  = EB.Reports.getOData()
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FINDSTR '*' IN O.DATA SETTING Ap, Vp THEN
        Y.BANDERA = 'Y'
        Y.GRUPO.AHORRO = FIELD(O.DATA,'*',1)
        
        Y.BA.CLUB.REC   = ''
        EB.DataAccess.FRead(FN.ABC.CLUB.AHORRO, Y.GRUPO.AHORRO, Y.BA.CLUB.REC, F.ABC.CLUB.AHORRO, ERR)
        
        IF (Y.BA.CLUB.REC EQ '') THEN
            O.DATA = "ERROR.EL CLUB DE AHORRO NO EXISTE"
            EB.Reports.setOData(O.DATA)
            RETURN
        END
        Y.BA.CLUB.ACCT = Y.BA.CLUB.REC<AbcTable.AbcClubAhorro.Cuenta>
    END ELSE
        Y.BA.CLUB.ACCT = O.DATA
    END

    Y.LD.LIST   = ''
    Y.LD.CNT    = ''
    Y.LD.ERR    = ''
    Y.TOT.INV   = 0
    Y.LD.REC    = ''
    ARR.CTE     = ''

    LOOP
        REMOVE Y.ID.ACC.LIST.CLUB FROM Y.BA.CLUB.ACCT SETTING Y.POS.ACC.CLUB
    WHILE Y.ID.ACC.LIST.CLUB : Y.POS.ACC.CLUB
    
        EB.DataAccess.FRead(FN.INVT.ACC,Y.ID.ACC.LIST.CLUB,REC.INVST.ACC,F.INVT.ACC,INVST.ERR)
        Y.AA.LIST   = REC.INVST.ACC
        Y.AA.CNT    = DCOUNT(Y.AA.LIST,@VM)
        LOOP
            REMOVE ARR.ID.AMT FROM Y.AA.LIST SETTING SEL.POS
        WHILE ARR.ID.AMT : SEL.POS
            AMT.ERR     = ''
            R.AMT.COND  = ''
            R.AMT.ID    = ''
            AA.Framework.GetArrangementConditions(ARR.ID.AMT,'TERM.AMOUNT','',EFF.DATE,R.AMT.ID,R.AMT.COND,AMT.ERR)
            R.AMT.COND      = RAISE(R.AMT.COND)
            Y.LD.CAPITAL    = R.AMT.COND<AA.TermAmount.TermAmount.AmtAmount>

            ARR.REC         = ''
            PRODUCT.ID      = ''
            PROPERTY.LIST   = ''
            ARR.REC         = ''
            AA.Framework.GetArrangementProduct(ARR.ID.AMT,EFF.DATE,ARR.REC,PRODUCT.ID,PROPERTY.LIST)
            YSTATUS = ''
            YSTATUS = ARR.REC<AA.Framework.Arrangement.ArrArrStatus>

            IF YSTATUS EQ 'CURRENT' THEN
                Y.TOT.INV += Y.LD.CAPITAL
            END
        REPEAT

    REPEAT

    O.DATA = Y.TOT.INV

    IF Y.BANDERA EQ 'Y' THEN
        ACA.GROUP.CLASSIFIC = Y.BA.CLUB.REC<AbcTable.AbcClubAhorro.GroupClssific>
        O.DATA = O.DATA:'*':ACA.GROUP.CLASSIFIC:'*':Y.AA.CNT
    END
    
    EB.Reports.setOData(O.DATA)
    
RETURN
*-----------------------------------------------------------------------------
END