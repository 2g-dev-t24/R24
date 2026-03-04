* @ValidationCode : MjotMTQxMzgwMzUxMTpDcDEyNTI6MTc1ODg0MDk2Njc4ODptYXVyaWNpby5sb3BlejotMTotMTowOjA6ZmFsc2U6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Sep 2025 19:56:06
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
$PACKAGE AbcPortNom
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ABC.CUENTA.PN
* ======================================================================
* Nombre de Programa : ABC.CUENTA.PN
* Parametros         :
* Objetivo           : VALIDA QUE LA CUENTA ORDENANTE PERTENEZCA AL BANCO SELECCIONADO
* Desarrollador      : SANDRA FIGUEROA ESQUIVEL
* Compañia           : ABC
* Fecha Creacion     : 2016/09/30
* Modificaciones     :
* ======================================================================

    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING AbcTable
    
    Y.BANK=''
    Y.CTA.ORD   = EB.SystemTables.getComi()
    Y.BANK      = EB.SystemTables.getRNew(AbcTable.AbcPortabilidadNomina.BancoOrd)
    IF LEN(Y.BANK) LE 6 THEN
        IF Y.BANK[3,3] NE Y.CTA.ORD[1,3] THEN
            E= "CUENTA NO PERTENECE A BANCO SELECCIONADO":Y.BANK:" Y.CTA.ORD"
            EB.SystemTables.setE(E)
            EB.ErrorProcessing.Err()

        END
    END ELSE
        E= "EB-TOO.MANY.CHARACTERS"
        EB.SystemTables.setE(E)
        EB.ErrorProcessing.Err()
    END

END
