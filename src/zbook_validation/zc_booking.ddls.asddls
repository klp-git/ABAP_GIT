//@AbapCatalog.sqlViewName: 'ZBOOKING'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root cds entity for booking'
define root view entity zc_booking as select from zbooking
{

@UI.facet: [{ 
type: #IDENTIFICATION_REFERENCE,
label: 'Booking data report',
purpose: #STANDARD
 }]

@EndUserText.label: 'booking Id:'
 @UI.identification: [{ position: 1 , label : 'Booking Id'}]
 key bookingid as BookingId,
 
 
 @EndUserText.label: 'Customer name:'
 @UI.identification: [{ position: 2 , label : 'Customer name'}]
 cust_name as CustomerName,
 
 @EndUserText.label: 'Booking Date:'
 @UI.identification: [{ position: 3 , label : 'Booking Date'}]
 b_date as BookingDate,
 
 
 @EndUserText.label: 'status'
 @UI.identification: [{ position: 4 , label : 'status'}]
 status as Status

}
