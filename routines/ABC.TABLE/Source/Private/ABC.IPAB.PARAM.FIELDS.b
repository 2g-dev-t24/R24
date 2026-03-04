$PACKAGE AbcTable

SUBROUTINE ABC.IPAB.PARAM.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid('ABC.IPAB.PARAM.ID', EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield('CLAVE.BANCO', EB.Template.T24String, '', '')
    EB.Template.TableAddfielddefinition('SEPARADOR', '1', 'ANY', '')
    EB.Template.TableAddfielddefinition('NOM.ARCHIVO', '65', 'ANY', '')
    EB.Template.TableAddfielddefinition('RUTA.ARCHIVO.EXT', '65', 'ANY', '')
    EB.Template.TableAddfielddefinition('RUTA.ARCHIVO.PROY', '65', 'ANY', '')
    EB.Template.TableAddfield('ID.ISR', EB.Template.T24String, '', '')

    EB.Template.TableAddfield('XX<CATEGORIA', EB.Template.T24Numeric, '', '')
    EB.Template.TableAddfield('XX-CLASIFICACION', EB.Template.T24Numeric, '', '')
    EB.Template.TableAddfield('XX-PRODUCTO', EB.Template.T24Numeric, '', '')
    EB.Template.TableAddoptionsfield('XX>TABLA.6', 'YES_NO', '', '')

    EB.Template.TableAddfielddefinition('TASA.AHORRO', '35', 'ANY', '')

    EB.Template.TableAddfield('XX<PRODUCTO.AA', EB.Template.T24Numeric, '', '')
    EB.Template.TableAddoptionsfield('XX>TIPO.TASA', '1_2', '', '')

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
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END