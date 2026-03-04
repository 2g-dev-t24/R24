$PACKAGE AbcTable

SUBROUTINE ABC.IPAB.CRED.VENC.FIELDS
    $USING EB.SystemTables
    $USING EB.Template
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("CTA.CHEQ", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------

    EB.Template.TableAddfield("XX<CODIGO.CLIENTE", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-NUMERO.CREDITO", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-MONEDA", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-SEGMENTO", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-TIPO.COBRANZA", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-CAPITAL.VIGENTE", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-CAPITAL.VENCIDO", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-INT.ORD.EXIGIBLE", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX-INT.MORATORIO", EB.Template.T24String, "", "")
    EB.Template.TableAddfield("XX>OTROS.ACCESORIOS", EB.Template.T24String, "", "")
    
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

    EB.Template.TableAddlocalreferencefield(neighbour)

*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
END
