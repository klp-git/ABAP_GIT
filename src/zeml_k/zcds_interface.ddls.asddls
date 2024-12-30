@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interfaces cds view user'
define root view entity zcds_interface as select from zdb_user
//composition of target_data_source_name as _association_name
{
    
    key user_id as UserId,
    user_name as Username,
    user_age as Userage
//    _association_name // Make association public
}
