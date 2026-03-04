* @ValidationCode : Mjo4MzExMTc2Nzc6Q3AxMjUyOjE3NTUwMTc3MTc2MzQ6THVjYXNGZXJyYXJpOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Aug 2025 13:55:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable
*-----------------------------------------------------------------------------

SUBROUTINE BA.AC.SUCURSALES.FIELDS
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('SUCURSAL', '5', 'A', '')
    
    EB.Template.TableAddfielddefinition('NOM.SUCURSAL', '30', 'A', '')
    EB.Template.TableAddfielddefinition('SUC.PLD', '10', 'A', '')
    EB.Template.TableAddfielddefinition('SUC.PRINC', '2', '', '')
    EB.Template.TableAddfielddefinition('TEL.SUC', '20', 'A', '')
    EB.Template.TableAddfielddefinition('FEC.ACTIV', '8', 'D', '')
    EB.Template.TableAddfielddefinition('FEC.DESAC', '8', 'D', '')
    
    EB.Template.TableAddfielddefinition('DIR.PAIS', '6', 'A', '')
    EB.Template.FieldSetcheckfile('COUNTRY')
        
    EB.Template.TableAddfielddefinition('DIR.ESTADO', '6', 'A', '')
    EB.Template.FieldSetcheckfile('ABC.ESTADO')
    
    EB.Template.TableAddfielddefinition('DIR.MUNICIPIO', '6', 'A', '')
    EB.Template.FieldSetcheckfile('ABC.MUNICIPIO')
    
    EB.Template.TableAddfielddefinition('DIR.COLONIA', '35', 'A', '')
    EB.Template.FieldSetcheckfile('ABC.COLONIA')
    
    EB.Template.TableAddfielddefinition('DIR.CIUDAD', '6', 'A', '')
    EB.Template.FieldSetcheckfile('ABC.CIUDAD')
    
    EB.Template.TableAddfielddefinition('DIR.CALLE', '35', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.NUM.EXT', '6', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.NUM.INT', '6', 'A', '')
    EB.Template.TableAddfielddefinition('DIR.CODPOS', '6', 'A', '')
    
    EB.Template.TableAddfielddefinition('TIPO.SUCURSAL', '6', 'A', '')
    EB.Template.TableAddfielddefinition('SERVICIO.CAJE', '6', 'A', '')
    EB.Template.TableAddfielddefinition('CLAVE.TRANSACCION', '6', 'A', '')
    EB.Template.TableAddfielddefinition('CLAVE.SITUACION', '6', 'A', '')
    EB.Template.TableAddfielddefinition('COLONIA', '35', 'A', '')
    EB.Template.TableAddfielddefinition('LOCALIDAD.CNBV', '35', 'A', '')
    EB.Template.TableAddfielddefinition('MUNICIPIO.CNBV', '35', 'A', '')
    EB.Template.TableAddfielddefinition('LATITUD', '35', 'A', '')
    EB.Template.TableAddfielddefinition('LONGITUD', '35', 'A', '')
    EB.Template.TableAddfielddefinition('CORREO', '65', 'A', '')

    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
*-----------------------------------------------------------------------------
    EB.Template.TableAddlocalreferencefield(neighbour)
    EB.Template.TableAddoverridefield()
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END