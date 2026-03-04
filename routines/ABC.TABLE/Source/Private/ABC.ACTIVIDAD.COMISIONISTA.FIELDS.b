* @ValidationCode : Mjo5NTQ3NDUxODU6Q3AxMjUyOjE3NTI3MTkwMzA5MTI6THVpcyBDYXByYTotMTotMTowOjA6dHJ1ZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Jul 2025 23:23:50
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
SUBROUTINE ABC.ACTIVIDAD.COMISIONISTA.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ABC.ACT.COMI.ID", EB.Template.T24String)
*-----------------------------------------------------------------------------

	EB.Template.TableAddfield('ACT.COMI', EB.Template.T24String,'A', '')
    EB.Template.TableAddfield('DESCRIPCION', EB.Template.T24String,'', '')

    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")

    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()

END
