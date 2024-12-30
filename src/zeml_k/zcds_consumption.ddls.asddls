@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption cds'
@Metadata.allowExtensions: true
define root view entity zcds_consumption
  as select from zcds_interface
  //composition of target_data_source_name as _association_name
{

      //    _association_name // Make association public
  key UserId,
      Username,
      Userage


}
