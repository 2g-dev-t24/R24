*-----------------------------------------------------------------------------
* <Rating>-14</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTable
    SUBROUTINE ABC.PARAM.DAYS.INACTIVITY.LOG.FIELDS
*===============================================
* Nombre de Programa:   ABC.PARAM.DAYS.INACTIVITY
* Objetivo:             Tabla para guardar los registros de usuarios que son bloqueados
* Desarrollador:        
* Compania:             
* Fecha Creacion:       
* Modificaciones:
*===============================================

* <region name= Inserts>
    $USING EB.SystemTables
    $USING EB.Template
* </region>
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("TABLE.NAME.ID", EB.Template.T24String)        ;* Define Table id
*-----------------------------------------------------------------------------
    fieldName = 'FECHA.PROCESO'
    fieldLength = '35'
    fieldType = 'ANY'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ID.USUARIO'
    fieldLength = '35'
    fieldType = 'ANY'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'NO.DAYS'
    fieldLength = '35'
    fieldType = 'ANY'
    neighbour =  ''
    EB.Template.TableAddfielddefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")
    EB.Template.TableAddlocalreferencefield(neighbour)
*-----------------------------------------------------------------------------
    EB.Template.TableSetauditposition()         ;* Populate audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END
