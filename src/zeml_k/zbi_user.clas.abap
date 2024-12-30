CLASS zbi_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.
    METHODS : sample_create,
      sample_read,
      sample_update,
      sample_delete.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBI_USER IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    "===========Sample create method calling inside a interface Main
    sample_create( ).
    COMMIT ENTITIES.
    IF sy-subrc = 0.
      out->write( 'Data Is Inseted In Database Table' ) .
    ELSE.
      out->write( 'No data Inserted' ).
    ENDIF.

    sample_update( ).
    COMMIT ENTITIES.
    IF sy-subrc = 0 .
      out->write( 'Record update to The DB table' ) .
    ELSE.
      out->write( 'No Record update to the DB table' ).
    ENDIF.



*    sample_read( ).
    READ ENTITY zcds_consumption ALL FIELDS WITH VALUE #( (
    userid = 2 ) )
    RESULT DATA(lt_read_data).
    out->write( lt_read_data ).

    sample_delete(  ).
    COMMIT ENTITIES.
    IF sy-subrc = 0.
      out->write( 'record deleted successfully' ).
    ELSE.
      out->write( 'no record deleted' ).
    ENDIF.

  ENDMETHOD.


  METHOD sample_create.
    DATA : lt_user TYPE TABLE FOR CREATE zcds_consumption.
    lt_user = VALUE #( ( userid = 1
    username = 'smriti'
    userage = 21
    %control = VALUE #(
    userid = if_abap_behv=>mk-on
    username = if_abap_behv=>mk-on
    userage = if_abap_behv=>mk-on
     )
     ) ).
    MODIFY ENTITIES OF zcds_consumption ENTITY user CREATE FROM lt_user
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).


  ENDMETHOD.


  METHOD sample_delete.
    MODIFY ENTITY zcds_consumption
    DELETE FROM VALUE #( (
    userid = 2
    ) ).
  ENDMETHOD.


  METHOD sample_read.
  ENDMETHOD.


  METHOD sample_update.
    MODIFY ENTITY zcds_consumption
    UPDATE FIELDS ( username userage )
    WITH VALUE #( (
    userid = 2
    username = 'Pinky'
    userage = 22
    ) ).
  ENDMETHOD.
ENDCLASS.
