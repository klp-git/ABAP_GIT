CLASS lhc_bookings DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR bookings RESULT result.

    METHODS validatebookingdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR bookings~validatebookingdate.

ENDCLASS.

CLASS lhc_bookings IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validatebookingdate.
    READ ENTITIES OF zc_booking IN LOCAL MODE ENTITY bookings
    FIELDS ( bookingdate ) WITH CORRESPONDING #( keys )
    RESULT DATA(booking_dt).

    loop at booking_dt INTO DATA(b_dt).
    if b_dt-BookingDate < sy-datum.
    APPEND VALUE #( %tky = b_dt-%tky ) to failed-bookings.
    APPEND VALUE #( %tky = keys[ 1 ]-%tky
    %msg = new_message_with_text(
    severity = if_abap_behv_message=>severity-error
    text = 'Booking date cannot be in the past.'
    )
     )
     TO reported-bookings.
    ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
