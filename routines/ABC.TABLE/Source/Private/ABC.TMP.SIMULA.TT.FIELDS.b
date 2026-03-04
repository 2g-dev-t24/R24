$PACKAGE AbcTable
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.TMP.SIMULA.TT.FIELDS
*===============================================
    $USING EB.Template
    $USING EB.SystemTables
*===============================================
* Nombre de Programa:   ABC.TMP.SIMULA.TT.FIELDS
* Objetivo:             Tabla que contendra los registros de cheques para las personas que no tengan cajas y tengan que escanear cheques
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("ABC.TMP.SIMULA.TT.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    EB.Template.TableAddfielddefinition('ID.CLIENTE', '10', 'ANY', '')      
    EB.Template.TableAddfielddefinition('ID.REGISTRO', '15', 'ANY', '')     
    EB.Template.TableAddfielddefinition('NOMBRE.CLIENTE', '60', 'ANY', '')  
    EB.Template.TableAddfielddefinition('CUENTA', '19', 'ANY', '')          
    EB.Template.TableAddfielddefinition('MONEDA', '5', 'ANY', '') 
    EB.Template.TableAddfielddefinition('MONTO.LOCAL', '30', 'AMT', '')     
    EB.Template.TableAddfielddefinition('NO.CHEQUE.GIRADOR', '60', 'ANY','')          
    EB.Template.TableAddfielddefinition('NO.CTA.GIRADOR', '30', 'ANY','')   
    EB.Template.TableAddfield("NO.BANCO", EB.Template.T24Numeric, "", "")
    EB.Template.FieldSetcheckfile('ABC.BANCOS')
    EB.Template.TableAddoptionsfield('TIPO.CHEQUE', 'Cheque Personal_Cheque de Caja', 'A','')
    EB.Template.TableAddfielddefinition('COD.SEG.CHQ', '10', '', '')        
    EB.Template.TableAddfielddefinition('DIG.PREMARCADO', '10', '', '')     
    EB.Template.TableAddfielddefinition('CVE.TXN.CHQ', '10', '', '')        
    EB.Template.TableAddfielddefinition('PLAZA.COMP.CHQ', '10', '', '')     
    EB.Template.TableAddfielddefinition('DIG.INTRCAM.CHQ', '10', '', '')    
    EB.Template.TableAddfielddefinition('ID.IMG.CHQ', '60', 'ANY','')       
    EB.Template.TableAddfielddefinition('ID.TELLER', '60', 'ANY','')        

    EB.Template.TableAddreservedfield("RESERVED.5")
    EB.Template.TableAddreservedfield("RESERVED.4")
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")


    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------
END
