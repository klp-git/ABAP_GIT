CLASS zpo_adobe_kd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_oo_adt_classrun.

    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .
    CLASS-DATA : template TYPE string .
    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct."


    CLASS-METHODS :

      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,

         read_posts
        IMPORTING VALUE(PurchaseOrderNumber) TYPE string
                  PurchaseOrderItem    TYPE string


        RETURNING VALUE(result12)     TYPE string
        RAISING   cx_static_check .


  PROTECTED SECTION.
  PRIVATE SECTION.


    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://btp-yvzjjpaz.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'SD_DOM_PRINT/SD_DOM_PRINT'.
ENDCLASS.



CLASS ZPO_ADOBE_KD IMPLEMENTATION.


 METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD .


 METHOD if_oo_adt_classrun~main.

 DATA(test) = read_posts( purchaseordernumber = '4500000000' PurchaseOrderItem = '00010' ).

 endmethod.


 METHOD read_posts.

 DATA var1 TYPE char20.
 var1 =   |{ |{ var1 ALPHA = OUT }| ALPHA = IN }| .
 purchaseordernumber = var1.

 SELECT  a~PURCHASEORDER , a~CREATIONDATE , a~CUSTOMER
 FROM I_PURCHASEORDERAPI01 as a
 into TABLE @data(it_header).


 SELECT PURCHASEORDERITEM , MATERIALGROUP , MATERIAL , BASEUNIT
 FROM I_PURCHASEORDERITEMAPI01 into TABLE @DATA(it_item).

 read TABLE it_header into DATA(wa_header) INDEX 1.

 DATA(header) =
 |<form>| &&
 |<PURCHASEORDER>{ wa_header-PurchaseOrder }</PURCHASEORDER>| &&
 |<CREATIONDATE>{ wa_header-CreationDate }</CREATIONDATE>| &&
 |<CUSTOMER>{ wa_header-Customer }</CUSTOMER>| &&
 |<line>|.

 loop at it_item INTO DATA(wa_item).
 data(line) =
 |<PURCHASEORDERITEM>{ wa_item-PurchaseOrderItem }</PURCHASEORDERITEM>| &&
 |<MATERIALGROUP>{ wa_item-MaterialGroup }</MATERIALGROUP>| &&
 |<MATERIAL>{ wa_item-Material }</MATERIAL>| &&
 |<BASEUNIT>{ wa_item-BaseUnit }</BASEUNIT>|.

 CONCATENATE header line INTO header.
 ENDLOOP.

 data(end) = |</line>| && |</form>|.

 CONCATENATE header end INTO header.



 ENDMETHOD.
ENDCLASS.
