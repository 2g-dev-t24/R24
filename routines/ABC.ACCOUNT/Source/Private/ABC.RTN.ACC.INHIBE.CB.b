* @ValidationCode : MjotNzAxOTY2NjAxOkNwMTI1MjoxNzU1NzQxMTM3MjA4Okx1Y2FzRmVycmFyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
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

SUBROUTINE ABC.RTN.ACC.INHIBE.CB(Y.TIPO.CTE)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Display
    
    $USING AC.AccountOpening
    $USING EB.OverrideProcessing

    $USING AbcTable
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
        
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
***CAMPOS DE BENEFICIARIOS
    Y.LIST1 = AbcTable.AbcAcctLclFlds.BenApePaterno
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenApeMaterno
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenNombres
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenTelefono
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenPorcentaje
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenRfc
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenCurp
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenIdentifica
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenNroIdenti
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.ParentescoBen
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenPaisNac
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenFecNac
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenNacional
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenCalle
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenNumExt
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenNumInt
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenEstado
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenMunicipio
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenColonia
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenTelCel
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenEmail
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenNomEmp
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenProfPues
    Y.LIST1<-1> = AbcTable.AbcAcctLclFlds.BenOcupAct
    Y.TOT.LIST1 = DCOUNT(Y.LIST1, @FM)

***CAMPOS DE COOTITULARES
    Y.LIST2 = AbcTable.AbcAcctLclFlds.InteresesTit
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotApePaterno
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotApeMaterno
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotNombre
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotRfc
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotNacimiento
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotAsigInt
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotCurp
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotIdentificac
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotTipoFirma
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotNroIdentif
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.ParentescoCot
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotpaisNac
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotNacional
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotCalle
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotNumExt
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotNumInt
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotEstado
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotMunicipio
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotColonia
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotTel
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotTelCel
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotEmail
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotNomEmp
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotProfPues
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotOcupAct
    Y.LIST2<-1> = AbcTable.AbcAcctLclFlds.CotActEco
    Y.TOT.LIST2 = DCOUNT(Y.LIST2, @FM)

***CAMPOS DE FACULTADES MEDIANTE
    Y.LIST3 = AbcTable.AbcAcctLclFlds.FacuNumEscCo
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuFecEscCo
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuNomNotar
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuNumNotar
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuEntNotar
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuEntReg
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuNumReg
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuFecReg
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuRfcReg
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuCurpReg
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuNaciReg
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuStatus
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuNombre
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuApePatern
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuApeMatern
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuIndetifica
    Y.LIST3<-1> = AbcTable.AbcAcctLclFlds.FacuNroIdenti
    Y.TOT.LIST3 = DCOUNT(Y.LIST3, @FM)
    
***OTROS
    Y.LIST4 = AbcTable.AbcAcctLclFlds.FacuTipoFirma
    Y.LIST4<-1> = AbcTable.AbcAcctLclFlds.FacuFecNac
    Y.LIST4<-1> = AbcTable.AbcAcctLclFlds.FacuTel
    Y.LIST4<-1> = AbcTable.AbcAcctLclFlds.FacuPaisNac
    Y.LIST4<-1> = AbcTable.AbcAcctLclFlds.FacuTelCel
    Y.LIST4<-1> = AbcTable.AbcAcctLclFlds.FacuEmail
    Y.LIST4<-1> = AbcTable.AbcAcctLclFlds.FacuStatus
    Y.TOT.LIST4 = DCOUNT(Y.LIST4, @FM)

    
    
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF (Y.TIPO.CTE > 2) THEN
        GOSUB INHIBE
    END
    ELSE
        GOSUB DESINHIBE
    END

    EB.Display.RebuildScreen()
        
RETURN
*-----------------------------------------------------------------------------
INHIBE:
*-----------------------------------------------------------------------------
***CAMPOS DE BENEFICIARIOS
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST1
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST1<Y.IND>)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(Y.LIST1<Y.IND>, tmp)
    REPEAT
    
***CAMPOS DE COOTITULARES
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST2
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST2<Y.IND>)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(Y.LIST2<Y.IND>, tmp)
    REPEAT

***CAMPOS DE FACULTADES MEDIANTE
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST3
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST3<Y.IND>)
        tmp<3>=""
        EB.SystemTables.setT(Y.LIST3<Y.IND>, tmp)
    REPEAT

***OTROS
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST4
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST4<Y.IND>)
        tmp<3>=""
        EB.SystemTables.setT(Y.LIST4<Y.IND>, tmp)
    REPEAT

RETURN
*-----------------------------------------------------------------------------
DESINHIBE:
*-----------------------------------------------------------------------------
***CAMPOS DE BENEFICIARIOS
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST1
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST1<Y.IND>)
        tmp<3>=""
        EB.SystemTables.setT(Y.LIST1<Y.IND>, tmp)
    REPEAT
    
***CAMPOS DE COOTITULARES
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST2
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST2<Y.IND>)
        tmp<3>=""
        EB.SystemTables.setT(Y.LIST2<Y.IND>, tmp)
    REPEAT

***CAMPOS DE FACULTADES MEDIANTE
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST3
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST3<Y.IND>)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(Y.LIST3<Y.IND>, tmp)
    REPEAT

***OTROS
    Y.IND = 0
    LOOP
    WHILE Y.IND LT Y.TOT.LIST4
        Y.IND =Y.IND + 1
        tmp = EB.SystemTables.getT(Y.LIST4<Y.IND>)
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(Y.LIST4<Y.IND>, tmp)
    REPEAT
    
RETURN
*-----------------------------------------------------------------------------
END