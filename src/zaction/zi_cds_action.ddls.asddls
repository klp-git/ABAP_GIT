@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interfaces cds view student'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}
define root view entity zi_cds_action
  as select from zdb_student
{

  key id              as Id,
      firstname       as Firstname,
      lastname        as Lastname,
      age             as Age,
      course          as Course,
      course_duration as CourseDuration,
      status          as Status,
      gender          as Gender,
      dob             as Dob,
      course_fees     as CourseFees




}
//composition of target_data_source_name as _association_name
//{
//
//    _association_name // Make association public
//}
