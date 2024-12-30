@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'data defination for travel'
define root view entity zdd_travel as select from /dmo/travel as Travel
composition [0..*] of Z_DD_BOOK as _Booking
association [0..1] to /DMO/I_Agency as _Agency on $projection.AgencyId = _Agency.AgencyID
association [0..1] to /DMO/I_Customer as _Customer on $projection.CustomerId = _Customer.CustomerID
association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
{
 @EndUserText.label: 'Travel Id:'
 @UI.identification: [{ position: 1 , label : 'Travel Id'}]
key Travel.travel_id as TravelId,

@UI.facet: [{ 
type: #IDENTIFICATION_REFERENCE,
label: 'Employee Details report',
purpose: #STANDARD
 }]

 @EndUserText.label: 'Agency Id:'
 @UI.identification: [{ position: 2 , label : 'Agency Id'}]
Travel.agency_id as AgencyId,

 @EndUserText.label: 'customer Id:'
 @UI.identification: [{ position: 3 , label : 'Customer Id'}]
Travel.customer_id as CustomerId,

 @EndUserText.label: 'Begin date:'
 @UI.identification: [{ position: 4 , label : 'Begin date'}]
Travel.begin_date as BeginDate,

 @EndUserText.label: 'End date:'
 @UI.identification: [{ position: 5 , label : 'End date'}]
Travel.end_date as EndDate,

 @EndUserText.label: 'Booking fee:'
 @UI.identification: [{ position: 6 , label : 'Booking fee'}]
@Semantics.amount.currencyCode: 'CurrencyCode'
Travel.booking_fee as BookingFee,

 @EndUserText.label: 'Total price:'
 @UI.identification: [{ position: 7 , label : 'Total price'}]
@Semantics.amount.currencyCode: 'CurrencyCode'
Travel.total_price as TotalPrice,

 @EndUserText.label: 'currency code'
 @UI.identification: [{ position: 8 , label : 'currency code'}]
Travel.currency_code as CurrencyCode,


 @EndUserText.label: 'desc:'
 @UI.identification: [{ position: 9 , label : 'desc'}]
Travel.description as Description,

 @EndUserText.label: 'status:'
 @UI.identification: [{ position: 10 , label : 'status'}]
Travel.status as Status,


 @EndUserText.label: 'last chnaged at:'
 @UI.identification: [{ position: 11 , label : 'last changed at'}]
Travel.lastchangedat as LastChangedAt,
_Booking,
_Agency,
_Customer,
_Currency
}
