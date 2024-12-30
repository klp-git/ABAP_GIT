CLASS yso_dom_http_kp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YSO_DOM_HTTP_KP IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

    DATA json TYPE string .
    DATA plant TYPE string.
    DATA salesorderno TYPE string.
    DATA salesorder TYPE n LENGTH 10.

    plant = VALUE #( req[ name = 'plant' ]-value OPTIONAL ) .
    salesorderno = VALUE #( req[ name = 'salesorderno' ]-value OPTIONAL ) .

    json =  VALUE #( req[ name = 'json' ]-value OPTIONAL ) .
    salesorder = salesorderno .

    SELECT SINGLE * FROM i_salesdocumentitem WITH PRIVILEGED ACCESS WHERE salesdocument = @salesorder AND plant = @plant
    INTO @DATA(check).
    IF check IS NOT INITIAL .
      DATA(pdf2) = yso_dom_print_class_ap=>read_posts( plant = plant salesorderno = salesorderno ) .
    ELSE .
      pdf2 = 'Error Please Check Plant'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
