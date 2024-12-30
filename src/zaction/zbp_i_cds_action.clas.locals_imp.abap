CLASS lhc_student DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR student RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR student RESULT result.
    METHODS setadmitted FOR MODIFY
      IMPORTING keys FOR ACTION student~setadmitted RESULT result.
    METHODS validateage FOR VALIDATE ON SAVE
      IMPORTING keys FOR student~validateage.
    METHODS totalfees FOR DETERMINE ON SAVE
      IMPORTING keys FOR student~totalfees.

ENDCLASS.

CLASS lhc_student IMPLEMENTATION.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.
  METHOD get_instance_features.
  ENDMETHOD.

  METHOD setadmitted.

    MODIFY ENTITIES OF zi_cds_action IN LOCAL MODE ENTITY student UPDATE FIELDS ( status )
    WITH VALUE #( FOR key IN keys ( %tky = key-%tky status = abap_true ) )

    FAILED failed
    REPORTED reported.


    READ ENTITIES OF zi_cds_action IN LOCAL MODE ENTITY student
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(studentdata).

    result = VALUE #( FOR studentrec IN studentdata
    ( %tky = studentrec-%tky %param = studentrec ) ).


  ENDMETHOD.

  METHOD validateage.
    READ ENTITIES OF zi_cds_action IN LOCAL MODE ENTITY student
    FIELDS ( age ) WITH CORRESPONDING #( keys )
      RESULT DATA(studentage).


    LOOP AT studentage  INTO DATA(s_age).
      IF s_age-age < 18.
        APPEND VALUE #( %tky = s_age-%tky ) TO failed-student.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
        %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text = 'Age should be greater than or equals to 18..'
        )
         )
         TO reported-student.
      ENDIF.
    ENDLOOP.





  ENDMETHOD.

  METHOD totalfees.

DATA : total_fee TYPE p DECIMALS 12.
    READ ENTITIES OF zi_cds_action IN LOCAL MODE ENTITY student
   FIELDS ( coursefees ) WITH CORRESPONDING #( keys )
   RESULT DATA(Tfees).

   loop at Tfees INTO DATA(fees).

   total_fee = total_fee + fees-CourseFees.


   ENDLOOP.




  ENDMETHOD.

ENDCLASS.
