//@AbapCatalog.sqlViewName: 'Z_RAP_SO_K'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for sale order rap'
@Metadata.allowExtensions: true
define root view entity zcds_rap_so_k as select from zrap_so_k
{
@UI.facet: [{ 
type: #IDENTIFICATION_REFERENCE,
label: 'Sales order',
purpose: #STANDARD
 }]
 
 @EndUserText.label: 'SaleOrder'
 @UI.identification: [{ position: 1 , label : 'Sales Order'}]
  key so_id as SoId,  
  
  
  @UI.identification: [{ position: 2 , label : 'Customer' }] 
  @EndUserText.label: 'Customer'
  customer as Customer, 
      
  @UI.identification: [{ position: 3 , label : 'Gross Amount' }]
  @EndUserText.label: 'GrossAmount'
  gross_amount as GrossAmount,

  @UI.identification: [{ position: 4 , label : 'Currency Code ' }]
  @EndUserText.label: 'CurrencyCode'
  currency_code as CurrencyCode,
  
  @UI.identification: [{ position: 5  , label : 'Order Status'}]
  @EndUserText.label: 'OrderStatus'
  order_status as OrderStatus 


    
}
