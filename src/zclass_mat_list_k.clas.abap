CLASS zclass_mat_list_k DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLASS_MAT_LIST_K IMPLEMENTATION.


METHOD if_rap_query_provider~select.

  IF io_request->is_data_requested( ).

  DATA: lt_response    TYPE TABLE OF zdd_ml_k,

            ls_response    LIKE LINE OF lt_response,
            lt_responseout LIKE lt_response,
            ls_responseout LIKE LINE OF lt_responseout.



      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

      DATA(lt_clause)        = io_request->get_filter( )->get_as_ranges( ).
      DATA(lt_parameter)     = io_request->get_parameters( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).
    ENDIF.


    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

     LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
      IF ls_filter_cond-name = 'MATERIAL'.
        DATA(lt_mat) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'PLANT'.
        DATA(lt_plant)  = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'DT'.
        DATA(lt_date) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'M_TYP'.
        DATA(lt_mtyp) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'M_GRP'.
        DATA(lt_m_grp) = ls_filter_cond-range[].
      ENDIF.

    ENDLOOP.


    SELECT DISTINCT
    a~product,
    a~productgroup,
    a~Producttype,
    a~ProductOldID,
    a~creationdate,
    a~lastchangedate,
    a~createdbyuser,
    b~plant,
    b~mrptype,
    b~purchasinggroup,
    b~ConsumptionTaxCtrlCode,
    c~productdescription,
    d~valuationclass,
    d~standardprice,
    d~priceunitqty,
    d~inventoryvaluationprocedure,
    d~Currency,
    e~UnitOfMeasure

    FROM i_product as a
    inner join i_productplantbasic as b
    on a~Product = b~Product
    INNER JOIN I_PRODUCTDESCRIPTION_2 as c
    on a~Product = c~Product
   INNER JOIN I_PRODUCTVALUATIONBASIC as d
    ON a~Product = d~Product
    INNER JOIN I_UnitOfMeasureTEXT as e
    on c~Language = e~Language
    WHERE a~Product IN @lt_mat
    AND a~ProductCategory IN @lt_mtyp
    AND a~ProductGroup IN @lt_m_grp
    AND a~CreationDate IN @lt_date
    AND b~Plant in @lt_plant
    and c~Language = 'E'
    INTO TABLE @DATA(it).


    loop at it INTO DATA(wa).
    ls_response-Material = wa-Product.
    ls_response-m_typ = wa-Producttype.
    ls_response-m_grp = wa-ProductGroup.
*    ls_response-size_desc = wa-SizeOrDimensionText.
    ls_response-material_old = wa-ProductOldID.
*    ls_response-uom = wa-BaseUnit.
*    ls_response-price_unit = wa-ComparisonPriceQuantity.
    ls_response-Dt = wa-CreationDate.
    ls_response-l_chngd = wa-LastChangeDate.
    ls_response-created_by = wa-CreatedByUser.
    ls_response-plant = wa-Plant.
    ls_response-mrp_ty = wa-MRPType.
    ls_response-p_grp = wa-PurchasingGroup.
    ls_response-hsn = wa-ConsumptionTaxCtrlCode.
    ls_response-material_desc_shrt = wa-ProductDescription.
    ls_response-price_ctrl = wa-InventoryValuationProcedure.
    ls_response-price_unit = wa-PriceUnitQty.
    ls_response-v_cls = wa-ValuationClass.
    ls_response-st_price = wa-StandardPrice.
    ls_response-currency = wa-Currency.
    ls_response-uom = wa-UnitOfMeasure.
    APPEND ls_response to lt_response.
    clear ls_response.
    ENDLOOP.


     lv_max_rows = lv_skip + lv_top.
    IF lv_skip > 0.
      lv_skip = lv_skip + 1.
    ENDIF.

    CLEAR lt_responseout.
    LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<lfs_out_line_item>) FROM lv_skip TO lv_max_rows.
      ls_responseout = <lfs_out_line_item>.
      APPEND ls_responseout TO lt_responseout.
    ENDLOOP.



    io_response->set_total_number_of_records( lines( lt_response ) ).
    io_response->set_data( lt_responseout ).

ENDMETHOD.
ENDCLASS.
