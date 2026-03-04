* @ValidationCode : Mjo1NzMzMTA5ODQ6Q3AxMjUyOjE3NTg5OTk2NDMyMDQ6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Sep 2025 16:00:43
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

SUBROUTINE TMP.REP.SAL.OP.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.SystemTables.setIdF('ID')
    EB.SystemTables.setIdN('30')
    EB.SystemTables.setIdT('A')
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('INFO.REG', '450', 'A', '')
    
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
END
