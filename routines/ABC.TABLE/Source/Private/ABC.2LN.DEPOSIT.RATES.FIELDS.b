* @ValidationCode : MjotNzYxOTI3Nzg6Q3AxMjUyOjE3NTc2MjgxMDQxNzk6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Sep 2025 19:01:44
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

SUBROUTINE ABC.2LN.DEPOSIT.RATES.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

    $USING EB.SystemTables
    $USING EB.Template
    $USING AC.AccountOpening
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('XX<DAY.PERIOD'      ,'4'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX-XX<AMOUNT'      ,'16'       , 'A', '')
    EB.Template.TableAddfielddefinition('XX>XX>PERCENTAGE'      ,'10'       , 'A', '')
    EB.Template.TableSetauditposition()
END

