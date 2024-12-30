*CLASS yso_dom_print_class DEFINITION

CLASS yso_dom_print_class_kp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .


    CLASS-DATA :BEGIN OF wa_add,
                  var1(80)  TYPE c,
                  var2(80)  TYPE c,
                  var3(80)  TYPE c,
                  var4(80)  TYPE c,
                  var5(80)  TYPE c,
                  var6(80)  TYPE c,
                  var7(80)  TYPE c,
                  var8(80)  TYPE c,
                  var9(80)  TYPE c,
                  var10(80) TYPE c,
                  var11(80) TYPE c,
                  var12(80) TYPE c,
                  var13(80) TYPE c,
                  var14(80) TYPE c,
                  var15(80) TYPE c,
                END OF wa_add.



    CLASS-DATA : BEGIN OF it_amount,
                   ztiv(20)         TYPE c,
                   jocg(20)         TYPE c,
                   jocgp(20)        TYPE c,
                   josg(20)         TYPE c,
                   josgp(20)        TYPE c,
                   joig(20)         TYPE c,
                   joigp(20)        TYPE c,
                   ztcs(20)         TYPE c,
                   ztcsp            TYPE p DECIMALS 2,
                   zrod(20)         TYPE c,
                   zgiv(20)         TYPE c,
                   docomantdate(20) TYPE c,
                   docomanttype(20) TYPE c,
                 END OF it_amount.




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
        RAISING   cx_static_check ,

      read_posts
        IMPORTING VALUE(salesorderno) TYPE string
                  plant               TYPE string


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



CLASS YSO_DOM_PRINT_CLASS_KP IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.
    DATA(test) = read_posts( salesorderno = '0000000321' plant = '1810' ) .
  ENDMETHOD.


  METHOD read_posts .

    DATA var1 TYPE char10.
    var1 = salesorderno.
    var1 =   |{ |{ var1 ALPHA = OUT }| ALPHA = IN }| .

    salesorderno = var1.


    SELECT SINGLE *
    FROM i_salesdocument AS a
    LEFT JOIN i_salesdocumentitem AS b ON ( b~salesdocument = a~salesdocument )
    LEFT JOIN i_paymenttermstext AS c ON ( c~paymentterms = a~customerpaymentterms AND c~language = 'E' )
    LEFT JOIN i_salesofficetext AS d ON ( d~salesoffice = a~salesoffice AND d~language = 'E' )
    WHERE a~salesdocument = @salesorderno
    INTO @DATA(it_so).


    DATA : paymenterms TYPE c LENGTH 400.
    IF it_so-c-paymenttermsname <> ' ' .
      paymenterms = it_so-c-paymenttermsname .
    ELSE.
      paymenterms = it_so-c-paymenttermsdescription .
    ENDIF.

* SELECT SINGLE *
* FROM zsd_company_det_cds
* WHERE company_code = @it_so-a-salesorganization
* INTO @DATA(copoffice).

    SELECT SINGLE *
    FROM i_plant AS a
    INNER JOIN i_address_2 WITH PRIVILEGED ACCESS AS b ON ( b~addressid = a~addressid )
    WHERE plant = @it_so-b-plant
    INTO @DATA(plantadd) .

* if billhead-CreatedByUser id
    SELECT SINGLE userdescription  FROM i_user WITH PRIVILEGED ACCESS WHERE  userid = @it_so-a-createdbyuser INTO @DATA(username).

    SELECT SINGLE b~taxnumber3,
    b~customer,
    b~telephonenumber1,
    c~organizationname1,
    c~organizationname2,
    c~organizationname3,
    c~housenumber,
    c~streetname,
    c~streetprefixname1,
    c~streetprefixname2,
    c~streetsuffixname1,
    c~streetsuffixname2,
    c~districtname,
    c~cityname,
    c~postalcode,
    c~addresssearchterm1,
    d~regionname
    FROM i_salesdocumentpartner AS a
    LEFT JOIN i_customer AS b ON ( b~customer = a~customer )
    LEFT JOIN i_address_2 WITH PRIVILEGED ACCESS AS c ON ( c~addressid = b~addressid )
    LEFT JOIN i_regiontext AS d ON ( d~region = b~region AND d~language = 'E' AND d~country = b~country )
* left join I_Region as D on ( D~Region = a~ )
    WHERE salesdocument = @it_so-a-salesdocument AND partnerfunction = 'WE' INTO @DATA(shiptoparty).

    SELECT SINGLE b~taxnumber3,
   b~customer,
   b~telephonenumber1,
   c~organizationname1,
   c~organizationname2,
   c~organizationname3,
   c~housenumber,
   c~streetname,
   c~streetprefixname1,
   c~streetprefixname2,
   c~streetsuffixname1,
   c~streetsuffixname2,
   c~districtname,
   c~cityname,
   c~postalcode,
   c~addresssearchterm1,
   d~regionname,
   e~*
   FROM i_salesdocumentpartner AS a
   LEFT JOIN i_customer AS b ON ( b~customer = a~customer )
   LEFT JOIN i_address_2 WITH PRIVILEGED ACCESS AS c ON ( c~addressid = b~addressid )
   LEFT JOIN i_regiontext AS d ON ( d~region = b~region AND d~language = 'E' AND d~country = b~country )
   LEFT JOIN i_businesspartnerbank AS e ON ( e~businesspartner = b~customer   )
* left join I_Region as D on ( D~Region = a~ )
   WHERE salesdocument = @it_so-a-salesdocument AND  partnerfunction = 'RE' INTO @DATA(soldtoparty).


    SELECT SINGLE * FROM i_salesdocumentpartner AS a LEFT OUTER JOIN i_address_2 WITH PRIVILEGED ACCESS AS  b ON ( a~addressid = b~addressid )
     WHERE a~salesdocument = @it_so-a-salesdocument INTO @DATA(con_add).

    IF con_add-b-country = 'BD'.
      DATA(country) = 'Bangladesh'.
    ELSE.
      country = con_add-b-country.
    ENDIF.

    SELECT a~salesdocument,
    a~salesdocumentitem,
    a~material,
    a~salesdocumentitemtext,
    a~orderquantityunit,
    a~orderquantity,
    a~plant,
*    a~yy1_cut1_sdi,
*    a~yy1_pdnumber_sdi,
*    a~yy1_grade1_sdi,
*    a~yy1_rolls_sdi,
    a~netpricequantityunit,
    a~materialbycustomer,
    a~netpriceamount,
    b~conditiontype,
    b~conditionamount,
    b~conditionbasevalue,
    b~conditionratevalue,
    b~conditionbaseamount,
    c~consumptiontaxctrlcode,
    a~transactioncurrency
    FROM i_salesdocumentitem AS a
    INNER JOIN i_salesdocitempricingelement AS b ON ( b~salesdocument = a~salesdocument AND b~salesdocumentitem = a~salesdocumentitem )
    INNER JOIN i_productplantbasic AS c ON ( c~product = a~product AND c~plant = a~plant )
    WHERE a~salesdocument = @salesorderno
    INTO TABLE @DATA(it_soitem).

    wa_add-var1 = shiptoparty-organizationname1.
    wa_add-var2 = shiptoparty-organizationname2.
    wa_add-var3 = shiptoparty-organizationname3.

    DATA(shipaddname) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = shiptoparty-housenumber.
    wa_add-var2 = shiptoparty-streetname.
    wa_add-var3 = shiptoparty-streetprefixname1.
    wa_add-var4 = shiptoparty-streetprefixname2.
    wa_add-var5 = shiptoparty-streetsuffixname1.
    wa_add-var6 = shiptoparty-streetsuffixname2.

    DATA(shipaddhono) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = shiptoparty-cityname.
* wa_add-var2 = shiptoparty-districtname.
    wa_add-var3 = shiptoparty-postalcode.

    DATA(shipaddcity) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = soldtoparty-organizationname1.
    wa_add-var2 = soldtoparty-organizationname2.
    wa_add-var3 = soldtoparty-organizationname3.

    DATA(soldaddname) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = soldtoparty-housenumber.
    wa_add-var2 = soldtoparty-streetname.
    wa_add-var3 = soldtoparty-streetprefixname1.
    wa_add-var4 = soldtoparty-streetprefixname2.
    wa_add-var5 = soldtoparty-streetsuffixname1.
    wa_add-var6 = soldtoparty-streetsuffixname2.

    DATA(soldaddhono) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = soldtoparty-cityname.
* wa_add-var2 = soldtoparty-districtname.
    wa_add-var3 = soldtoparty-postalcode.

    DATA(soldaddcity) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = plantadd-b-organizationname1.
    wa_add-var2 = plantadd-b-organizationname2.
    wa_add-var3 = plantadd-b-organizationname3.

    DATA(plantaddname) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = plantadd-b-housenumber.
    wa_add-var2 = plantadd-b-streetname.
    wa_add-var3 = plantadd-b-streetprefixname1.
    wa_add-var4 = plantadd-b-streetprefixname2.
    wa_add-var5 = plantadd-b-streetsuffixname1.
    wa_add-var6 = plantadd-b-streetsuffixname2.

    DATA(plantaddhono) = zseparate_address=>separate( CHANGING var = wa_add ).

    wa_add-var1 = plantadd-b-cityname.
    wa_add-var2 = plantadd-b-districtname.
    wa_add-var3 = plantadd-b-postalcode.

    DATA(plantaddcity) = zseparate_address=>separate( CHANGING var = wa_add ).

    CONCATENATE it_so-a-salesdocumentdate+6(2) '/' it_so-a-salesdocumentdate+4(2) '/' it_so-a-salesdocumentdate+2(2) INTO DATA(sodate) . .

    CONCATENATE it_so-a-requesteddeliverydate+6(2) '/' it_so-a-requesteddeliverydate+4(2) '/' it_so-a-requesteddeliverydate+2(2) INTO DATA(custrefdate) . .


    IF it_so-a-sddocumentcategory = 'L'.
      it_amount-docomanttype = 'Debit Note'.
      it_amount-docomantdate = 'Debit Note Date'.
    ELSEIF it_so-a-sddocumentcategory = 'K'.
      it_amount-docomanttype = 'Credit Note'.
      it_amount-docomantdate = 'Credit Note Date'.
    ELSEIF it_so-a-sddocumentcategory = 'C'.
      it_amount-docomanttype = 'Sales Order'.
      it_amount-docomantdate = 'Sales Order Date'.
    ENDIF.

    """""""""""""""""""""""""""""""""""""""""""""""""""Plant Wise Address, GST & PAN"""""""""""""""""""""""""""""""""""
    IF plant  = '1100'.
      DATA(gst1)  = '23AAHCS2781A1ZP'.
      DATA(pan1)  = 'AAHCS2781A'.
      DATA(register1) = 'SWARAJ SUITING LIMITED                 '.
      DATA(register2) = 'Spinning Division-I' .
      DATA(register3) = 'B-24 To B-41 Jhanjharwada Industrial Area'.
      DATA(register4) = 'Jhanjharwada, Neemuch - 458441, Madhya Pradesh, India'.
      DATA(cin1) = 'L18101RJ2003PLC018359'.
    ELSEIF plant = '1200'.
      gst1  = '23AAHCS2781A1ZP'.
      pan1  = 'AAHCS2781A'.
      register1 = 'SWARAJ SUITING LIMITED'.
      register2 = 'Denim Division-I' .
      register3 = 'B-24 To B-41 Jhanjharwada Industrial Area'.
      register4 = 'Jhanjharwada, Neemuch - 458441, Madhya Pradesh, India'.
      cin1 = 'L18101RJ2003PLC018359'.
    ELSEIF plant = '1300'.
      gst1  = '08AAHCS2781A1ZH'.
      pan1  = 'AAHCS2781A'.
      register1 = 'SWARAJ SUITING LIMITED'.
      register2 = 'Weaving Division-I' .
      register3 = 'F-483 To F-487 RIICO Growth Centre'.
      register4 = 'Hamirgarh, Bhilwara-311025, Rajasthan, India'.
      cin1 = 'L18101RJ2003PLC018359'.
    ELSEIF plant = '1310'.
      gst1  = '23AAHCS2781A1ZP'.
      pan1  = 'AAHCS2781A'.
      register1 = 'SWARAJ SUITING LIMITED'.
      register2 = 'Weaving Division-II' .
      register3 = 'B-24 To B-41 Jhanjharwada Industrial Area'.
      register4 = 'Jhanjharwada, Neemuch-458441, Madhya Pradesh, India'.
      cin1 = 'L18101RJ2003PLC018359'.
    ELSEIF plant = '1400'.
      gst1  = '23AAHCS2781A1ZP'.
      pan1  = 'AAHCS2781A'.
      register1 = 'SWARAJ SUITING LIMITED'.
      register2 = 'Process House-I' .
      register3 = 'B-24 To B-41 Jhanjharwada Industrial Area'.
      register4 = 'Jhanjharwada, Neemuch-458441, Madhya Pradesh, India'.
      cin1 = 'L18101RJ2003PLC018359'.
    ELSEIF plant = '2100'.
      gst1  = '08AABCM5293P1ZT'.
      pan1  = 'AABCM5293P'.
      register1 = 'MODWAY SUITING PVT. LIMITED'.
      register2 = 'Weaving Division-I' .
      register3 = '20th Km Stone, Chittorgarh Road'.
      register4 = 'Takhatpura, Bhilwara-311025, Rajasthan, India'.
      cin1 = 'U18108RJ1986PTC003788'.
    ELSEIF plant = '2200'.
      gst1  = '23AABCM5293P1Z1'.
      pan1  = 'AABCM5293P'.
      register1 = 'MODWAY SUITING PVT. LIMITED'.
      register2 = 'Weaving Division-II' .
      register3 = 'B-24 To B-41 Jhanjharwada Industrial Area'.
      register4 = 'Jhanjharwada, Neemuch-458441, Madhya Pradesh, India'.
      cin1 = 'U18108RJ1986PTC003788'.
    ELSEIF plant = '1210'.
      gst1  = '08AAHCS2781A1ZH'.
      pan1  = 'AAHCS2781A'.
      register1 = 'SWARAJ SUITING LIMITED'.
      register2 = 'Storage Godown' .
      register3 = 'E-288/A, RIICO Growth Center'.
      register4 = 'Hamirgarh, Bhilwara-311025, Rajasthan, India'.
      cin1 = 'L18101RJ2003PLC018359'.
    ENDIF.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA nameprint TYPE string .

    SELECT SINGLE * FROM i_salesdocument WHERE salesdocument = @salesorderno
     INTO @DATA(printname).

    IF printname-salesdocumenttype = 'CBRE' .
      nameprint = 'Sales Return' .
    ELSEIF
     printname-distributionchannel = '02'.
      nameprint = '(EXPORT)' .
    ELSEIF
    printname-distributionchannel = '01'.
      nameprint = '(DOMESTIC)' .
    ENDIF.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA(lv_xml) =
 |<Form>| &&
 |<frmShipToAddress>| &&
   |<SalesOrder>{ it_so-a-salesdocument  }</SalesOrder>| &&
   |<SalesOrderDate>{ sodate }</SalesOrderDate>| &&
   |<CIN>{ cin1 }</CIN>| &&
   |<PAN>{ pan1 }</PAN>| &&
   |<GST>{ gst1 }</GST>| &&
   |<add3>{ register1 }</add3>| &&
   |<add2>{ register2 }</add2>| &&
   |<add1>{ register3 }</add1>| &&
   |<add4>{ register4 }</add4>| &&
   |<PreparedBy>{ username }</PreparedBy>| &&
|</frmShipToAddress>| &&

|<txtLine1></txtLine1>| &&
|<txtLine2></txtLine2>| &&
|<billto_add_1>{ soldaddname }</billto_add_1>| &&
|<billto_add_2>{ soldaddhono } , { soldaddcity }</billto_add_2>| &&
|<billto_add_3>{ soldtoparty-districtname }</billto_add_3>| &&
|<billto_add_4>{ soldtoparty-regionname  } , { country }</billto_add_4>| &&
|<billto_add_5>{ soldtoparty-telephonenumber1 }</billto_add_5>| &&
|<billto_add_6></billto_add_6>| &&
|<partyname1>{ nameprint }</partyname1>| &&
|<Cell1></Cell1>| &&
|<Cell1></Cell1>| &&
|<Cell1></Cell1>| &&
|<shipto_add_1>{ shipaddname }</shipto_add_1>| &&
|<shipto_add_2>{ shipaddhono } , { shipaddcity }</shipto_add_2>| &&
|<shipto_add_3>{ shiptoparty-districtname }</shipto_add_3>| &&
|<txtLine7></txtLine7>| &&
|<shipto_add_4>{ shiptoparty-regionname } , { country }</shipto_add_4>| &&
|<shipto_add_5>{ shiptoparty-telephonenumber1 }</shipto_add_5>| &&
|<txtLine1></txtLine1>| &&
|<shipto_add_6></shipto_add_6>| &&
|<txtOrderNumber></txtOrderNumber>| &&
|<PaymentTerm1Description>{ paymenterms }</PaymentTerm1Description>| &&
|<inco_term_cllasification>{ it_so-a-incotermsclassification }</inco_term_cllasification>| &&
|<IncotermsLocation1>{ it_so-a-incotermslocation1 }</IncotermsLocation1>| &&
|<reqdelidate>{ custrefdate }</reqdelidate>| &&
*|<Transpotername>{ it_so-a-yy1_transportername_sdh }</Transpotername>| &&
*|<AgentName>{ it_so-a-yy1_agentname1_sdh }</AgentName>| &&
|<tblRemarkRowTable>| &&
|<Ratecurrncy>{ it_so-a-transactioncurrency }</Ratecurrncy>|.
    DATA rat TYPE p DECIMALS 2 .
    DATA xsml TYPE string .
    DATA count TYPE int8 .

*LOOPING DATA
************************************
    DATA cdper TYPE string.
    DATA matdes TYPE string .
    DATA pdnodes TYPE string .
    DATA(it_cond) = it_soitem.
    SORT it_soitem BY salesdocument salesdocumentitem.
    DELETE ADJACENT DUPLICATES FROM it_soitem COMPARING salesdocument salesdocumentitem.

    LOOP AT it_soitem INTO DATA(wa_soitem).



      IF wa_soitem-materialbycustomer IS NOT INITIAL .
        matdes = wa_soitem-materialbycustomer .
      ELSE.
        matdes =    wa_soitem-salesdocumentitemtext .
      ENDIF.

      SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
         conditiontype IN ( 'ZCHD' )   AND salesorder = @salesorderno  INTO @DATA(cd_amt)  .

      SELECT SINGLE conditionrateratio FROM i_salesorderitempricingelement WHERE conditiontype =  'ZCHD'
           AND salesorder = @salesorderno INTO @DATA(cd_per)  .
      cdper = cd_per.
      CONCATENATE  cdper+0(3) '%'   INTO cdper .

*      SELECT SINGLE pdno FROM zpp_sortmaster WHERE material = @wa_soitem-material INTO @DATA(pdno) .
*      IF wa_soitem-yy1_pdnumber_sdi IS NOT INITIAL .
*
*        pdnodes  =   wa_soitem-yy1_pdnumber_sdi .
*
*      ELSE .
*        pdnodes =  pdno .
*
*      ENDIF.

      LOOP AT it_cond INTO DATA(wa_cond) WHERE salesdocument = wa_soitem-salesdocument
      AND salesdocumentitem = wa_soitem-salesdocumentitem.

        CASE wa_cond-conditiontype .
          WHEN 'ZR00' OR 'ZR01'.
            DATA(rate) = wa_cond-conditionratevalue.
            DATA(netpriceamount) = wa_cond-netpriceamount.

          WHEN 'ZCHD'.
            DATA(rate1) = wa_cond-conditionratevalue.
            DATA(netpriceamount1) = wa_cond-netpriceamount.

          WHEN 'ZTIV' .
            it_amount-ztiv = wa_cond-conditionamount .
          WHEN 'JOCG' .
            it_amount-jocg = wa_cond-conditionamount .
            it_amount-jocgp = wa_cond-conditionratevalue.
          WHEN 'JOSG'.
            it_amount-josg = wa_cond-conditionamount.
            it_amount-josgp = wa_cond-conditionratevalue.
          WHEN 'JOIG'.
            it_amount-joig = wa_cond-conditionamount.
            it_amount-joigp = wa_cond-conditionratevalue.
          WHEN 'ZROD'.
            it_amount-zrod = wa_cond-conditionamount + it_amount-zrod.
          WHEN 'ZGIV'.
            it_amount-zgiv = wa_cond-conditionamount + it_amount-zgiv.
          WHEN 'ZTCS' OR 'JTC1'.
            it_amount-ztcs = wa_cond-conditionamount + it_amount-ztcs.
            IF wa_cond-conditionratevalue IS NOT INITIAL.
              it_amount-ztcsp = wa_cond-conditionratevalue .
            ENDIF.
        ENDCASE.
      ENDLOOP.

      CLEAR : wa_cond.
      DATA(lv_xml2) =
*      |<tblRemarkRowTable>| &&
      |<tableDataRows>| &&
         |<sno></sno>| &&
*         |<cut>{ wa_soitem-yy1_cut1_sdi }</cut>| &&
         |<item>{ matdes  }</item>| &&
         |<pdno>{ pdnodes }</pdno>| &&
         |<hsnno.>{ wa_soitem-consumptiontaxctrlcode }</hsnno.>| &&
         |<unit>{ wa_soitem-netpricequantityunit }</unit>| &&
*         |<grade>{ wa_soitem-yy1_grade1_sdi }</grade>| &&
*         |<rolls>{ wa_soitem-yy1_rolls_sdi }</rolls>| &&
         |<qty>{ wa_soitem-orderquantity }</qty>| &&
         |<rate>{ rate }</rate>| &&
         |<cd_percent>{  cdper }</cd_percent>| &&
         |<netrate>{ netpriceamount }</netrate>| &&
      |</tableDataRows>| .
*      |</tblRemarkRowTable>| .

      CONCATENATE xsml lv_xml2 INTO  xsml .


    ENDLOOP .

*LOOPING DATA END
************************************

    DATA total TYPE p DECIMALS 2 .
    DATA bas TYPE  string .
    DATA bas1 TYPE  string .
    DATA bas2 TYPE  string .
    DATA bas3 TYPE  string .
    DATA cart_p TYPE string.
    DATA discount_rate1 TYPE string.

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement  WHERE
    conditiontype IN ( 'ZFFA' ,'ZFMK','ZFDO','ZFOC' ) AND salesorder = @salesorderno  INTO @DATA(freight)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
         conditiontype =  'ZFFA'   AND salesorder = @salesorderno  INTO @DATA(freight_ffa)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
         conditiontype IN ( 'ZD02' )   AND salesorder = @salesorderno  INTO @DATA(discount)  .

    SELECT SINGLE conditionrateratio FROM i_salesorderitempricingelement WHERE conditiontype =  'ZD02'
         AND salesorder = @salesorderno INTO @DATA(discount_rate)  .
    discount_rate1 = discount_rate.
    CONCATENATE '(' discount_rate1+0(3) '%'  ')' INTO discount_rate1 .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
         conditiontype IN ( 'ZD03' )   AND salesorder = @salesorderno  INTO @DATA(discount_fix_amt)  .

    SELECT SUM( conditionrateamount ) FROM i_salesorderitempricingelement WHERE
         conditiontype =  'ZD03'   AND salesorder = @salesorderno  INTO @DATA(disc_fix_p)  .

*      if discount is not INITIAL .
* data(discount_rate1) = discount_rate && '%' .
*
* endif .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
   conditiontype IN ( 'ZFFA' ) AND salesorder = @salesorderno  INTO @DATA(freight_fix)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
   conditiontype EQ  'ZLDA' AND salesorder = @salesorderno  INTO @DATA(loading)  .


    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
   conditiontype EQ  'ZP01' AND salesorder = @salesorderno   INTO @DATA(packing)  .


    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
    conditiontype IN ( 'ZINS','ZDIN', 'ZI01' ) AND salesorder = @salesorderno INTO @DATA(ins)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
    conditiontype IN ( 'JTC1' , 'JTCB' , 'JTC2' ) AND salesorder = @salesorderno INTO @DATA(tcs)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
    conditiontype IN ( 'ZROF' ) AND salesorder = @salesorderno INTO @DATA(rof)  .


    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
    conditiontype IN ( 'JOSG', 'JOCG','JOIG','JOUG' )  AND salesorder = @salesorderno INTO @DATA(gst)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
    conditiontype IN ( 'JOSG' )  AND salesorder = @salesorderno INTO @DATA(sgst)  .
    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
    conditiontype IN ( 'JOCG' )  AND salesorder = @salesorderno INTO @DATA(cgst)  .
    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
    conditiontype IN ( 'JOIG' )  AND salesorder = @salesorderno INTO @DATA(igst1)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
     conditiontype =  'ZMND'   AND salesorder = @salesorderno  INTO @DATA(mnd_amt)  .
    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
     conditiontype =  'ZROL'   AND salesorder = @salesorderno  INTO @DATA(roll_amt)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement WHERE
     conditiontype =  'ZC01'   AND salesorder = @salesorderno  INTO @DATA(cart_amt)  .
    SELECT SUM( conditionrateamount ) FROM i_salesorderitempricingelement WHERE
     conditiontype =  'ZC01'   AND salesorder = @salesorderno  INTO @DATA(cart_per)  .
    cart_p = cart_per.
*      CONCATENATE '(' CART_P+0(3) '%'  ')' INTO CART_P .


    CLEAR bas .

    SELECT  * FROM  i_address_2 INTO TABLE  @DATA(address)  .

    SELECT SINGLE * FROM i_salesorderitempricingelement WHERE conditiontype IN ( 'JOSG',  'JOCG' )
    AND salesorder = @salesorderno INTO @DATA(cgst_rate)  .
    IF cgst_rate IS NOT INITIAL .
      bas  =  cgst_rate-conditionrateratio .
      CONCATENATE '(' bas+0(3) '%' ')' INTO bas .
    ENDIF .

    SELECT SINGLE * FROM i_salesorderitempricingelement WHERE conditiontype IN ( 'JOIG' )
    AND salesorder = @salesorderno INTO @DATA(igst_rate)  .
    IF igst_rate IS NOT INITIAL .
      bas1  =  igst_rate-conditionrateratio.
      CONCATENATE '(' bas1+0(3) '%'  ')' INTO bas1 .
    ENDIF .

*      SELECT SINGLE * FROM I_SalesOrderItemPricingElement WHERE conditiontype IN ( 'ZTCS','JTC1' )
*      AND SalesOrder = @salesorderno INTO @DATA(tcs_rate)  .
*      IF tcs_rate IS NOT INITIAL .
*        bas2  = tcs_rate-conditionrateratio . .
*        CONCATENATE '('  bas2+0(4) '%' ')' INTO bas2 .
*      ENDIF .

    SELECT SINGLE * FROM i_salesorderitempricingelement WHERE conditiontype IN ( 'JTCB' )
    AND salesorder = @salesorderno INTO @DATA(tcs_rate)  .
    IF tcs_rate IS NOT INITIAL .
      bas2  = tcs_rate-conditionrateratio . .
      CONCATENATE '('  bas2+0(4) '%' ')' INTO bas2 .
    ENDIF .

*    DATA grandtotal TYPE zpdec2 .
    DATA grandtotal1 TYPE string .
*    DATA roundoff TYPE zpdec2 .

*      grandtotal  = subtot + freight + ins + gst +  tcs + loading  + packing .
*    grandtotal  = ins + gst +  tcs + loading  + packing  + freight_fix  + discount + mnd_amt + roll_amt.
*    grandtotal1 = grandtotal .
*    SPLIT grandtotal1 AT '.' INTO DATA(a) DATA(b) .
*
*    IF b GE 50 .
*      grandtotal = a + 1 .
*      roundoff = grandtotal - grandtotal1 .
*    ELSE .
*      grandtotal = a .
*      roundoff = grandtotal - grandtotal1 .
*
*    ENDIF .

    DATA amt TYPE p DECIMALS 2.
    """""""""""""""""""""""""""""""""add nsp """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement  WHERE
    conditiontype IN ( 'ZR00' ,'ZR01' ) AND salesorder = @salesorderno INTO @DATA(netamtn)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement  WHERE
    conditiontype IN ( 'ZCHD','ZD02','ZD03' ) AND salesorder = @salesorderno INTO @DATA(disamtn)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement  WHERE
    conditiontype IN ( 'ZI01','ZI02' ) AND salesorder = @salesorderno INTO @DATA(insurance)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement  WHERE
    conditiontype IN ( 'JOIG','JOCG','JOSG' )  AND salesorder = @salesorderno INTO @DATA(gstn)  .

    SELECT SUM( conditionamount ) FROM  i_salesorderitempricingelement  WHERE
conditiontype IN ( 'ZC01','ZP01','ZPOS','ZP02' )  AND salesorder = @salesorderno INTO @DATA(oth)  .



    amt = netamtn + disamtn.
    DATA(total_amt)   =  amt + gstn + insurance + oth.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    TYPES: BEGIN OF ty1,
             batch TYPE string,
           END OF ty1 .
    DATA : batch1 TYPE TABLE OF ty1 .
*    SELECT SINGLE * FROM zinv_tmg_table WHERE plant = @plant INTO @DATA(policy).

    DATA bci TYPE string.

    DATA(lv_xml3) =
    |</tblRemarkRowTable>| &&
|<total_rolls></total_rolls>| &&
 |<total_qty></total_qty>| &&
 |<total_rate></total_rate>| &&
 |<total_net_rate></total_net_rate>| &&
 |<txtDocumentID></txtDocumentID>| &&
 |<txtChangedDocument></txtChangedDocument>| &&
 |<txtDocumentTypeName></txtDocumentTypeName>| &&
 |<Loading></Loading>| &&
 |<Packing>{ packing }</Packing>| &&
 |<Insurance>{ insurance }</Insurance>| &&
 |<FrieightCharge>{ freight }</FrieightCharge>| &&
 |<DiscountP>{ discount_rate1 }</DiscountP>| &&
 |<DiscountAmount>{ discount }</DiscountAmount>| &&
*     |<Discount_fix_amt>{ disc_fix_p }</Discount_fix_amt>| &&
 |<Discount_fix_amt></Discount_fix_amt>| &&
   |<DiscountfixAmount>{ discount_fix_amt }</DiscountfixAmount>| &&
|<DiscountfixAmount></DiscountfixAmount>| &&
   |<Amount>{ amt }</Amount>| &&
*   |<CartageP>{ CART_P }</CartageP>| &&
 |<CartageP></CartageP>| &&
 |<Cartage_amt>{ cart_amt }</Cartage_amt>| &&
 |<Amount></Amount>| &&
 |<GstP>{ bas1 }</GstP>| &&
 |<GstAmount>{ igst1 }</GstAmount>| &&
 |<CGSTP>{ bas }</CGSTP>| &&
 |<CgstAmount>{ cgst }</CgstAmount>| &&
 |<SGSTP>{ bas }</SGSTP>| &&
 |<SgstAmount>{ sgst }</SgstAmount>| &&
*   |<TCSP>{ bas2 }</TCSP>| &&
    |<TCSP></TCSP>| &&
 |<TCSAmount>{ tcs }</TCSAmount>| &&
   |<PLANT>{ plant }</PLANT>| &&
 |<InvoiceValue></InvoiceValue>| &&
 |<Roundedoff>{ rof }</Roundedoff>| &&
 |<TotalInvoiceAmount>{ total_amt }</TotalInvoiceAmount>| &&
 |<Subform2>| &&
* |<InsuredBY>{ policy-policyname }</InsuredBY>| &&
* |<PolicyNo>{ policy-policynumber }</PolicyNo>| &&
 |<ACNO1>{ soldtoparty-e-bankaccount }</ACNO1>| &&
 |</Subform2>| &&
 |<Terms>| &&
    |<PricingConditions>| &&
       |<FrieightChargeNew></FrieightChargeNew>| &&
    |</PricingConditions>| &&
 |</Terms>| &&
|</Form>|.


    CONCATENATE lv_xml xsml lv_xml3 INTO lv_xml .

    REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH 'and'.


*    CALL METHOD ycl_test_adobe=>getpdf(
*      EXPORTING
*        xmldata  = lv_xml
*        template = lc_template_name
*      RECEIVING
*        result   = result12 ).

  ENDMETHOD.
ENDCLASS.
