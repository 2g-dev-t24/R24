* @ValidationCode : MjotMTU5MDI4NzYyOTpDcDEyNTI6MTc1NTc0MTEzNzM1MzpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Aug 2025 22:52:17
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

SUBROUTINE ABC.ACT.CAMP.FON.TER.PLD
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
    AF = EB.SystemTables.getAf()
    PREG.FON.TER = AbcTable.AbcAcctLclFlds.PregFonTer
    COMI = EB.SystemTables.getComi()
    ID.NEW = EB.SystemTables.getIdNew()
    
    Y.LIST1 = AbcTable.AbcAcctLclFlds.ApPatFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.ApMatFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.PrNomFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.SegNomFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.TerNomFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.NacFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.FecNacFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.ActDesFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.CalleFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.NumExtFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.NumIntFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.EstFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.DelMunFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.ColFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.CiudadFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.CpFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.TelFonter
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.EmailFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.CurpFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.RfcFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.TipIdFonTer
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.NumIdFonTer
    Y.TOT.LIST1 = DCOUNT(Y.LIST1, @FM)
    
    Y.LIST2 = AbcTable.AbcAcctLclFlds.BenCiudad
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.BenCodPos
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.BenPais
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.PerAutCd
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.PerAutCp
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.PerAutPais
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotCiudad
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotCodPos
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotPais
    Y.TOT.LIST2 = DCOUNT(Y.LIST2, @FM)
*DOMI.CTA.CIUDA
*DOMI.CTA.CP
*DOMI.CTA.PAIS
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    BEGIN CASE
        CASE AF = PREG.FON.TER
            IF COMI EQ 'SI' THEN
            
                Y.IND = 0
                LOOP
                WHILE Y.IND LT Y.TOT.LIST1
                    Y.IND =Y.IND + 1
                    tmp = EB.SystemTables.getT(Y.LIST1<Y.IND>)
                    tmp<3>=""
                    EB.SystemTables.setT(Y.LIST1<Y.IND>, tmp)
                REPEAT

            END ELSE
        
                Y.IND = 0
                LOOP
                WHILE Y.IND LT Y.TOT.LIST1
                    Y.IND =Y.IND + 1
                    EB.SystemTables.setRNew(Y.LIST1<Y.IND>, "")
                    tmp = EB.SystemTables.getT(Y.LIST1<Y.IND>)
                    tmp<3>="NOINPUT"
                    EB.SystemTables.setT(Y.LIST1<Y.IND>, tmp)
                REPEAT
            
            END

        CASE ID.NEW EQ COMI
    
            Y.IND = 0
            LOOP
            WHILE Y.IND LT Y.TOT.LIST1
                Y.IND =Y.IND + 1
                tmp = EB.SystemTables.getT(Y.LIST1<Y.IND>)
                tmp<3>="NOINPUT"
                EB.SystemTables.setT(Y.LIST1<Y.IND>, tmp)
            REPEAT
        
            Y.IND = 0
            LOOP
            WHILE Y.IND LT Y.TOT.LIST2
                Y.IND =Y.IND + 1
                tmp = EB.SystemTables.getT(Y.LIST2<Y.IND>)
                tmp<3>="NOINPUT"
                EB.SystemTables.setT(Y.LIST2<Y.IND>, tmp)
            REPEAT
    END CASE
    
    EB.Display.RebuildScreen()
            
RETURN
*-----------------------------------------------------------------------------
END