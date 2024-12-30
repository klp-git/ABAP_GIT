//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for emp details'
@Metadata.allowExtensions: true
define root view entity zemp_cds_k as select from zemp_table_k
{
@UI.facet: [{ 
type: #IDENTIFICATION_REFERENCE,
label: 'Employee Details report',
purpose: #STANDARD
 }]
 
 
  @EndUserText.label: 'Emp Id:'
 @UI.identification: [{ position: 1 , label : 'Emp Id'}]
  key emp_id as EmpId,
  
  
   @EndUserText.label: 'Emp name:'
 @UI.identification: [{ position: 2 , label : 'Emp Name'}]
  emp_name as EmployeeName,
  
  
  
   @EndUserText.label: 'City:'
 @UI.identification: [{ position: 3 , label : 'City'}]
 city as City,
 
  @EndUserText.label: 'Designamtion :'
 @UI.identification: [{ position: 4 , label : 'Designation'}]
 designation as Designation,
 
 
  @EndUserText.label: 'Age :'
 @UI.identification: [{ position: 5 , label : 'Age'}]
 age as Age
 
 
  
  
 
 
 
  }
 