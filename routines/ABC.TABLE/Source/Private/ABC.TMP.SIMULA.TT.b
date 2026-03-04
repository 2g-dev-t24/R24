$PACKAGE AbcTable
*-----------------------------------------------------------------------------
    SUBROUTINE ABC.TMP.SIMULA.TT
*===============================================
* Nombre de Programa:   ABC.TMP.SIMULA.TT
* Objetivo:             Tabla que contendra los registros de cheques para las personas que no tengan cajas y tengan que escanear cheques
*===============================================
    $USING EB.SystemTables
    $USING EB.Template
    $USING AA.Framework
    $USING EB.Interface
*-----------------------------------------------------------------------------
    EB.Template.setTableName('ABC.TMP.SIMULA.TT')       ;* Full application name including product prefix
    EB.Template.setTableTitle('REGISTRO DE CHEQUES')   ;* Screen title
    EB.Template.setTableStereotype('H')    ;* H, U, L, W or T
    EB.Template.setTableProduct('EB')      ;* Must be on EB.PRODUCT
    EB.Template.setTableSubproduct('')     ;* Must be on EB.SUB.PRODUCT
    EB.Template.setTableClassification('INT')        ;* As per FILE.CONTROL
    EB.Template.setTableSystemclearfile('Y')         ;* As per FILE.CONTROL
    EB.Template.setTableRelatedfiles('')   ;* As per FILE.CONTROL
    EB.Template.setTableIspostclosingfile('')        ;* As per FILE.CONTROL
    EB.Template.setTableEquateprefix('TT.TMP')          ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    EB.Template.setTableIdprefix('')       ;* Used by EB.FORMAT.ID if set
    EB.Template.setTableBlockedfunctions('')         ;* Space delimeted list of blocked functions
    EB.Template.setTableTriggerfield('')        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

    RETURN
END
