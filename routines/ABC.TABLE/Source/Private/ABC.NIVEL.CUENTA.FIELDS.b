* @ValidationCode : MjotMTk5NzA1MTU4NTpDcDEyNTI6MTc1NTI5NTI4MjIxNDpMdWlzIENhcHJhOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 Aug 2025 19:01:22
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
*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
SUBROUTINE ABC.NIVEL.CUENTA.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("TABLE.NAME.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('DESCRIPCION', '60', 'ANY', '')     ;* Add a new field
    EB.Template.TableAddfielddefinition('LIMITE', '20', '', '')   ;* Add a new field
    EB.Template.TableAddfielddefinition('MONEDA', '4', 'ANY', '') ;* Add a new field
    EB.Template.TableAddfielddefinition('VALOR.LIMITE', '30', 'AMT', '')    ;* Add a new field
    EB.Template.TableAddfielddefinition('XX<APLICACION', '60', 'ANY', '')   ;* Add a new field
    EB.Template.TableAddfielddefinition('XX-XX.TRANSACCION.CR', '5', 'ANY', '')       ;* Add a new field
    EB.Template.TableAddfielddefinition('XX>XX.TRANSACCION.DR', '5', 'ANY', '')       ;* Add a new field
    EB.Template.TableAddfielddefinition('XX<APLICACION.REST', '60', 'ANY', '')        ;* Add a new field
    EB.Template.TableAddfielddefinition('XX>XX.TRANSACCION.REST', '5', 'ANY', '')     ;* Add a new field



    EB.Template.TableAddreservedfield("RESERVED.10")
    EB.Template.TableAddreservedfield("RESERVED.9")
    EB.Template.TableAddreservedfield("RESERVED.8")
    EB.Template.TableAddreservedfield("RESERVED.7")
    EB.Template.TableAddreservedfield("RESERVED.6")
    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
