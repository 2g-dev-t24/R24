* @ValidationCode : Mjo1NzM4OTg4NDY6Q3AxMjUyOjE3NTk3ODA1MjQyMDE6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Oct 2025 16:55:24
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

SUBROUTINE ABC.IDE.SALDOS.CLIE.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('CLIENTE', '10', 'CUS', '')
    EB.Template.TableAddfielddefinition('MONEDA', '3', 'A', '')
    EB.Template.TableAddfielddefinition('XX<PERIODO.ANT', '6', '', '')
    EB.Template.TableAddfielddefinition('XX>IDE.PER.ANT', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('TOT.DEP.MES', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('TOT.DEP.LIN', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('IMPUESTO.CALC', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('IMPUESTO.RECA', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('IMPUESTO.PEND', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX<REF.PER.IDE', '6', '', '')
    EB.Template.TableAddfielddefinition('XX-REF.FOL.IDE', '35', 'A', '')
    EB.Template.TableAddfielddefinition('XX>REF.PAG.IDE', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX<REF.PER.IDE.LIN', '6', '', '')
    EB.Template.TableAddfielddefinition('XX-REF.FOL.IDE.LIN', '35', 'A', '')
    EB.Template.TableAddfielddefinition('XX>REF.PAG.IDE.LIN', '19', 'AMT', '')
    EB.Template.TableAddfielddefinition('XX.MOV.PAGO', '50', '', '')

    EB.Template.TableAddreservedfield('RESERVED.10')
    EB.Template.TableAddreservedfield('RESERVED.09')
    EB.Template.TableAddreservedfield('RESERVED.08')
    EB.Template.TableAddreservedfield('RESERVED.07')
    EB.Template.TableAddreservedfield('RESERVED.06')
    EB.Template.TableAddreservedfield('RESERVED.05')
    EB.Template.TableAddreservedfield('RESERVED.04')
    EB.Template.TableAddreservedfield('RESERVED.03')
    EB.Template.TableAddreservedfield('RESERVED.02')
    EB.Template.TableAddreservedfield('RESERVED.01')

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
END
