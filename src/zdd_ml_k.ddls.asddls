//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: false
@ObjectModel.query.implementedBy: 'ABAP:ZCLASS_MAT_LIST_K'
@UI.headerInfo: {typeName: 'ml REPORT', typeNamePlural:'count'}
@EndUserText.label: 'data defination for material list rep'
define custom entity zdd_ml_k 
{
  @UI.selectionField: [{ position: 1 }] // Select-Options
      @UI.lineItem: [{ position: 1, label: 'Material' }] // F-cat
  key Material : abap.char(40);


      @UI.selectionField: [{ position: 2 }]
      @UI.lineItem: [{ position: 2, label: 'plant' }]
      plant    : abap.char(4);


      @UI.selectionField: [{ position: 3 }]
      @UI.lineItem: [{ position: 3, label: 'Created On' }]
      Dt       : abap.dats;

      @UI.selectionField: [{ position: 4 }]
      @UI.lineItem: [{ position: 4, label: 'Material Type' }]
      m_typ    : abap.char(4);


      @UI.selectionField: [{ position: 5 }]
      @UI.lineItem: [{ position: 5, label: 'Material Group' }]
      m_grp    : abap.char(9);
      
      
      @UI.lineItem: [{ position: 6, label: 'Material Description Short' }]
  material_desc_shrt : abap.char(40);
  
  
  
   @UI.lineItem: [{ position: 7, label: 'HSN Code' }]
  hsn : abap.char(16);
  
  
  
//  
//   @UI.lineItem: [{ position: 14, label: 'size desc' }]
//  size_desc : abap.char(40);
  
  
    @UI.lineItem: [{ position: 8, label: 'Old Material no' }]
  material_old : abap.char(12);
  
  
    @UI.lineItem: [{ position: 9, label: 'uom' }]
  uom : abap.char(4);
  
    
   @UI.lineItem: [{ position: 10, label: 'price unit' }]
  price_unit : abap.dec(5);
  
   @UI.lineItem: [{ position: 11, label: 'price' }]
  st_price : abap.dec(11);
  
    
   @UI.lineItem: [{ position: 12, label: 'purchasing group' }]
  p_grp : abap.char(3);
  
  
    
   @UI.lineItem: [{ position: 13, label: 'valuation class' }]
  v_cls : abap.char(4);

  
  
  @UI.lineItem: [{ position: 14, label: 'price control' }]
  price_ctrl : abap.char(12);
  
  
  @UI.lineItem: [{ position: 15, label: 'created by' }]
  created_by : abap.char(20);
  
  @UI.lineItem: [{ position: 16, label: 'last changed' }]
  l_chngd : abap.dats;
  
   @UI.lineItem: [{ position: 17, label: 'mrp type' }]
  mrp_ty : abap.char(4);
  
   @UI.lineItem: [{ position: 18, label: 'currency' }]
 currency : abap.cuky(5);
  
  
    
}
