"!Component representation for Abap Debugger Enhancement
"! is responsible for representing components/fields
"! within a -component = 'component value' statement
CLASS zcl_op_component DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:

      "! add a single component or already formated context
      "! @parameter i_datatype | datatype of component
      "! @parameter i_current_context | current context as string
      "! @parameter i_component | current component
      "! @parameter i_component_info | field catalog info for this component
      "! @parameter r_current_context | changed context with added component data as string
      add
        IMPORTING
                  i_datatype               TYPE datatype_d  OPTIONAL
                  i_current_context        TYPE string
                  i_component              TYPE any
                  i_component_info         TYPE lvc_s_fcat
        RETURNING VALUE(r_current_context) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      "! prepare component name
      "! delete surrounding spaces
      component_name  IMPORTING i_component_name        TYPE lvc_fname
                      RETURNING VALUE(r_component_name) TYPE lvc_fname.
ENDCLASS.



CLASS ZCL_OP_COMPONENT IMPLEMENTATION.


  METHOD add.
    r_current_context = i_current_context.

    CHECK i_component IS NOT INITIAL AND i_component_info-fieldname NE |INDEX|.

    DATA(assign_component_value) = COND #( WHEN i_component_info-datatype EQ |TTYP| THEN | = { i_component }|
                                       WHEN i_component_info-datatype EQ |STRU| THEN |{ i_component }|
                                                                                ELSE | = '{ i_component }'| ).

    DATA(new_column_value_combi) = | { me->component_name( i_component_info-fieldname ) }{ assign_component_value }|.


    r_current_context = |{ i_current_context }{ new_column_value_combi }|.

  ENDMETHOD.


  METHOD component_name.
    r_component_name = i_component_name.
    CONDENSE r_component_name NO-GAPS.
  ENDMETHOD.
ENDCLASS.
