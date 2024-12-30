CLASS lhc_zdd_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zdd_travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zdd_travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zdd_travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zdd_travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ zdd_travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zdd_travel.

    METHODS rba_booking FOR READ
      IMPORTING keys_rba FOR READ zdd_travel\_booking FULL result_requested RESULT result LINK association_links.

    METHODS cba_booking FOR MODIFY
      IMPORTING entities_cba FOR CREATE zdd_travel\_booking.

    METHODS set_status_booked FOR MODIFY
      IMPORTING keys FOR ACTION zdd_travel~set_status_booked RESULT result.

ENDCLASS.

CLASS lhc_zdd_travel IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_booking.
  ENDMETHOD.

  METHOD cba_booking.
  ENDMETHOD.

  METHOD set_status_booked.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zdd_travel DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zdd_travel IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
