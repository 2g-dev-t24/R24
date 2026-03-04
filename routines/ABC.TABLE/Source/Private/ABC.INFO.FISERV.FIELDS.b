* @ValidationCode : MjotNjA2Nzc4ODczOkNwMTI1MjoxNzU1NTYyMzE5OTk2Okx1aXMgQ2FwcmE6LTE6LTE6MDowOnRydWU6Ti9BOlIyNF9TUDEuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Aug 2025 21:11:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable

SUBROUTINE ABC.INFO.FISERV.FIELDS
*-----------------------------------------------------------------------------
*
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("CLABE.ID", EB.Template.T24String)         ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('CUENTA.FISERV', '20', '', '')
*-----------------------------------------------------------------------------
END

