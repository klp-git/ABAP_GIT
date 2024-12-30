@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption cds'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zc_action
  provider contract transactional_query
  as projection on zi_cds_action as Student
{

      @EndUserText.label: 'Student Id'
  key Id,

      @EndUserText.label: 'First Name'
      Firstname,

      @EndUserText.label: 'Last Name'
      Lastname,

      @EndUserText.label: 'Age'
      Age,

      @EndUserText.label: 'Course'
      Course,

      @EndUserText.label: 'CourseDuration'
      CourseDuration,

      @EndUserText.label: 'Status'
      Status,

      @EndUserText.label: 'Gender'
      Gender,


      @EndUserText.label: 'DOB'
      Dob,
      
       @EndUserText.label: 'Course Fees'
       CourseFees
      

}
