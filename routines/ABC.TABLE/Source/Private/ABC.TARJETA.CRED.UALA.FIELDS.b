*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.TARJETA.CRED.UALA.FIELDS
* ======================================================================
* Nombre de Programa : ABC.TARJETA.CRED.UALA.FIELDS
* Objetivo           : Template para los datos de registro de tarjeta
* Requerimiento      : Servicios Tarjeta de Credito
* Desarrollador      : Alexis Almaraz Robles - FyG-Solutions
* Compania           : 
* Fecha Creacion     : 
* Modificaciones     :
* ======================================================================

     $USING EB.Template
    $USING EB.SystemTables

    EB.Template.TableDefineid('ABC.TARJ.CRED.ID', EB.Template.T24Numeric)

    EB.Template.TableAddfielddefinition('CLABE', '18', '', '')
    EB.Template.TableAddfield("CUSTOMER", EB.Template.T24Customer, '', '')
    EB.Template.FieldSetcheckfile("CUSTOMER")
    EB.Template.TableAddoptionsfield("ESTATUS", "ACTIVA_CANCELADA", '', '')

    EB.Template.TableAddreservedfield('RESERVED.20')
    EB.Template.TableAddreservedfield('RESERVED.19')
    EB.Template.TableAddreservedfield('RESERVED.18')
    EB.Template.TableAddreservedfield('RESERVED.17')
    EB.Template.TableAddreservedfield('RESERVED.16')
    EB.Template.TableAddreservedfield('RESERVED.15')
    EB.Template.TableAddreservedfield('RESERVED.14')
    EB.Template.TableAddreservedfield('RESERVED.13')
    EB.Template.TableAddreservedfield('RESERVED.12')
    EB.Template.TableAddreservedfield('RESERVED.11')
    EB.Template.TableAddreservedfield('RESERVED.10')
    EB.Template.TableAddreservedfield('RESERVED.9')
    EB.Template.TableAddreservedfield('RESERVED.8')
    EB.Template.TableAddreservedfield('RESERVED.7')
    EB.Template.TableAddreservedfield('RESERVED.6')
    EB.Template.TableAddreservedfield('RESERVED.5')
    EB.Template.TableAddreservedfield('RESERVED.4')
    EB.Template.TableAddreservedfield('RESERVED.3')
    EB.Template.TableAddreservedfield('RESERVED.2')
    EB.Template.TableAddreservedfield('RESERVED.1')

*-----------------------------------------------------------------------------
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------


    RETURN

END

